import { ITenant, IUserType } from ".";

export interface IUser {
    id?: string;
    name: string;
    email: string;
    password?: string;
    // UserTypes?: IUserType;
    // Tenants?: ITenant[];
    // UserPermissions?: any;
    // isActive: boolean;
    // updatedAt: Date;
    // createdAt: Date;
}