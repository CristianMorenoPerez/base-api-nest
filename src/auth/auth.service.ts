import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import * as bcrypt from 'bcrypt';

import { LoginUserDto, CreateUserDto } from './dto';
import { JwtPayload } from './interfaces/jwt-payload.interface';
import { PrismaService } from 'prisma/prisma.service';
import { IUser } from 'src/core/interfaces';
import { log } from 'console';
import { use } from 'passport';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,

    private readonly jwtService: JwtService,
  ) { }

  async create(createUserDto: CreateUserDto) {
    try {
      const { password, ...userData } = createUserDto;

      const user = await this.prisma.users.create({
        data: {
          ...userData,
          password: bcrypt.hashSync(password, 10),
        },
        select: {
          id: true,
          name: true,
          email: true,
          Tenant: true
        },
      });

      return user;
    } catch (error) {
      console.log(error);

      this.handleDBErrors(error);
    }
  }

  async login(loginUserDto: LoginUserDto) {
    const { password, email } = loginUserDto;

    const user = await this.prisma.users.findUnique({
      where: { email },
      select: {
        id: true,
        email: true,
        password: true,
        Tenant: { select: { name: true, email: true, phone: true, tenantType: { select: { name: true } } } },
        user_permissions: { select: { option: { select: { code: true, name: true, path: true, option_permissions: { select: { permission: true } }, section: { select: { code: true, name: true, } } } } } }
      },
    });


    const sectionsMap = new Map();

    user.user_permissions.forEach((userPermission) => {
      const { option } = userPermission;
      const { section, option_permissions } = option;

      // Crear la estructura de la sección si no existe
      if (!sectionsMap.has(section.code)) {
        sectionsMap.set(section.code, {
          code: section.code,
          name: section.name,
          options: []
        });
      }

      // Obtener la sección y agregar la opción
      const sectionEntry = sectionsMap.get(section.code);

      // Transformar los permisos
      const permissions = option_permissions.map((op) => ({
        code: op.permission.code,
        name: op.permission.name
      }));

      // Agregar la opción a la sección
      sectionEntry.options.push({
        name: option.name,
        path: option.path,
        permissions: permissions
      });
    });

    // Convertir el Map a un array
    const sections = Array.from(sectionsMap.values());

    const response = {
      id: user.id,
      email: user.email,
      tenant: user.Tenant,
      sections: sections
    }


    if (!user)
      throw new UnauthorizedException('Credentials are not valid (email)');

    if (!bcrypt.compareSync(password, user.password))
      throw new UnauthorizedException('Credentials are not valid (password)');

    delete user.password;

    return {
      ...response,
      token: this.getJwtToken({ id: user.id }),
    };
  }

  // async checkAuthStatus( user: User ){

  //   return {
  //     user: user,
  //     token: this.getJwtToken({ id: user.id })
  //   };

  // }

  private getJwtToken(payload: JwtPayload) {
    const token = this.jwtService.sign(payload);
    return token;
  }

  private handleDBErrors(error: any): never {
    if (error.code === 'P2002')
      throw new BadRequestException(
        'Ya existe un usuario con el correo electrocico proporsionado',
      );

    console.log(error);

    throw new InternalServerErrorException('Please check server logs');
  }
}
