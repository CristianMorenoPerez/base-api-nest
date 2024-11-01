import { Controller, Post } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('Tenants')
@Controller('tenant')
export class TenantController {

    @Post('create')
    create() {

    }
}
