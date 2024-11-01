/*
  Warnings:

  - A unique constraint covering the columns `[phone]` on the table `Tenants` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[email]` on the table `Tenants` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "Tenants_name_key";

-- AlterTable
ALTER TABLE "TenantTypes" ALTER COLUMN "updatedAt" DROP NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Tenants_phone_key" ON "Tenants"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "Tenants_email_key" ON "Tenants"("email");
