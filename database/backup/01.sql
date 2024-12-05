--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3 (Debian 14.3-1.pgdg110+1)
-- Dumped by pg_dump version 16.4

-- Started on 2024-11-09 21:54:08

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 38075)
-- Name: login(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.login(emailin character varying) RETURNS json
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.login(emailin character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 37988)
-- Name: option_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.option_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "optionId" UUID NOT NULL,
    "permissionId" UUID NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.option_permissions OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 37979)
-- Name: options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.options (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    icon VARCHAR(40) NOT NULL,
    code VARCHAR(20) NOT NULL,
    name VARCHAR(60) NOT NULL,
    path VARCHAR(40) NOT NULL,
    "sectionsId" UUID NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.options OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 37997)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(60) NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 37970)
-- Name: sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    icon VARCHAR(40) NOT NULL,
    code VARCHAR(20) NOT NULL,
    name VARCHAR(60) NOT NULL,
    path VARCHAR(40),
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.sections OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 37961)
-- Name: tenantTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tenantTypes" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(60) NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."tenantTypes" OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 37952)
-- Name: tenants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(60) NOT NULL,
    address VARCHAR(80) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(150) NOT NULL,
    "tenantTypeId"  UUID NOT NULL,
    "userId"  UUID NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy"  UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tenants OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 37934)
-- Name: userTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."userTypes" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(60) NOT NULL,
    "tenantId"  UUID NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy"  UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."userTypes" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 37943)
-- Name: user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" UUID NOT NULL,
    "userTypeId" UUID NOT NULL,
    "optionId" UUID NOT NULL ,
    "permissionId" UUID NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.user_permissions OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 37925)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(60) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password text NOT NULL,
    "userTypeId" UUID NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" UUID  DEFAULT NULL,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;



ALTER TABLE public.tenants
ADD CONSTRAINT fk_tenant_tenantType FOREIGN KEY ("tenantTypeId") REFERENCES public."tenantTypes"(id) ON DELETE CASCADE;

-- Foreign key for `tenants.userId` referencing `users.id`
ALTER TABLE public.tenants
ADD CONSTRAINT fk_tenant_user FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;

-- Foreign key for `userTypes.tenantId` referencing `tenants.id`
ALTER TABLE public."userTypes"
ADD CONSTRAINT fk_userTypes_tenant FOREIGN KEY ("tenantId") REFERENCES public.tenants(id) ON DELETE CASCADE;

-- Foreign key for `user_permissions.userId` referencing `users.id`
ALTER TABLE public.user_permissions
ADD CONSTRAINT fk_userPermissions_user FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;

-- Foreign key for `user_permissions.userTypeId` referencing `userTypes.id`
ALTER TABLE public.user_permissions
ADD CONSTRAINT fk_userPermissions_userType FOREIGN KEY ("userTypeId") REFERENCES public."userTypes"(id) ON DELETE CASCADE;

-- Foreign key for `user_permissions.optionId` referencing `options.id`
ALTER TABLE public.user_permissions
ADD CONSTRAINT fk_userPermissions_option FOREIGN KEY ("optionId") REFERENCES public.options(id) ON DELETE CASCADE;

-- Foreign key for `user_permissions.permissionId` referencing `permissions.id`
ALTER TABLE public.user_permissions
ADD CONSTRAINT fk_userPermissions_permission FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) ON DELETE CASCADE;

-- Foreign key for `options.sectionsId` referencing `sections.id`
ALTER TABLE public.options
ADD CONSTRAINT fk_options_section FOREIGN KEY ("sectionsId") REFERENCES public.sections(id) ON DELETE CASCADE;

-- Foreign key for `option_permissions.optionId` referencing `options.id`
ALTER TABLE public.option_permissions
ADD CONSTRAINT fk_optionPermissions_option FOREIGN KEY ("optionId") REFERENCES public.options(id) ON DELETE CASCADE;

-- Foreign key for `option_permissions.permissionId` referencing `permissions.id`
ALTER TABLE public.option_permissions
ADD CONSTRAINT fk_optionPermissions_permission FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) ON DELETE CASCADE;

-- Unique constraint on `users.email` to ensure no duplicate emails
ALTER TABLE public.users
ADD CONSTRAINT uq_users_email UNIQUE (email);

-- Unique constraint on `options.code` to ensure each option has a unique code
ALTER TABLE public.options
ADD CONSTRAINT uq_options_code UNIQUE (code);

-- Unique constraint on `permissions.code` to ensure each permission has a unique code
ALTER TABLE public.permissions
ADD CONSTRAINT uq_permissions_code UNIQUE (code);

-- Unique constraint on `userTypes.name` to ensure each user type has a unique name within the same tenant
ALTER TABLE public."userTypes"
ADD CONSTRAINT uq_userTypes_name_tenant UNIQUE (name, "tenantId");

-- Unique constraint on `sections.code` to ensure each section has a unique code
ALTER TABLE public.sections
ADD CONSTRAINT uq_sections_code UNIQUE (code);

-- Unique constraint on `tenants.email` to ensure no duplicate emails in tenants
ALTER TABLE public.tenants
ADD CONSTRAINT uq_tenants_email UNIQUE (email);

-- Unique constraint on `option_permissions.optionId, permissionId` to avoid duplicate option-permission combinations
ALTER TABLE public.option_permissions
ADD CONSTRAINT uq_option_permissions UNIQUE ("optionId", "permissionId");

-- Unique constraint on `user_permissions.userId, userTypeId, optionId, permissionId` to avoid duplicate permission assignments
ALTER TABLE public.user_permissions
ADD CONSTRAINT uq_user_permissions UNIQUE ("userId", "userTypeId", "optionId", "permissionId");

