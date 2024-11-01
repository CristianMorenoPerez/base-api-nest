import { Module } from '@nestjs/common';
import { OptionModule } from './option/option.module';
import { SectionModule } from './section/section.module';
import { UserTypesModule } from './user-types/user-types.module';
import { PermissionsModule } from './permissions/permissions.module';
import { TenantsModule } from './tenants/tenants.module';
import { TenantTypesModule } from './tenant-types/tenant-types.module';
import { UserpermissionsModule } from './userpermissions/userpermissions.module';
import { UserPermissionAssignsModule } from './user-permission-assigns/user-permission-assigns.module';


@Module({
    imports: [
        OptionModule,
        SectionModule,
        UserTypesModule,
        PermissionsModule,
        TenantsModule,
        TenantTypesModule,
        UserpermissionsModule,
        UserPermissionAssignsModule,

    ]
})
export class ConfigurationModule { }
