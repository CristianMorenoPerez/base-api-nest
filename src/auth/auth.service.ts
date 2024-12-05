
import {
  Injectable,
  Logger,
  NotAcceptableException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import * as bcrypt from 'bcrypt';

import { LoginUserDto, CreateUserDto } from './dto';
import { JwtPayload } from './interfaces/jwt-payload.interface';
import { PrismaService } from 'prisma/prisma.service';
import { ResponseAuth } from './interfaces';
import { ILogin } from './interfaces/login.interface';
import { ConfigService } from '@nestjs/config';
import { ErrorHelper } from 'src/helper/errors.helper';



@Injectable()
export class AuthService {



  constructor(
    private prisma: PrismaService,

    private readonly jwtService: JwtService,
    private configService: ConfigService
  ) { }

  async create(createUserDto: CreateUserDto) {
    try {
      const { password, ...userData } = createUserDto;

      const user = await this.prisma.users.create({
        data: {
          ...userData,
          userTypeId: '2fa1238c-322f-423e-9c1e-50589ef1bb13',
          password: bcrypt.hashSync(password, 10),
        },
        // select: {
        //   id: true,
        //   name: true,
        //   email: true,
        //   // Tenant: true
        // },
      });

      return user;
    } catch (error) {
      console.log(error);

      ErrorHelper.handleDbError(error)
    }
  }

  async login(loginUserDto: LoginUserDto): Promise<ResponseAuth> {
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
      token: this.getJwtToken({ id: data.id }, '15m'),
      refreshToken: this.getRefreshToken({ id: data.id }, '4h')
    };


  }




  getJwtToken(payload: JwtPayload, expireInToken: string = '15m') {
    const token = this.jwtService.sign(payload, { expiresIn: expireInToken });
    return token;
  }

  getRefreshToken(payload: JwtPayload, expireInToken: string = '7d') {
    return this.jwtService.sign(payload, {
      secret: this.configService.get('JWT_REFRESH_SECRET'),
      expiresIn: expireInToken,
    });
  }

  // Verificar access token
  verifyAccessToken(token: string) {
    try {
      return this.jwtService.verify(token, {
        secret: this.configService.get('JWT_SECRET'),
      });
    } catch (error) {
      throw new UnauthorizedException('Access token is invalid or expired');
    }
  }

  // Verificar refresh token
  verifyRefreshToken(token: string) {
    try {
      return this.jwtService.verify(token, {
        secret: this.configService.get('JWT_REFRESH_SECRET'),
      });
    } catch (error) {
      throw new UnauthorizedException('Refresh token is invalid or expired');
    }
  }


}
