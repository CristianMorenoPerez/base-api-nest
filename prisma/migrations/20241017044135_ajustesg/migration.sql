/*
  Warnings:

  - Made the column `updatedAt` on table `TenantTypes` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "TenantTypes" ALTER COLUMN "updatedAt" SET NOT NULL,
ALTER COLUMN "updatedAt" SET DEFAULT CURRENT_TIMESTAMP;
