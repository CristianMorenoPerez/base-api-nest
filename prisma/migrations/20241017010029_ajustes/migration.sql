/*
  Warnings:

  - You are about to drop the column `optionid` on the `permissions` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "permissions" DROP CONSTRAINT "permissions_optionid_fkey";

-- AlterTable
ALTER TABLE "permissions" DROP COLUMN "optionid";
