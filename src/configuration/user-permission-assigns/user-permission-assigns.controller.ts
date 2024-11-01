import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UserPermissionAssignsService } from './user-permission-assigns.service';
import { CreateUserPermissionAssignDto } from './dto/create-user-permission-assign.dto';
import { UpdateUserPermissionAssignDto } from './dto/update-user-permission-assign.dto';

@Controller('user-permission-assigns')
export class UserPermissionAssignsController {
  constructor(private readonly userPermissionAssignsService: UserPermissionAssignsService) {}

  @Post()
  create(@Body() createUserPermissionAssignDto: CreateUserPermissionAssignDto) {
    return this.userPermissionAssignsService.create(createUserPermissionAssignDto);
  }

  @Get()
  findAll() {
    return this.userPermissionAssignsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userPermissionAssignsService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserPermissionAssignDto: UpdateUserPermissionAssignDto) {
    return this.userPermissionAssignsService.update(+id, updateUserPermissionAssignDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.userPermissionAssignsService.remove(+id);
  }
}
