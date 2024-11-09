/*
  Warnings:

  - A unique constraint covering the columns `[userId,userTypeId,optionId]` on the table `user_permissions` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `permissionId` to the `user_permissions` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "sections" ADD COLUMN     "path" TEXT;

-- AlterTable
ALTER TABLE "user_permissions" ADD COLUMN     "permissionId" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "user_permissions_userId_userTypeId_optionId_key" ON "user_permissions"("userId", "userTypeId", "optionId");

-- AddForeignKey
ALTER TABLE "user_permissions" ADD CONSTRAINT "user_permissions_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
