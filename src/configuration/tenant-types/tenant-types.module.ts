import { Module } from '@nestjs/common';
import { TenantTypesService } from './tenant-types.service';
import { TenantTypesController } from './tenant-types.controller';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  controllers: [TenantTypesController],
  imports: [AuthModule],
  providers: [TenantTypesService],
})
export class TenantTypesModule { }
