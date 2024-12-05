--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3 (Debian 14.3-1.pgdg110+1)
-- Dumped by pg_dump version 16.4

-- Started on 2024-12-02 11:44:36

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
-- TOC entry 3241 (class 2606 OID 41027)
-- Name: options options_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT options_pkey PRIMARY KEY (id);


--
-- TOC entry 3244 (class 2606 OID 41043)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3238 (class 2606 OID 41019)
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- TOC entry 3236 (class 2606 OID 41011)
-- Name: tenantTypes tenantTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tenantTypes"
    ADD CONSTRAINT "tenantTypes_pkey" PRIMARY KEY (id);


--
-- TOC entry 3227 (class 2606 OID 40987)
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- TOC entry 3224 (class 2606 OID 40979)
-- Name: userTenants userTenants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTenants"
    ADD CONSTRAINT "userTenants_pkey" PRIMARY KEY (id);


--
-- TOC entry 3231 (class 2606 OID 40995)
-- Name: userTypes userTypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTypes"
    ADD CONSTRAINT "userTypes_pkey" PRIMARY KEY (id);


--
-- TOC entry 3234 (class 2606 OID 41003)
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3222 (class 2606 OID 40971)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3242 (class 1259 OID 41050)
-- Name: uq_options_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_options_code ON public.options USING btree (code);


--
-- TOC entry 3245 (class 1259 OID 41052)
-- Name: uq_permissions_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_permissions_code ON public.permissions USING btree (code);


--
-- TOC entry 3239 (class 1259 OID 41049)
-- Name: uq_sections_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_sections_code ON public.sections USING btree (code);


--
-- TOC entry 3228 (class 1259 OID 41046)
-- Name: uq_tenants_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_tenants_email ON public.tenants USING btree (email);


--
-- TOC entry 3232 (class 1259 OID 41048)
-- Name: uq_user_permissions; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_user_permissions ON public.user_permissions USING btree ("userId", "userTypeId", "optionId", "permissionId");


--
-- TOC entry 3220 (class 1259 OID 41044)
-- Name: uq_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_users_email ON public.users USING btree (email);


--
-- TOC entry 3229 (class 1259 OID 41047)
-- Name: uq_usertypes_name_tenant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_usertypes_name_tenant ON public."userTypes" USING btree (name, "tenantId");


--
-- TOC entry 3225 (class 1259 OID 41045)
-- Name: userTenants_userId_tenantId_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "userTenants_userId_tenantId_key" ON public."userTenants" USING btree ("userId", "tenantId");


--
-- TOC entry 3255 (class 2606 OID 41098)
-- Name: options fk_options_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options
    ADD CONSTRAINT fk_options_section FOREIGN KEY ("sectionsId") REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- TOC entry 3249 (class 2606 OID 41063)
-- Name: tenants fk_tenant_tenanttype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT fk_tenant_tenanttype FOREIGN KEY ("tenantTypeId") REFERENCES public."tenantTypes"(id) ON DELETE CASCADE;


--
-- TOC entry 3246 (class 2606 OID 41119)
-- Name: users fk_user_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_type FOREIGN KEY ("userTypeId") REFERENCES public."userTypes"(id) ON DELETE CASCADE;


--
-- TOC entry 3251 (class 2606 OID 41078)
-- Name: user_permissions fk_userpermissions_option; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT fk_userpermissions_option FOREIGN KEY ("optionId") REFERENCES public.options(id) ON DELETE CASCADE;


--
-- TOC entry 3252 (class 2606 OID 41083)
-- Name: user_permissions fk_userpermissions_permission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT fk_userpermissions_permission FOREIGN KEY ("permissionId") REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3253 (class 2606 OID 41088)
-- Name: user_permissions fk_userpermissions_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT fk_userpermissions_user FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3254 (class 2606 OID 41093)
-- Name: user_permissions fk_userpermissions_usertype; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT fk_userpermissions_usertype FOREIGN KEY ("userTypeId") REFERENCES public."userTypes"(id) ON DELETE CASCADE;


--
-- TOC entry 3250 (class 2606 OID 41073)
-- Name: userTypes fk_usertypes_tenant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTypes"
    ADD CONSTRAINT fk_usertypes_tenant FOREIGN KEY ("tenantId") REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- TOC entry 3247 (class 2606 OID 41058)
-- Name: userTenants userTenants_tenantId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTenants"
    ADD CONSTRAINT "userTenants_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES public.tenants(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3248 (class 2606 OID 41053)
-- Name: userTenants userTenants_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."userTenants"
    ADD CONSTRAINT "userTenants_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2024-12-02 11:44:36

--
-- PostgreSQL database dump complete
--

