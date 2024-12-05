CREATE TABLE "options" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "icon" "character varying(40)" NOT NULL,
  "code" "character varying(20)" NOT NULL,
  "name" "character varying(60)" NOT NULL,
  "path" "character varying(40)" NOT NULL,
  "sectionsId" uuid NOT NULL,
  "isActive" boolean NOT NULL DEFAULT true,
  "createdBy" uuid,
  "updatedAt" timestamp(0),
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "permissions" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "code" "character varying(20)" NOT NULL,
  "name" "character varying(60)" NOT NULL,
  "isActive" boolean NOT NULL DEFAULT true,
  "createdBy" uuid,
  "updatedAt" timestamp(0),
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "sections" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "icon" "character varying(40)" NOT NULL,
  "code" "character varying(20)" NOT NULL,
  "name" "character varying(60)" NOT NULL,
  "path" "character varying(40)",
  "isActive" boolean NOT NULL DEFAULT true,
  "createdBy" uuid,
  "updatedAt" timestamp(0),
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "tenantTypes" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "name" "character varying(60)" NOT NULL,
  "isActive" boolean NOT NULL DEFAULT true,
  "createdBy" uuid,
  "updatedAt" timestamp(0),
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "tenants" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "name" "character varying(60)" NOT NULL,
  "address" "character varying(80)" NOT NULL,
  "phone" "character varying(15)" NOT NULL,
  "email" "character varying(150)" NOT NULL,
  "tenantTypeId" uuid NOT NULL,
  "isActive" boolean NOT NULL DEFAULT true,
  "createdBy" uuid,
  "updatedAt" timestamp(0),
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "userTenants" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "userId" uuid NOT NULL,
  "tenantId" uuid NOT NULL,
  "isActive" boolean NOT NULL DEFAULT true,
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "userTypes" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "name" "character varying(60)" NOT NULL,
  "tenantId" uuid NOT NULL,
  "isActive" boolean NOT NULL DEFAULT true,
  "createdBy" uuid,
  "updatedAt" timestamp(0),
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "user_permissions" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "userId" uuid,
  "userTypeId" uuid,
  "optionId" uuid NOT NULL,
  "permissionId" uuid NOT NULL,
  "isActive" boolean NOT NULL DEFAULT true,
  "createdBy" uuid,
  "updatedAt" timestamp(0),
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY NOT NULL DEFAULT (gen_random_uuid()),
  "name" "character varying(60)" NOT NULL,
  "email" "character varying(150)" NOT NULL,
  "password" text NOT NULL,
  "userTypeId" uuid NOT NULL,
  "isActive" boolean NOT NULL DEFAULT true,
  "createdBy" uuid,
  "updatedAt" timestamp(0),
  "createdAt" timestamp(3) NOT NULL DEFAULT (CURRENT_TIMESTAMP)
);

CREATE UNIQUE INDEX "uq_options_path" ON "options" USING BTREE ("path");

CREATE UNIQUE INDEX "uq_permissions_code" ON "permissions" USING BTREE ("code");

CREATE UNIQUE INDEX "uq_sections_path" ON "sections" USING BTREE ("path");

CREATE UNIQUE INDEX "uq_tenants_email" ON "tenants" USING BTREE ("email");

CREATE UNIQUE INDEX "userTenants_userId_tenantId_key" ON "userTenants" USING BTREE ("userId", "tenantId");

CREATE UNIQUE INDEX "uq_usertypes_name_tenant" ON "userTypes" USING BTREE ("name", "tenantId");

CREATE UNIQUE INDEX "uq_user_permissions" ON "user_permissions" USING BTREE ("userId", "userTypeId", "optionId", "permissionId");

CREATE UNIQUE INDEX "uq_users_email" ON "users" USING BTREE ("email");

ALTER TABLE "options" ADD CONSTRAINT "fk_options_section" FOREIGN KEY ("sectionsId") REFERENCES "sections" ("id") ON DELETE CASCADE;

ALTER TABLE "tenants" ADD CONSTRAINT "fk_tenant_tenanttype" FOREIGN KEY ("tenantTypeId") REFERENCES "tenantTypes" ("id") ON DELETE CASCADE;

ALTER TABLE "users" ADD CONSTRAINT "fk_user_type" FOREIGN KEY ("userTypeId") REFERENCES "userTypes" ("id") ON DELETE CASCADE;

ALTER TABLE "user_permissions" ADD CONSTRAINT "fk_userpermissions_option" FOREIGN KEY ("optionId") REFERENCES "options" ("id") ON DELETE CASCADE;

ALTER TABLE "user_permissions" ADD CONSTRAINT "fk_userpermissions_permission" FOREIGN KEY ("permissionId") REFERENCES "permissions" ("id") ON DELETE CASCADE;

ALTER TABLE "user_permissions" ADD CONSTRAINT "fk_userpermissions_user" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "user_permissions" ADD CONSTRAINT "fk_userpermissions_usertype" FOREIGN KEY ("userTypeId") REFERENCES "userTypes" ("id") ON DELETE CASCADE;

ALTER TABLE "userTypes" ADD CONSTRAINT "fk_usertypes_tenant" FOREIGN KEY ("tenantId") REFERENCES "tenants" ("id") ON DELETE CASCADE;

ALTER TABLE "userTenants" ADD CONSTRAINT "userTenants_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "userTenants" ADD CONSTRAINT "userTenants_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
