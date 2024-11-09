import { ISection, ITenant, ITenantType, IUserType } from "src/core/interfaces";
import { ILogin } from "./login.interface";



export interface ResponseAuth {
    data: ILogin
    token: string;
}