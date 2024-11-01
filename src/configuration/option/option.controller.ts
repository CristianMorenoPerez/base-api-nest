import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { OptionService } from './option.service';
import { CreateOptionDto } from './dto/create-option.dto';
import { UpdateOptionDto } from './dto/update-option.dto';
import { Auth } from 'src/auth/decorators';
import { AuthGuard } from '@nestjs/passport';

@Controller('options')

export class OptionController {
  constructor(private readonly optionService: OptionService) { }

  @Post()
  create(@Body() createOptionDto: CreateOptionDto) {
    return this.optionService.create(createOptionDto);
  }

  @UseGuards(AuthGuard())
  @Get()
  findAll() {
    return this.optionService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.optionService.findOne(+id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateOptionDto: UpdateOptionDto) {
    return this.optionService.update(+id, updateOptionDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.optionService.remove(+id);
  }
}
