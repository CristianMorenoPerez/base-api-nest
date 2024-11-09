import { Reflector } from '@nestjs/core';
import { CanActivate, ExecutionContext, Injectable, BadRequestException, ForbiddenException, InternalServerErrorException } from '@nestjs/common';
import { Observable } from 'rxjs';
import { META_PERMISSION } from '../decorators/permission-protected.decorator';
import { ILogin } from '../interfaces/login.interface';

@Injectable()
export class UserPermissionGuard implements CanActivate {

  constructor(
    private readonly reflector: Reflector
  ) { }
  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const req = context.switchToHttp().getRequest();
    const user: ILogin = req.user
    const url = req.originalUrl.split('/')[2];

    if (!user) throw new InternalServerErrorException('error desconocido')
    if (!user.tenant) throw new ForbiddenException("No tienes un tenant asignado ")
    if (user.permissions?.length === 0) throw new ForbiddenException("No tienes permisos asignados")
    const permissionIn: string = this.reflector.get(META_PERMISSION, context.getHandler())



    const option = user.permissions
      .flatMap(section => section.options)
      .find(option => option.path === url);

    if (!option) throw new ForbiddenException("Esta opción no ha sido asignada a tus permisos");

    const perm = user.permissions
      .flatMap(section => section.options)
      .flatMap(option => option.permissions)
      .find(permission => permission.code == permissionIn);
    if (!perm) throw new ForbiddenException("No tienes acceso a este servicio")

    return true;
  }
}
