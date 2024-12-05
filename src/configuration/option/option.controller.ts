import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, ParseUUIDPipe } from '@nestjs/common';
import { OptionService } from './option.service';
import { CreateOptionDto } from './dto/create-option.dto';
import { UpdateOptionDto } from './dto/update-option.dto';
import { Auth } from 'src/auth/decorators';
import { UserPermissionGuard } from 'src/auth/guards/user-permission.guard';
import { PermissionProtected } from 'src/auth/decorators/permission-protected.decorator';

@Controller('options')
@Auth()
export class OptionController {
  constructor(private readonly optionService: OptionService) { }

  @Post()
  // @PermissionProtected('C')
  // @UseGuards(UserPermissionGuard)
  create(@Body() createOptionDto: CreateOptionDto) {
    return this.optionService.create(createOptionDto);
  }


  @Get()
  // @UseGuards(UserPermissionGuard)
  // @PermissionProtected('R')
  findAll() {
    return this.optionService.findAll();
  }

  @Get(':id')
  // @UseGuards(UserPermissionGuard)
  // @PermissionProtected('R')
  findOne(@Param('id') id: string) {
    return this.optionService.findOne(id);
  }

  @Patch(':id')
  // @UseGuards(UserPermissionGuard)
  // @PermissionProtected('U')
  update(@Param('id') id: string, @Body() updateOptionDto: UpdateOptionDto) {
    return this.optionService.update(id, updateOptionDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.optionService.remove(id);
  }
}
