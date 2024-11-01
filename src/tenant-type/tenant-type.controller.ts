import { Body, Controller, Post } from '@nestjs/common';
import { CreateTenantTypeDto } from './dto/create-tenenat-type.dto';
import { TenantTypeService } from './tenant-type.service';

@Controller('tenant-type')
export class TenantTypeController {

    constructor(private tenenanTypeServicie: TenantTypeService) { }

    @Post()
    createUser(@Body() createUserDto: CreateTenantTypeDto) {
        return this.tenenanTypeServicie.create(createUserDto);
    }

}
