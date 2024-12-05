import { ISection } from "src/configuration/interfaces";
import { IUserType, ITenant, ITenantType, } from "src/core/interfaces";

export interface ILogin {
    id: string,
    email: string,
    password: string;
    userType: IUserType,
    tenants: ITenant[],
    tenantType: ITenantType,
    permissions: ISection[];
}