import { SetMetadata } from '@nestjs/common';

export const META_PERMISSION = 'permissions';


export const PermissionProtected = (permission: string) => {


    return SetMetadata(META_PERMISSION, permission);
}
