import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateOptionDto } from './dto/create-option.dto';
import { UpdateOptionDto } from './dto/update-option.dto';
import { ErrorHelper } from 'src/helper/errors.helper';
import { PrismaService } from 'prisma/prisma.service';
import { ResponseData } from 'src/core/interfaces';
import { IOption } from '../interfaces';

@Injectable()
export class OptionService {

  constructor(private prisma: PrismaService,) {

  }

  async create(createOptionDto: CreateOptionDto): Promise<ResponseData<IOption>> {
    const optionResp = createOptionDto;


    const option = await this.prisma.options.create({
      data: {
        icon: optionResp.icon,
        code: optionResp.code,
        name: optionResp.name,
        path: optionResp.path,
        section: {
          connect: { id: optionResp.section.id },

        }

      },
      select: { id: true, icon: true, code: true, name: true, path: true, section: { select: { id: true, icon: true, code: true, name: true, path: true } } }
    })
    this.prisma.$disconnect()

    return {
      data: option
    }

  }

  findAll() {
    return ''
  }

  async findOne(id: string): Promise<ResponseData<IOption>> {


    const option = await this.prisma.options.findUnique({ where: { id, AND: [{ isActive: true }] }, select: { id: true, icon: true, code: true, name: true, path: true, section: { select: { id: true } } } });

    if (!option) throw new NotFoundException("The option not found.");

    return { data: option }


  }

  async update(id: string, updateOptionDto: UpdateOptionDto): Promise<ResponseData<IOption>> {

    // Verifica si la opción existe
    await this.findOne(id);



    // Actualiza los campos enviados
    const updatedOption = await this.prisma.options.update({
      where: { id },
      data: updateOptionDto, // Solo los campos enviados serán actualizados
      select: { id: true, icon: true, code: true, name: true, path: true }
    });

    return {
      data: updatedOption,
    };

  }

  async remove(id: string): Promise<ResponseData<boolean>> {


    await this.findOne(id);
    // Cambia el estado de `isActive` a `false`
    await this.prisma.options.update({
      where: { id },
      data: { isActive: false },
    });

    return {
      data: true,
    };
  }
}
