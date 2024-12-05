--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3 (Debian 14.3-1.pgdg110+1)
-- Dumped by pg_dump version 16.4

-- Started on 2024-12-02 11:38:37

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
-- TOC entry 5 (class 2615 OID 40961)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 230 (class 1255 OID 41129)
-- Name: login(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.login(emailin character varying) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE 
    response JSON;
BEGIN
   IF NOT EXISTS (SELECT 1 FROM public.users WHERE email = emailIn AND "isActive" = true) THEN
        RAISE EXCEPTION 'El email % no existe o el usuario no está activo', emailIn;
    END IF;
    response := (
            SELECT json_build_object(
            'id', T0.id,
            'email', T0.email,
            'password', T0.password,
            'userType', json_build_object('id', T2.id, 'name', T2.name),
            'tenants', (
                SELECT JSON_AGG(
                    json_build_object(
                        'id', T1.id,
                        'name', T1.name,
                        'address', T1.address,
                        'phone', T1.phone,
                        'email', T1.email,
                        'tenantType', json_build_object('id', T5.id, 'name', T5.name)
                    )
                )
                FROM public.tenants  T1
                LEFT JOIN public."userTenants"   T3 ON T3."tenantId" = T1.id
                LEFT JOIN public.users T4 ON T4.id = T3."userId"
                INNER JOIN public."tenantTypes" T5 on T1."tenantTypeId" = T5.id 
                WHERE T4.id = T0.id
            ),
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
                                        'permissions', JSON_AGG(json_build_object('name', permission, 'code', permission_code))
                                    ) AS options
                                    FROM public.user_permissions_view
                                    WHERE user_id = T3.user_id AND "sectionsId" = T3."sectionsId"
                                    GROUP BY "optionId", option_code, option_name, option_icon, option_path
                                ) AS options_list
                            )
                        ) AS sections
                    FROM public.user_permissions_view T3
                ) AS TX
                WHERE TX.user_id = T0.id
            )
        ) AS data
FROM public.users T0
INNER JOIN public."userTypes" T2 ON T0."userTypeId" = T2.id
WHERE T0."isActive" = true AND T0.email =  emailIn
    );

    RETURN response;
END;
$$;


ALTER FUNCTION public.login(emailin character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 216 (class 1259 OID 41020)
-- Name: options; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.options (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    icon character varying(40) NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(60) NOT NULL,
    path character varying(40) NOT NULL,
    "sectionsId" uuid NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.options OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 41036)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(60) NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 41012)
-- Name: sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    icon character varying(40) NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(60) NOT NULL,
    path character varying(40),
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.sections OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 41004)
-- Name: tenantTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tenantTypes" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(60) NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."tenantTypes" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 40980)
-- Name: tenants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(60) NOT NULL,
    address character varying(80) NOT NULL,
    phone character varying(15) NOT NULL,
    email character varying(150) NOT NULL,
    "tenantTypeId" uuid NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tenants OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 40972)
-- Name: userTenants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."userTenants" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "userId" uuid NOT NULL,
    "tenantId" uuid NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."userTenants" OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 40988)
-- Name: userTypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."userTypes" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(60) NOT NULL,
    "tenantId" uuid NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."userTypes" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 40996)
-- Name: user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_permissions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "userId" uuid,
    "userTypeId" uuid,
    "optionId" uuid NOT NULL,
    "permissionId" uuid NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.user_permissions OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 40962)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(60) NOT NULL,
    email character varying(150) NOT NULL,
    password text NOT NULL,
    "userTypeId" uuid NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdBy" uuid,
    "updatedAt" timestamp(0) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 41124)
-- Name: user_permissions_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.user_permissions_view AS
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
   FROM (((((public.users t0
     JOIN public."userTypes" t1 ON ((t0."userTypeId" = t1.id)))
     LEFT JOIN public.user_permissions t2 ON ((((t0.id = t2."userId") OR (t1.id = t2."userTypeId")) AND (t2."isActive" IS TRUE))))
     LEFT JOIN public.options t3 ON ((t2."optionId" = t3.id)))
     LEFT JOIN public.sections t4 ON ((t3."sectionsId" = t4.id)))
     LEFT JOIN public.permissions t5 ON ((t2."permissionId" = t5.id)));


ALTER VIEW public.user_permissions_view OWNER TO postgres;

--
-- TOC entry 3413 (class 0 OID 41020)
-- Dependencies: 216
-- Data for Name: options; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.options (id, icon, code, name, path, "sectionsId", "isActive", "createdBy", "updatedAt", "createdAt") FROM stdin;
748cc974-455c-43c3-9b17-40ad4ef110fa	storefront	tenantType-01	tipos de inquilinos	tenant-types	721f9119-7b40-4fc1-86ca-31c99770aaf4	t	\N	\N	2024-11-30 21:19:31.579
b44a2d9e-2335-40e2-b6ce-28e9611c0efe	apps	00O-1	secciones	sections	721f9119-7b40-4fc1-86ca-31c99770aaf4	t	\N	\N	2024-11-30 00:04:28.652
\.


--
-- TOC entry 3414 (class 0 OID 41036)
-- Dependencies: 217
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, code, name, "isActive", "createdBy", "updatedAt", "createdAt") FROM stdin;
bb093361-40c9-487a-bc9d-1baaaf517761	R	Read Permission	t	\N	\N	2024-11-30 00:04:33.657
f367c602-14d8-4c7f-8b02-061cf7b751c6	W	Write Permission	t	\N	\N	2024-11-30 00:04:33.657
d183aa10-4ecc-4879-9a12-ca6689117142	U	update Permission	t	\N	\N	2024-11-30 00:04:33.657
6b0d3fe1-5d99-41d1-9686-1fa85abf7e43	D	delete Permission	t	\N	\N	2024-11-30 00:04:33.657
\.


--
-- TOC entry 3412 (class 0 OID 41012)
-- Dependencies: 215
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sections (id, icon, code, name, path, "isActive", "createdBy", "updatedAt", "createdAt") FROM stdin;
721f9119-7b40-4fc1-86ca-31c99770aaf4	tune	00S-1	Ajustes	settings	t	\N	\N	2024-11-30 00:03:01.886
\.


--
-- TOC entry 3411 (class 0 OID 41004)
-- Dependencies: 214
-- Data for Name: tenantTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tenantTypes" (id, name, "isActive", "createdBy", "updatedAt", "createdAt") FROM stdin;
f5f935f5-4a22-48ad-903a-4e559ccb5b7a	ROOT	t	\N	\N	2024-11-29 23:45:33.934
4392d116-decf-40db-ac69-b66af8337d2c	root3	f	\N	\N	2024-11-30 19:02:39.264
45e4a781-b8e9-4e31-b598-cfa4a64516e9	fundacion de la mujer3	f	\N	\N	2024-11-30 23:03:07.911
\.


--
-- TOC entry 3408 (class 0 OID 40980)
-- Dependencies: 211
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenants (id, name, address, phone, email, "tenantTypeId", "isActive", "createdBy", "updatedAt", "createdAt") FROM stdin;
80422063-b2c4-4812-ad19-6bf03170ca11	super root	stree	00000	superSu@tenant.com	f5f935f5-4a22-48ad-903a-4e559ccb5b7a	t	\N	\N	2024-11-29 23:56:35.897
\.


--
-- TOC entry 3407 (class 0 OID 40972)
-- Dependencies: 210
-- Data for Name: userTenants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."userTenants" (id, "userId", "tenantId", "isActive", "createdAt") FROM stdin;
77d7dd2b-d04f-441b-a79a-4438aa0e9e93	500d1b43-b430-475a-ac36-ea1ed7a02d38	80422063-b2c4-4812-ad19-6bf03170ca11	t	2024-11-30 00:26:54.733
\.


--
-- TOC entry 3409 (class 0 OID 40988)
-- Dependencies: 212
-- Data for Name: userTypes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."userTypes" (id, name, "tenantId", "isActive", "createdBy", "updatedAt", "createdAt") FROM stdin;
2fa1238c-322f-423e-9c1e-50589ef1bb13	ROOT	80422063-b2c4-4812-ad19-6bf03170ca11	t	\N	\N	2024-11-29 23:57:37.869
\.


--
-- TOC entry 3410 (class 0 OID 40996)
-- Dependencies: 213
-- Data for Name: user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_permissions (id, "userId", "userTypeId", "optionId", "permissionId", "isActive", "createdBy", "updatedAt", "createdAt") FROM stdin;
51b65c72-df69-469a-870e-3ee2af5bd49f	500d1b43-b430-475a-ac36-ea1ed7a02d38	\N	b44a2d9e-2335-40e2-b6ce-28e9611c0efe	6b0d3fe1-5d99-41d1-9686-1fa85abf7e43	t	\N	\N	2024-11-30 00:06:12.062
0a13d7f4-d853-493a-a765-49dd68969a26	500d1b43-b430-475a-ac36-ea1ed7a02d38	\N	748cc974-455c-43c3-9b17-40ad4ef110fa	6b0d3fe1-5d99-41d1-9686-1fa85abf7e43	t	\N	\N	2024-11-30 16:21:24.355
\.


--
-- TOC entry 3406 (class 0 OID 40962)
-- Dependencies: 209
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, "userTypeId", "isActive", "createdBy", "updatedAt", "createdAt") FROM stdin;
500d1b43-b430-475a-ac36-ea1ed7a02d38	super admin	super.admin@example.com	$2b$10$Ppl9CoCIeXBbsh.fhXxAaOTlE3QVBSFvUbBl7FwJZm8wf0CtZVrcK	2fa1238c-322f-423e-9c1e-50589ef1bb13	t	\N	\N	2024-11-30 05:02:16.717
\.


--
-- TOC entry 3251 (class 2606 OID 41027)
-- Name: options options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- TOC entry 3254 (class 2606 OID 41043)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3248 (class 2606 OID 41019)
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3246 (class 2606 OID 41011)
-- Name: tenantTypes tenantTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tenantTypes"
    ADD CONSTRAINT "tenantTypes_pkey" PRIMARY KEY (id);


--
-- TOC entry 3237 (class 2606 OID 40987)
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- TOC entry 3234 (class 2606 OID 40979)
-- Name: userTenants userTenants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTenants"
    ADD CONSTRAINT "userTenants_pkey" PRIMARY KEY (id);


--
-- TOC entry 3241 (class 2606 OID 40995)
-- Name: userTypes userTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTypes"
    ADD CONSTRAINT "userTypes_pkey" PRIMARY KEY (id);


--
-- TOC entry 3244 (class 2606 OID 41003)
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3232 (class 2606 OID 40971)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3252 (class 1259 OID 41050)
-- Name: uq_options_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_options_code ON public.options USING btree (code);


--
-- TOC entry 3255 (class 1259 OID 41052)
-- Name: uq_permissions_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_permissions_code ON public.permissions USING btree (code);


--
-- TOC entry 3249 (class 1259 OID 41049)
-- Name: uq_sections_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_sections_code ON public.sections USING btree (code);


--
-- TOC entry 3238 (class 1259 OID 41046)
-- Name: uq_tenants_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_tenants_email ON public.tenants USING btree (email);


--
-- TOC entry 3242 (class 1259 OID 41048)
-- Name: uq_user_permissions; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_user_permissions ON public.user_permissions USING btree ("userId", "userTypeId", "optionId", "permissionId");


--
-- TOC entry 3230 (class 1259 OID 41044)
-- Name: uq_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_users_email ON public.users USING btree (email);


--
-- TOC entry 3239 (class 1259 OID 41047)
-- Name: uq_usertypes_name_tenant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_usertypes_name_tenant ON public."userTypes" USING btree (name, "tenantId");


--
-- TOC entry 3235 (class 1259 OID 41045)
-- Name: userTenants_userId_tenantId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "userTenants_userId_tenantId_key" ON public."userTenants" USING btree ("userId", "tenantId");


--
-- TOC entry 3265 (class 2606 OID 41098)
-- Name: options fk_options_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT fk_options_section FOREIGN KEY ("sectionsId") REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- TOC entry 3259 (class 2606 OID 41063)
-- Name: tenants fk_tenant_tenanttype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT fk_tenant_tenanttype FOREIGN KEY ("tenantTypeId") REFERENCES public."tenantTypes"(id) ON DELETE CASCADE;


--
-- TOC entry 3256 (class 2606 OID 41119)
-- Name: users fk_user_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_type FOREIGN KEY ("userTypeId") REFERENCES public."userTypes"(id) ON DELETE CASCADE;


--
-- TOC entry 3261 (class 2606 OID 41078)
-- Name: user_permissions fk_userpermissions_option; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT fk_userpermissions_option FOREIGN KEY ("optionId") REFERENCES public.options(id) ON DELETE CASCADE;


--
-- TOC entry 3262 (class 2606 OID 41083)
-- Name: user_permissions fk_userpermissions_permission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT fk_userpermissions_permission FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3263 (class 2606 OID 41088)
-- Name: user_permissions fk_userpermissions_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT fk_userpermissions_user FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3264 (class 2606 OID 41093)
-- Name: user_permissions fk_userpermissions_usertype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT fk_userpermissions_usertype FOREIGN KEY ("userTypeId") REFERENCES public."userTypes"(id) ON DELETE CASCADE;


--
-- TOC entry 3260 (class 2606 OID 41073)
-- Name: userTypes fk_usertypes_tenant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTypes"
    ADD CONSTRAINT fk_usertypes_tenant FOREIGN KEY ("tenantId") REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- TOC entry 3257 (class 2606 OID 41058)
-- Name: userTenants userTenants_tenantId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTenants"
    ADD CONSTRAINT "userTenants_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3258 (class 2606 OID 41053)
-- Name: userTenants userTenants_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTenants"
    ADD CONSTRAINT "userTenants_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2024-12-02 11:38:37

--
-- PostgreSQL database dump complete
--

