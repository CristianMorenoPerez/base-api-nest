import { Itenanttype } from "./tenantType.interface";

export interface Itenant {
    id?: string;
    name: string;
    address: string;
    phone: string;
    email: string;
    tenantType?: Itenanttype;
}