/*
  Warnings:

  - You are about to drop the column `userId` on the `UserTypes` table. All the data in the column will be lost.
  - Added the required column `createdBy` to the `UserTypes` table without a default value. This is not possible if the table is not empty.
  - Added the required column `createdBy` to the `sections` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "UserTypes" DROP CONSTRAINT "UserTypes_userId_fkey";

-- DropForeignKey
ALTER TABLE "sections" DROP CONSTRAINT "sections_userId_fkey";

-- AlterTable
ALTER TABLE "UserTypes" DROP COLUMN "userId",
ADD COLUMN     "createdBy" UUID NOT NULL;

-- AlterTable
ALTER TABLE "sections" ADD COLUMN     "createdBy" UUID NOT NULL;
