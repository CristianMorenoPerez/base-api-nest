import { Module } from '@nestjs/common';
import { OptionService } from './option.service';
import { OptionController } from './option.controller';
import { AuthModule } from 'src/auth/auth.module';

@Module({
  controllers: [OptionController],
  imports: [AuthModule],
  providers: [OptionService],
})
export class OptionModule { }
