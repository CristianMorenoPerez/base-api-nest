/*
  Warnings:

  - You are about to drop the column `name` on the `UserPermissions` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "UserPermissions_name_key";

-- AlterTable
ALTER TABLE "UserPermissions" DROP COLUMN "name";
