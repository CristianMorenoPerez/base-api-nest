import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, Matches, MaxLength, MinLength } from 'class-validator';


export class LoginUserDto {

    @IsString()
    @IsEmail()
    @ApiProperty({
        example: 'email',
        description: 'correo para iniciar session',
    })
    email: string;

    @IsString()
    @MinLength(6)
    @MaxLength(50)
    // @Matches(
    //     /(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    //     message: 'The password must have a Uppercase, lowercase letter and a number'
    // })
    @ApiProperty({
        example: '@4rercris3',
        description: 'contraseña de usuario',
    })
    password: string;

}