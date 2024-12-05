import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { TenantTypesService } from './tenant-types.service';
import { CreateTenantTypeDto } from './dto/create-tenant-type.dto';
import { UpdateTenantTypeDto } from './dto/update-tenant-type.dto';
import { AuthGuard } from '@nestjs/passport';

@Controller('tenant-types')
@UseGuards(AuthGuard())
export class TenantTypesController {
  constructor(private readonly tenantTypesService: TenantTypesService) { }

  @Post()
  create(@Body() createTenantTypeDto: CreateTenantTypeDto) {
    return this.tenantTypesService.create(createTenantTypeDto);
  }

  @Get()
  findAll() {
    return this.tenantTypesService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.tenantTypesService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateTenantTypeDto: UpdateTenantTypeDto) {
    return this.tenantTypesService.update(id, updateTenantTypeDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.tenantTypesService.remove(id);
  }
}
