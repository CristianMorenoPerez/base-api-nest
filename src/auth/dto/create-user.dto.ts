import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsLowercase, IsString, Matches, MaxLength, MinLength } from 'class-validator';


export class CreateUserDto {

    @ApiProperty({
        example: 'cristian',
        description: 'nombre de usuario',
        uniqueItems: true
    })
    @IsString()
    name: string; // Nombre del usuario
    @ApiProperty({
        example: 'cristian@gmail.com',
        description: 'correo electronico',
    })
    @IsEmail()
    email: string; // Email del usuario
    @IsString()
    password: string; // Contraseña del usuario

}
