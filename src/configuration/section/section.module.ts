import { Module } from '@nestjs/common';
import { SectionService } from './section.service';
import { SectionController } from './section.controller';
import { PrismaService } from 'prisma/prisma.service';
import { OptionService } from '../option/option.service';

@Module({
  controllers: [SectionController],
  providers: [SectionService, OptionService, PrismaService],
})
export class SectionModule { }
