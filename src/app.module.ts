import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { CommonModule } from './common/common.module';
import { ConfigModule } from '@nestjs/config';
import { TenantModule } from './tenant/tenant.module';
import { TenantTypeModule } from './tenant-type/tenant-type.module';
import { ConfigurationModule } from './configuration/configuration.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    CommonModule,
    AuthModule,
    TenantModule,
    TenantTypeModule,
    ConfigurationModule,],
})
export class AppModule { }
