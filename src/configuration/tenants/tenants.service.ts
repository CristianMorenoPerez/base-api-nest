import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateTenantDto } from './dto/create-tenant.dto';
import { UpdateTenantDto } from './dto/update-tenant.dto';
import { PrismaService } from 'prisma/prisma.service';
import { ErrorHelper } from 'src/helper/errors.helper';
import { ResponseData, ResponseDataPagination } from 'src/core/interfaces';
import { Itenant } from '../interfaces';

@Injectable()
export class TenantsService {

  constructor(private prisma: PrismaService,) {

  }

  async create(createTenantDto: CreateTenantDto): Promise<ResponseData<Itenant>> {


    const { name, address, email, phone, tenantTypeId } = createTenantDto


    const tenant = await this.prisma.tenants.create({
      data: {
        name: name,
        address: address,
        email: email,
        phone: phone,
        tenantType: {
          connect: { id: tenantTypeId }
        }
      }, select: {
        id: true,
        name: true,
        address: true,
        email: true,
        phone: true,
        tenantType: { select: { id: true, name: true } }
      }
    })
    this.prisma.$disconnect()

    return { data: tenant };

  }

  async findAll(page: number = 1, limit: number = 10): Promise<ResponseDataPagination<Itenant[]>> {
    const table = 'tenants'
    const offset = (page - 1) * limit;
    if (!page || !limit) throw new BadRequestException('page y limit son oblogatorios')

    // Obtener los registros activos paginados
    const tenants = await this.prisma[table].findMany({
      where: { isActive: true },
      skip: offset,
      take: limit,
      orderBy: { createdAt: 'desc' }, // Opcional: ordenar por fecha de creación
      select: {
        id: true,
        name: true,
        address: true,
        phone: true,
        email: true,
        tenantType: { select: { id: true, name: true } }
      },
    });

    // Contar el total de registros activos
    const total = await this.prisma.tenants.count({
      where: { isActive: true },
    });


    return {
      data: tenants,
      meta: {
        total,
        page,
        lastPage: Math.ceil(total / limit),
      },
    };

  }

  findOne(id: number) {
    return `This action returns a #${id} tenant`;
  }

  update(id: number, updateTenantDto: UpdateTenantDto) {
    return `This action updates a #${id} tenant`;
  }

  remove(id: number) {
    return `This action removes a #${id} tenant`;
  }
}
