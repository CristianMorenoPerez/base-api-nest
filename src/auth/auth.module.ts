import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';

import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './strategies/jwt.strategy';
import { PrismaService } from 'prisma/prisma.service';
import { CommonModule } from 'src/common/common.module';

@Module({
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, PrismaService],
  imports: [
    ConfigModule,
    CommonModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),

    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => {
        return {
          secret: configService.get('JWT_SECRET'),
          signOptions: {
            expiresIn: '15m'
          }
        }
      }
    })

  ],
  exports: [JwtStrategy, PassportModule, JwtModule, AuthService]
})
export class AuthModule { }
