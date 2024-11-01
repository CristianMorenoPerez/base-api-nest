import { Module } from '@nestjs/common';
import { UserpermissionsService } from './userpermissions.service';
import { UserpermissionsController } from './userpermissions.controller';

@Module({
  controllers: [UserpermissionsController],
  providers: [UserpermissionsService],
})
export class UserpermissionsModule {}
