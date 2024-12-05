import { IsOptional, IsString } from "class-validator";

export class CreateTenantTypeDto {
    @IsString()
    @IsOptional()
    id?: string;
    @IsString()
    name: string; // Nombre del usuario

}
