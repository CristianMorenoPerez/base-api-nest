import { IOption } from "./option.interface";


export interface ISection {
    id: string;
    name: string;
    icon: string;
    path: string;
    Options?: IOption[]

}