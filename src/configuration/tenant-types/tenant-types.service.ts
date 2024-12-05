import { BadRequestException, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { CreateTenantTypeDto } from './dto/create-tenant-type.dto';
import { UpdateTenantTypeDto } from './dto/update-tenant-type.dto';
import { PrismaService } from 'prisma/prisma.service';
import { ErrorHelper } from 'src/helper/errors.helper';
import { Itenanttype } from '../interfaces';
import { ResponseData, ResponseDataPagination } from 'src/core/interfaces';

@Injectable()
export class TenantTypesService {


  constructor(private prisma: PrismaService) {

  }


  async create(createTenantTypeDto: CreateTenantTypeDto): Promise<ResponseData<Itenanttype>> {


    const tenantType = await this.prisma.tenantTypes.create({
      data: createTenantTypeDto, select: { id: true, name: true }
    })

    return {
      data: tenantType
    };



  }


  async findAll(page: number = 1, limit: number = 10): Promise<ResponseDataPagination<Itenanttype[]>> {

    const offset = (page - 1) * limit;
    if (!page || !limit) throw new BadRequestException('page y limit son oblogatorios')

    // Obtener los registros activos paginados
    const tenantTypes = await this.prisma.tenantTypes.findMany({
      where: { isActive: true },
      skip: offset,
      take: limit,
      orderBy: { createdAt: 'desc' }, // Opcional: ordenar por fecha de creación
      select: {
        id: true,
        name: true,
      },
    });

    // Contar el total de registros activos
    const total = await this.prisma.tenantTypes.count({
      where: { isActive: true },
    });


    return {
      data: tenantTypes,
      meta: {
        total,
        page,
        lastPage: Math.ceil(total / limit),
      },
    };

  }


  async findOne(id: string): Promise<ResponseData<Itenanttype>> {
    const tenantType = await this.prisma.tenantTypes.findUnique({ where: { id, AND: [{ isActive: true }] }, select: { id: true, name: true, } });

    if (!tenantType) throw new NotFoundException("el tipo de tenant no fue encontrado");

    return { data: tenantType }
  }
  async update(id: string, updateTenantTypeDto: UpdateTenantTypeDto): Promise<ResponseData<Itenanttype>> {
    const tenantType = await this.prisma.tenantTypes.update({
      where: { id },
      data: updateTenantTypeDto,
      select: {
        id: true,
        name: true,
      },
    });

    return { data: tenantType };
  }

  async remove(id: string): Promise<ResponseData<boolean>> {


    await this.findOne(id);
    // Cambia el estado de `isActive` a `false`
    await this.prisma.tenantTypes.update({
      where: { id },
      data: { isActive: false },
    });

    return {
      data: true,
    };
  }
}
