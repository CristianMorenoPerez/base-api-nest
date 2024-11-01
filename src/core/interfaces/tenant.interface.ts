import { ITenantType, IUser } from ".";

export interface ITenant {
    id: string;                // UUID del Tenant
    name: string;              // Nombre único del Tenant
    address: string;           // Dirección del Tenant
    phone: string;             // Teléfono del Tenant
    email: string;             // Correo del Tenant
    tenantType: ITenantType;   // Relación con TenantTypes
    tenantTypeId: string;      // UUID del TenantType relacionado
    user: IUser;               // Relación con el modelo Users
    userId: string;            // UUID del usuario relacionado
    isActive: boolean;         // Estado de actividad del Tenant
    createdBy: string;         // UUID del usuario que creó el Tenant
    updatedAt: Date;           // Fecha de última actualización
    createdAt: Date;           // Fecha de creación
}
