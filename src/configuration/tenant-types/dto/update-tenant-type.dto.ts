import { PartialType } from '@nestjs/swagger';
import { CreateTenantTypeDto } from './create-tenant-type.dto';

export class UpdateTenantTypeDto extends PartialType(CreateTenantTypeDto) {}
