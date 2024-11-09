import { functions } from './../config/function.db';
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
import { log } from 'console';
import { authParserJson } from 'src/helper/auth.helper';
import { ResponseAuth } from './interfaces';
import { ILogin } from './interfaces/login.interface';


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

  async login(loginUserDto: LoginUserDto): Promise<ResponseAuth> {
    try {
      const { password, email } = loginUserDto;
      const dbResp = await this.prisma.$queryRaw`SELECT login(${email}) AS user`;
      const data: ILogin = dbResp[0].user
      if (!data)
        throw new UnauthorizedException('Credentials are not valid (email)');

      if (!bcrypt.compareSync(password, data.password))
        throw new UnauthorizedException('Credentials are not valid (password)');

      delete data.password;

      return {
        data,
        token: this.getJwtToken({ id: data.id }),
      };
    } catch (error) {
      this.handleDBErrors(error)
    }

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

  private handleDBErrors(error: any): void {


    if (error.status) {
      throw new UnauthorizedException(error.response.message)
    }


    if (error?.code === 'P2002')
      throw new BadRequestException(
        'Ya existe un usuario con el correo electrocico proporsionado',
      );
    if (error?.meta.code === 'P0001')
      throw new BadRequestException(
        error.meta.message.split(':')[1],
      );


    // console.log(error);

    throw new InternalServerErrorException('Please check server logs');
  }
}
