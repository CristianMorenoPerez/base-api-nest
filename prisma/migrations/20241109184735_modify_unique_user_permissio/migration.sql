/*
  Warnings:

  - A unique constraint covering the columns `[userId,optionId,permissionId]` on the table `user_permissions` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userTypeId,optionId,permissionId]` on the table `user_permissions` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "user_permissions_userId_permissionId_key";

-- DropIndex
DROP INDEX "user_permissions_userTypeId_permissionId_key";

-- CreateIndex
CREATE UNIQUE INDEX "user_permissions_userId_optionId_permissionId_key" ON "user_permissions"("userId", "optionId", "permissionId");

-- CreateIndex
CREATE UNIQUE INDEX "user_permissions_userTypeId_optionId_permissionId_key" ON "user_permissions"("userTypeId", "optionId", "permissionId");
