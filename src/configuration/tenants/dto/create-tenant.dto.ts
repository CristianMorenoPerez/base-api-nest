import { Type } from "class-transformer";
import { IsString, IsPhoneNumber, IsEmail, IsOptional } from "class-validator";
import { CreateTenantTypeDto } from "src/configuration/tenant-types/dto/create-tenant-type.dto";


export class CreateTenantDto {
    @IsOptional()
    id: string;
    @IsString()
    name: string; // Nombre del usuario
    @IsString()
    address: string
    @IsString()
    phone: string;
    @IsEmail()
    email: string;
    @IsString()
    tenantTypeId: string
}
