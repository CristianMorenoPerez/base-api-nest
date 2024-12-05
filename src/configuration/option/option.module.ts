import { Module } from '@nestjs/common';
import { OptionService } from './option.service';
import { OptionController } from './option.controller';
import { AuthModule } from 'src/auth/auth.module';
import { PrismaService } from 'prisma/prisma.service';

@Module({
  controllers: [OptionController],
  imports: [AuthModule],
  providers: [OptionService, PrismaService],
  exports: [OptionService]
})
export class OptionModule { }
