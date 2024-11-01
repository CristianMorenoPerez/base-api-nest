import { Injectable } from '@nestjs/common';
import { CreateUserpermissionDto } from './dto/create-userpermission.dto';
import { UpdateUserpermissionDto } from './dto/update-userpermission.dto';

@Injectable()
export class UserpermissionsService {
  create(createUserpermissionDto: CreateUserpermissionDto) {
    return 'This action adds a new userpermission';
  }

  findAll() {
    return `This action returns all userpermissions`;
  }

  findOne(id: number) {
    return `This action returns a #${id} userpermission`;
  }

  update(id: number, updateUserpermissionDto: UpdateUserpermissionDto) {
    return `This action updates a #${id} userpermission`;
  }

  remove(id: number) {
    return `This action removes a #${id} userpermission`;
  }
}
