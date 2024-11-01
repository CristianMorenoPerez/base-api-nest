import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UserpermissionsService } from './userpermissions.service';
import { CreateUserpermissionDto } from './dto/create-userpermission.dto';
import { UpdateUserpermissionDto } from './dto/update-userpermission.dto';

@Controller('userpermissions')
export class UserpermissionsController {
  constructor(private readonly userpermissionsService: UserpermissionsService) {}

  @Post()
  create(@Body() createUserpermissionDto: CreateUserpermissionDto) {
    return this.userpermissionsService.create(createUserpermissionDto);
  }

  @Get()
  findAll() {
    return this.userpermissionsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userpermissionsService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserpermissionDto: UpdateUserpermissionDto) {
    return this.userpermissionsService.update(+id, updateUserpermissionDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.userpermissionsService.remove(+id);
  }
}
