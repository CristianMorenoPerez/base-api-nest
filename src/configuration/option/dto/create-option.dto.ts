import { Type } from "class-transformer"
import { IsOptional, IsString, IsUUID, MaxLength, MinLength } from "class-validator"
import { ISection } from "src/configuration/interfaces"
import { CreateSectionDto } from "src/configuration/section/dto/create-section.dto"

export class CreateOptionDto {
    @IsOptional()
    id: string
    @IsString()
    @MaxLength(40)
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
    @IsOptional()
    section?: any;
}
