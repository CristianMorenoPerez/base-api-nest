
import { IPermission } from "./permission.interface";


export interface IOption {
    id: string;
    name: string;
    code: string;
    icon: string;
    path: string;
    // sectionId?: string;
    permissions?: IPermission[]
}