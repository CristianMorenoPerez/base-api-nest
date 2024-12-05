import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

import { JwtPayload } from '../interfaces/jwt-payload.interface';
import { PrismaService } from 'prisma/prisma.service';
import { authParserJson } from 'src/helper/auth.helper';
import { Request } from 'express';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {

    constructor(
        private prisma: PrismaService,

        configService: ConfigService
    ) {

        super({
            secretOrKey: configService.get('JWT_SECRET'),
            jwtFromRequest: ExtractJwt.fromExtractors([
                (request: Request) => {
                    return request.cookies?.token || null
                }
            ]),
        });
    }


    async validate(payload: JwtPayload): Promise<any> {

        const { id } = payload;

        const user = await this.prisma.users.findUnique({
            where: { id }, select: {
                id: true,
                email: true
            },
        });

        const dbResp = await this.prisma.$queryRaw`SELECT login(${user.email}) AS user`;

        const userIn = dbResp[0].user



        if (!userIn)
            throw new UnauthorizedException('Token not valid')




        return userIn;
    }

}