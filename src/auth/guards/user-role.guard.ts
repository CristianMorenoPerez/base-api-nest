import { Reflector } from '@nestjs/core';
import { CanActivate, ExecutionContext, Injectable, BadRequestException, ForbiddenException, InternalServerErrorException } from '@nestjs/common';
import { Observable } from 'rxjs';
import { META_ROLES } from '../decorators/role-protected.decorator';

@Injectable()
export class UserRoleGuard implements CanActivate {

  constructor(
    private readonly reflector: Reflector
  ) { }

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    console.log(9);
    const req = context.switchToHttp().getRequest();
    const user = req.user
    console.log(user.UserPermissions);

    if (!user) throw new InternalServerErrorException('error desconocido')
    if (user.UserPermissions.length === 0) throw new ForbiddenException("No tienes permisos asignados")

    return false

    // const validRoles: string[] = this.reflector.get(META_ROLES, context.getHandler())

    // if (!validRoles) return true;
    // if (validRoles.length === 0) return true;

    // const req = context.switchToHttp().getRequest();
    // const user = req.user as any;

    // if (!user)
    //   throw new BadRequestException('User not found');

    // for (const role of user.roles) {
    //   if (validRoles.includes(role)) {
    //     return true;
    //   }
    // }

    // throw new ForbiddenException(
    //   `User ${user.fullName} need a valid role: [${validRoles}]`
    // );
  }
}
