/*
  Warnings:

  - You are about to drop the `sections` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[userId]` on the table `UserTypes` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `userId` to the `UserTypes` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "UserTypes" ADD COLUMN     "userId" UUID NOT NULL;

-- DropTable
DROP TABLE "sections";

-- CreateTable
CREATE TABLE "Sections" (
    "id" UUID NOT NULL,
    "icon" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Sections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Options" (
    "id" UUID NOT NULL,
    "icon" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "sectionsId" UUID NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Options_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permissions" (
    "id" UUID NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "optionid" UUID NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tenants" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "tenantTypeId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Tenants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TenantTypes" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TenantTypes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserPermissions" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "userTypeId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "optionId" UUID NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserPermissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserPermissionsAssigns" (
    "id" UUID NOT NULL,
    "userPermissionId" UUID NOT NULL,
    "permissionId" UUID NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" UUID NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserPermissionsAssigns_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Tenants_name_key" ON "Tenants"("name");

-- CreateIndex
CREATE UNIQUE INDEX "TenantTypes_name_key" ON "TenantTypes"("name");

-- CreateIndex
CREATE UNIQUE INDEX "UserPermissions_name_key" ON "UserPermissions"("name");

-- CreateIndex
CREATE UNIQUE INDEX "UserPermissions_userTypeId_key" ON "UserPermissions"("userTypeId");

-- CreateIndex
CREATE UNIQUE INDEX "UserPermissions_userId_key" ON "UserPermissions"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "UserPermissions_optionId_key" ON "UserPermissions"("optionId");

-- CreateIndex
CREATE UNIQUE INDEX "UserTypes_userId_key" ON "UserTypes"("userId");

-- AddForeignKey
ALTER TABLE "UserTypes" ADD CONSTRAINT "UserTypes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Options" ADD CONSTRAINT "Options_sectionsId_fkey" FOREIGN KEY ("sectionsId") REFERENCES "Sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "permissions" ADD CONSTRAINT "permissions_optionid_fkey" FOREIGN KEY ("optionid") REFERENCES "Options"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tenants" ADD CONSTRAINT "Tenants_tenantTypeId_fkey" FOREIGN KEY ("tenantTypeId") REFERENCES "TenantTypes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tenants" ADD CONSTRAINT "Tenants_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPermissions" ADD CONSTRAINT "UserPermissions_userTypeId_fkey" FOREIGN KEY ("userTypeId") REFERENCES "UserTypes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPermissions" ADD CONSTRAINT "UserPermissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "Users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPermissions" ADD CONSTRAINT "UserPermissions_optionId_fkey" FOREIGN KEY ("optionId") REFERENCES "Options"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPermissionsAssigns" ADD CONSTRAINT "UserPermissionsAssigns_userPermissionId_fkey" FOREIGN KEY ("userPermissionId") REFERENCES "UserPermissions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPermissionsAssigns" ADD CONSTRAINT "UserPermissionsAssigns_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
