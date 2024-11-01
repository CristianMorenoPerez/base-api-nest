import { Module } from '@nestjs/common';
import { UserPermissionAssignsService } from './user-permission-assigns.service';
import { UserPermissionAssignsController } from './user-permission-assigns.controller';

@Module({
  controllers: [UserPermissionAssignsController],
  providers: [UserPermissionAssignsService],
})
export class UserPermissionAssignsModule {}
