import { IsUUID, IsString, IsBoolean, IsOptional } from 'class-validator';

export class CreateTenantTypeDto {


    @IsString()
    name: string; // Nombre del TenantType
    // Estado de actividad del TenantType, opcional

    @IsUUID()
    @IsOptional()
    createdBy: string; // UUID del usuario que creó el TenantType

}
