import { PartialType } from '@nestjs/swagger';
import { CreateUserpermissionDto } from './create-userpermission.dto';

export class UpdateUserpermissionDto extends PartialType(CreateUserpermissionDto) {}
