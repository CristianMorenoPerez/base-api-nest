CREATE OR REPLACE FUNCTION login(emailIn VARCHAR(80)) 
RETURNS JSON AS $$
DECLARE 
    response JSON;
BEGIN
   IF NOT EXISTS (SELECT 1 FROM users WHERE email = emailIn AND "isActive" = true) THEN
        RAISE EXCEPTION 'El email % no existe o el usuario no está activo', emailIn;
    END IF;
    response := (
        SELECT json_build_object(
            'id', T0.id,
            'email', T0.email,
            'password', T0.password,
            'userType', json_build_object('id', T2.id, 'name', T2.name),
            'tenant', json_build_object('id', T1.id, 'name', T1.name, 'address', T1.address, 'phone', T1.phone, 'email', T1.email),
            'tenantType', json_build_object('id', T3.id, 'name', T3.name),
            'permissions', (
                SELECT JSON_AGG(sections)
                FROM (
                    SELECT DISTINCT ON (user_id, T3."sectionsId")
                        user_id,
                        json_build_object(
                            'id', T3."sectionsId",
                            'name', T3.section,
                            'icon', T3.section_icon,
								'path', T3.section_path,
                            'options', (
                                SELECT JSON_AGG(options)
                                FROM (
                                    SELECT json_build_object(
                                        'id', "optionId",
                                        'code', option_code,
                                        'name', option_name,
                                        'icon', option_icon,
                                        'path', option_path,
                                       'permissions', JSON_AGG(  json_build_object('name',permission ,'code',permission_code))
                                    ) AS options
                                    FROM user_permissions_view
                                    WHERE user_id = T3.user_id AND "sectionsId" = T3."sectionsId"
                                    GROUP BY "optionId", option_code, option_name, option_icon, option_path
                                ) AS options_list
                            )
                        ) AS sections
                    FROM user_permissions_view T3
                ) AS TX
                WHERE TX.user_id = T0.id
            )
        ) AS data
        FROM users T0
        INNER JOIN "userTypes" T2 ON T0."userTypeId" = T2.id
        INNER JOIN tenants T1 ON T1."userId" = T0.id
        INNER JOIN "tenantTypes" T3 ON T3.id = T1."tenantTypeId"
        WHERE T0."isActive" = true AND T0.email = emailIn
    );

    RETURN response;
END;
$$ LANGUAGE plpgsql;