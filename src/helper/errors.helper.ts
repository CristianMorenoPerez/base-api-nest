import {

    Logger,
    HttpException,
    HttpStatus
} from "@nestjs/common";

export class ErrorHelper {
    static handleDbError(error: any): HttpException | null {
        const logger = new Logger(ErrorHelper.name);

        if (!error || !error.message) {
            logger.error(error.message)
            return new HttpException('Server error', HttpStatus.BAD_GATEWAY);
        }

        // vamos a validar las peticiones 
        const httpStatusCode = {
            404: HttpStatus.NOT_FOUND,
            401: HttpStatus.UNAUTHORIZED,
            500: HttpStatus.INTERNAL_SERVER_ERROR,
            // Agrega más códigos según necesites
        };


        switch (error.status) {
            case 404:
                return new HttpException(
                    error.message || 'Record not found',
                    httpStatusCode[error.status]
                );

            case 401:
                return new HttpException(
                    error.message,
                    httpStatusCode[error.status]
                );


        }


        const prismaErrorCodes = {
            'P2002': 'Duplicate entry detected',
            'P2003': 'Foreign key constraint failed',
            'P0001': 'User not found'
        };



        if (prismaErrorCodes[error?.meta?.code || error.code]) {
            return new HttpException(prismaErrorCodes[error?.meta?.code || error.code], HttpStatus.CONFLICT);
        }



        logger.error(error.message)
        return new HttpException('Database conflict error', HttpStatus.INTERNAL_SERVER_ERROR);
    }
}