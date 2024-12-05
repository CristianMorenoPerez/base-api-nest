import { Controller, Get, Post, Body, Patch, Param, Delete, Query, ParseUUIDPipe } from '@nestjs/common';
import { SectionService } from './section.service';
import { CreateSectionDto } from './dto/create-section.dto';
import { UpdateSectionDto } from './dto/update-section.dto';

@Controller('sections')
export class SectionController {
  constructor(private readonly sectionService: SectionService) { }

  @Post()
  create(@Body() createSectionDto: CreateSectionDto) {
    return this.sectionService.create(createSectionDto);
  }

  @Get()
  async findAll(
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 10,
  ) {
    // Validar valores de paginación
    page = Math.max(1, page);
    limit = Math.min(Math.max(1, limit), 100); // Limita el tamaño máximo a 100

    return this.sectionService.findAll(page, limit);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.sectionService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id', ParseUUIDPipe) id: string, @Body() updateSectionDto: UpdateSectionDto) {
    return this.sectionService.update(id, updateSectionDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.sectionService.remove(id);
  }
}
