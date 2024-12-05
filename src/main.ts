import { NestFactory } from '@nestjs/core';
import { All, Logger, ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

import { AppModule } from './app.module';
import * as cookieParser from 'cookie-parser';
import { GlobalExceptionFilter } from './common/global-exception.filter';




async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const logger = new Logger('Bootstrap');
  ///configurar csrf

  app.setGlobalPrefix('api');

  // Habilitar CORS para permitir peticiones desde Angular
  app.enableCors({
    origin: ['http://localhost:4500', 'http://localhost:4200', 'http://192.168.0.106:4500', 'http://192.168.206.167:4500',],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
  });
  app.use(cookieParser())

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true
    })
  );

  app.useGlobalFilters(new GlobalExceptionFilter())

  const config = new DocumentBuilder()
    .setTitle('Teslo RESTFul API')
    .setDescription('Teslo shop endpoints')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  //  await app.listen(3000, '0.0.0.0');


  await app.listen(process.env.PORT, '0.0.0.0');
  logger.log(`App running on port ${process.env.PORT}`);
}
bootstrap();

