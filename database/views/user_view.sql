CREATE OR REPLACE VIEW public.user_permissions_view
AS
SELECT COALESCE(t2."userId", t0.id) AS user_id,
    t0.email,
    t0."userTypeId",
    t1.name AS user_type,
    t3."sectionsId",
    t4.code AS section_code,
    t4.name AS section,
    t4.icon AS section_icon,
    t4.path AS section_path,
    t2."optionId",
    t3.code AS option_code,
    t3.name AS option_name,
    t3.icon AS option_icon,
    t3.path AS option_path,
    t2."permissionId",
    t5.code AS permission_code,
    t5.name AS permission
FROM users t0
    JOIN "userTypes" t1 ON t0."userTypeId" = t1.id
    LEFT JOIN user_permissions t2 ON (t0.id = t2."userId" OR t1.id = t2."userTypeId") AND t2."isActive"
IS TRUE
     LEFT JOIN options t3 ON t2."optionId" = t3.id
     LEFT JOIN sections t4 ON t3."sectionsId" = t4.id
     LEFT JOIN permissions t5 ON t2."permissionId" = t5.id;