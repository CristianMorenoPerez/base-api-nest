import { Module } from '@nestjs/common';
import { TenantTypeController } from './tenant-type.controller';
import { TenantTypeService } from './tenant-type.service';
import { PrismaService } from 'prisma/prisma.service';

@Module({
  controllers: [TenantTypeController],
  providers: [TenantTypeService, PrismaService]
})
export class TenantTypeModule { }
