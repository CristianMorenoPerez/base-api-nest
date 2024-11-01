import { PartialType } from '@nestjs/swagger';
import { CreateUserPermissionAssignDto } from './create-user-permission-assign.dto';

export class UpdateUserPermissionAssignDto extends PartialType(CreateUserPermissionAssignDto) {}
