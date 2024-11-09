import { ITenantType, IUser } from ".";

export interface ITenant {
    id: string;                // UUID del Tenant
    name: string;              // Nombre único del Tenant
    address: string;           // Dirección del Tenant
    phone: string;             // Teléfono del Tenant
    email: string;             // Correo del Tenant
}
