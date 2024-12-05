import { Controller, Get, Post, Body, UseGuards, Req, Headers, SetMetadata, Res } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { IncomingHttpHeaders } from 'http';


import { AuthService } from './auth.service';
import { RawHeaders, GetUser, Auth } from './decorators';

import { CreateUserDto, LoginUserDto } from './dto';
import { UserPermissionGuard } from './guards/user-permission.guard';
import { ResponseAuth, ValidRoles } from './interfaces';
import { IUser } from 'src/core/interfaces';
import { Response } from 'express';

@ApiTags('authentication')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }



  @Post('register')
  @ApiResponse({ status: 201, description: 'usuario creado con exito ', type: CreateUserDto })
  @ApiResponse({ status: 400, description: 'peticion no ejecutada' })

  createUser(@Body() createUserDto: CreateUserDto) {
    return this.authService.create(createUserDto);
  }

  @Post('login')
  @ApiResponse({ status: 201, description: 'login ', type: LoginUserDto })
  @ApiResponse({ status: 400, description: 'peticion no ejecutada' })
  async loginUser(@Body() loginUserDto: LoginUserDto, @Res() resp: Response) {
    let response: ResponseAuth = await this.authService.login(loginUserDto);


    resp.cookie('token', response.token, { httpOnly: true, secure: false, sameSite: 'strict', path: '/' });
    resp.cookie('refresh_token', response.refreshToken, { httpOnly: true, secure: false, sameSite: 'strict', path: '/', });


    delete response.token;
    delete response.refreshToken

    resp.send(response);


  }

  // @Get('check-status')
  // @Auth()
  // checkAuthStatus(
  //   @GetUser() user: User
  // ) {
  //   return this.authService.checkAuthStatus( user );
  // }


  @Get('private')
  @Auth()
  testingPrivateRoute(
    @Req() request: Express.Request,
    @GetUser() user: IUser,
    @GetUser('email') userEmail: string,

    @RawHeaders() rawHeaders: string[],
    @Headers() headers: IncomingHttpHeaders,
  ) {


    return {
      ok: true,
      message: 'Hola Mundo Private',
      user,
      userEmail,
      rawHeaders,
      headers
    }
  }


  // @SetMetadata('roles', ['admin','super-user'])

  @Get('private2')
  // @RoleProtected(ValidRoles.superUser, ValidRoles.admin)
  @UseGuards(AuthGuard(), UserPermissionGuard)
  privateRoute2(
    // @GetUser() user: User
  ) {

    return {
      ok: true,
      // user
    }
  }


  // @Get('private3')
  // @Auth(ValidRoles.admin)
  // privateRoute3(
  //   // @GetUser() user: User
  // ) {

  //   return {
  //     ok: true,
  //     // user
  //   }
  // }



}
