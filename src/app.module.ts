import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { CommonModule } from './common/common.module';
import { ConfigModule } from '@nestjs/config';
import { ConfigurationModule } from './configuration/configuration.module';
import { RefreshTokenMiddleware } from './auth/middleware/token.middleware';


@Module({
  imports: [
    ConfigModule.forRoot(),
    CommonModule,
    AuthModule,
    ConfigurationModule,],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(RefreshTokenMiddleware).exclude('auth/login').forRoutes('*')
  }
}
