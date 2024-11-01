import { Injectable } from '@nestjs/common';
import { CreateUserPermissionAssignDto } from './dto/create-user-permission-assign.dto';
import { UpdateUserPermissionAssignDto } from './dto/update-user-permission-assign.dto';

@Injectable()
export class UserPermissionAssignsService {
  create(createUserPermissionAssignDto: CreateUserPermissionAssignDto) {
    return 'This action adds a new userPermissionAssign';
  }

  findAll() {
    return `This action returns all userPermissionAssigns`;
  }

  findOne(id: number) {
    return `This action returns a #${id} userPermissionAssign`;
  }

  update(id: number, updateUserPermissionAssignDto: UpdateUserPermissionAssignDto) {
    return `This action updates a #${id} userPermissionAssign`;
  }

  remove(id: number) {
    return `This action removes a #${id} userPermissionAssign`;
  }
}
