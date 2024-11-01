import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

import { JwtPayload } from '../interfaces/jwt-payload.interface';
import { PrismaService } from 'prisma/prisma.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {

    constructor(
        private prisma: PrismaService,

        configService: ConfigService
    ) {

        super({
            secretOrKey: configService.get('JWT_SECRET'),
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
        });
    }


    async validate(payload: JwtPayload): Promise<any> {

        const { id } = payload;

        const user = await this.prisma.users.findUnique({ where: { id }, select: { id: true, email: true, password: true, isActive: true } });

        if (!user)
            throw new UnauthorizedException('Token not valid')

        if (!user.isActive)
            throw new UnauthorizedException('User is inactive, talk with an admin');

        return user;
    }

}