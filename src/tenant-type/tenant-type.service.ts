import { Injectable } from '@nestjs/common';
import { PrismaService } from 'prisma/prisma.service';
import { CreateTenantTypeDto } from './dto/create-tenenat-type.dto';

@Injectable()
export class TenantTypeService {
    constructor(private prisma: PrismaService,) { }


    async create(createTenantTypeDto: CreateTenantTypeDto) {

        try {

            createTenantTypeDto.createdBy = "8e404731-0b50-4208-828d-f44c92950fff"


            // const user = await this.prisma.tenantTypes.create({
            //     // data: {
            //     //     ...createTenantTypeDto,

            //     // },
            //     select: {
            //         id: true,
            //         name: true,
            //     },
            // });


            return {};

        } catch (error) {
            console.log(error);

            //   this.handleDBErrors(error);
        }

    }

}
