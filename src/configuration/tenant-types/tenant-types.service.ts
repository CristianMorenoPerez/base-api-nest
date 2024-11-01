import { Injectable } from '@nestjs/common';
import { CreateTenantTypeDto } from './dto/create-tenant-type.dto';
import { UpdateTenantTypeDto } from './dto/update-tenant-type.dto';

@Injectable()
export class TenantTypesService {
  create(createTenantTypeDto: CreateTenantTypeDto) {
    return 'This action adds a new tenantType';
  }

  findAll() {
    return `This action returns all tenantTypes`;
  }

  findOne(id: number) {
    return `This action returns a #${id} tenantType`;
  }

  update(id: number, updateTenantTypeDto: UpdateTenantTypeDto) {
    return `This action updates a #${id} tenantType`;
  }

  remove(id: number) {
    return `This action removes a #${id} tenantType`;
  }
}
