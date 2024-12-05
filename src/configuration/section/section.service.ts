import { Inject, Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { CreateSectionDto } from './dto/create-section.dto';
import { UpdateSectionDto } from './dto/update-section.dto';
import { PrismaService } from 'prisma/prisma.service';
import { ErrorHelper } from 'src/helper/errors.helper';
import { ResponseData, ResponseDataPagination } from 'src/core/interfaces';
import { IOption, ISection } from '../interfaces';
import { OptionService } from '../option/option.service';
import { CreateOptionDto } from '../option/dto/create-option.dto';

@Injectable()
export class SectionService {

  constructor(private prisma: PrismaService, private optionService: OptionService) {

  }

  async create(createSectionDto: CreateSectionDto): Promise<ResponseData<ISection>> {

    const { options, ...sectionData } = createSectionDto;

    const section = await this.prisma.sections.create({
      data: {
        ...sectionData,
        Options: {
          create: options?.map(option => ({
            icon: option.icon,
            code: option.code,
            name: option.name,
            path: option.path
          })),
        },
      }, select: { id: true, icon: true, code: true, name: true, path: true, Options: { select: { id: true, icon: true, code: true, name: true, path: true } } }
    });
    // this.prisma.$disconnect();
    return { data: section };
  }

  async findAll(page: number = 1, limit: number = 10): Promise<ResponseDataPagination<any[]>> {

    const offset = (page - 1) * limit;
    if (!page || !limit) throw new BadRequestException('page y limit son oblogatorios')

    // Obtener los registros activos paginados
    const sections = await this.prisma.sections.findMany({
      where: { isActive: true },
      skip: offset,
      take: limit,
      orderBy: { createdAt: 'desc' }, // Opcional: ordenar por fecha de creación
      select: {
        id: true,
        code: true,
        name: true,
        icon: true,
        path: true,
        Options: { select: { id: true, icon: true, code: true, name: true, path: true, } }, // Relación si aplica
      },
    });

    // Contar el total de registros activos
    const total = await this.prisma.sections.count({
      where: { isActive: true },
    });

    this.prisma.$disconnect()

    return {
      data: sections,
      meta: {
        total,
        page,
        lastPage: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string) {
    const section = await this.prisma.sections.findUnique({ where: { id, AND: [{ isActive: true }] }, select: { id: true, icon: true, code: true, name: true, path: true, Options: { select: { id: true } } } });

    if (!section) throw new NotFoundException("la opcion no fue encontrada");

    return { data: section }
  }

  async update(id: string, updateSectionDto: UpdateSectionDto): Promise<ResponseData<ISection>> {


    const existingSection = await this.prisma.sections.findUnique({
      where: { id },
      include: { Options: true }
    });

    if (!existingSection) {
      throw new NotFoundException(`Section with ID ${id} not found`);
    }
    const section = await this.prisma.sections.update({
      where: { id },
      data: {
        icon: updateSectionDto.icon,
        code: updateSectionDto.code,
        name: updateSectionDto.name,
        path: updateSectionDto.path,
        Options: {
          create: updateSectionDto.options
            .filter((x) => !x.id)
            .map(opt => ({
              icon: opt.icon,
              code: opt.code,
              name: opt.name,
              path: opt.path
            })),

          updateMany: updateSectionDto.options
            .filter((x) => x.id)
            .map(opt => ({
              where: { id: opt.id },
              data: {
                icon: opt.icon,
                code: opt.code,
                name: opt.name,
                path: opt.path
              }
            }))
        }
      },
      select: {
        id: true,
        icon: true,
        code: true,
        name: true,
        path: true,
        Options: {
          select: {
            id: true,
            icon: true,
            code: true,
            name: true,
            path: true
          },
        },
      },
    });

    return { data: section };


  }

  async remove(id: string) {


    await this.findOne(id);
    // Cambia el estado de `isActive` a `false`
    await this.prisma.sections.update({
      where: { id },
      data: { isActive: false },
    });

    return {
      data: true,
    };
  }
}
