import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
    Logger
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ErrorHelper } from 'src/helper/errors.helper';


@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
    private readonly logger = new Logger(GlobalExceptionFilter.name);

    catch(error: unknown, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();
        const request = ctx.getRequest<Request>();
        const getError = ErrorHelper.handleDbError(error);
        const errorResponse = this.generateErrorResponse(getError.getStatus(), getError, request);
        const status = getError.getStatus();

        this.logger.error(
            `${request.method} ${request.url}`,
            JSON.stringify(errorResponse)
        );

        response
            .status(status)
            .json(errorResponse);


    }

    private generateErrorResponse(status: number, error: any, request: Request) {


        if (!error || !(error instanceof Error)) {

            return {
                statusCode: status,
                timestamp: new Date().toISOString(),
                path: request.url,
                message: 'Unexpected error format'
            };
        }

        if (error || (error instanceof Error)) {


            return {
                statusCode: status,
                timestamp: new Date().toISOString(),
                path: request.url,
                message: error.message
            };
        }

    }
}