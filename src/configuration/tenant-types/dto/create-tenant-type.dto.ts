import { IsString } from "class-validator";

export class CreateTenantTypeDto {
    @IsString()
    name: string; // Nombre del usuario

}
