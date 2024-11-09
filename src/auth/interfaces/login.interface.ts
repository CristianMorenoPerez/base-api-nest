import { IUserType, ITenant, ITenantType, ISection } from "src/core/interfaces";

export interface ILogin {
    id: string,
    email: string,
    password: string;
    userType: IUserType,
    tenant: ITenant,
    tenantType: ITenantType,
    permissions: ISection[];
}