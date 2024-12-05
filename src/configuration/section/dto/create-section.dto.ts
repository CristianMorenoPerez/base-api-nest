import { Type } from "class-transformer";
import { IsString, MaxLength, minLength, Min, MinLength, IsOptional, IsArray, ValidateNested } from "class-validator";
import { CreateOptionDto } from "src/configuration/option/dto/create-option.dto";

export class CreateSectionDto {
    @IsOptional()
    id: string
    @IsString()
    @MaxLength(60)
    @MinLength(4)
    icon: string
    @IsString()
    @MaxLength(20)
    @MinLength(4)
    code: string
    @IsString()
    @MaxLength(60)
    @MinLength(4)
    name: string
    @IsString()
    @MaxLength(40)
    @MinLength(4)
    path: string
    // Validación para la relación de las opciones
    @ValidateNested({ each: true })  // Aquí indicamos que cada elemento en el array "options" debe ser validado
    @Type(() => CreateOptionDto)  // Aquí decimos que cada elemento del array debe ser tratado como un "CreateOptionDto"
    options: CreateOptionDto[];  // Campo para el array de opciones
}
