import { Injectable, NestMiddleware, UnauthorizedException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

import { AuthService } from '../auth.service';

@Injectable()
export class RefreshTokenMiddleware implements NestMiddleware {
    constructor(private readonly authService: AuthService) { }

    async use(req: Request, res: Response, next: NextFunction) {
        const accessToken = req.cookies['token'];
        const refreshToken = req.cookies['refresh_token'];

        try {
            this.authService.verifyAccessToken(accessToken);
            next();
        } catch (error) {

            if (!refreshToken) {
                throw new UnauthorizedException('No refresh token provided');
            }

            const payload = this.authService.verifyRefreshToken(refreshToken);
            const newAccessToken = this.authService.getJwtToken({ id: payload.id });

            res.cookie('token', newAccessToken, {
                httpOnly: true,
                secure: false,
                sameSite: 'strict',
                path: '/', // Asegura que la cookie esté disponible en todas las rutas
            });

            next();
        }
    }
}
