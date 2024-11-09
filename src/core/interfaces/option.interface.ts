import { IPermission } from "./permission.interface";


export interface IOption {
    id: string;
    name: string;
    icon: string;
    path: string;
    permissions: IPermission[]
}