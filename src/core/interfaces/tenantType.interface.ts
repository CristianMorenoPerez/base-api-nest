import { ITenant } from ".";

export interface ITenantType {
    id: string;               // UUID del TenantType
    name: string;             // Nombre único del TenantType
    Tenants?: ITenant[];      // Relación con varios Tenants
    isActive: boolean;        // Estado de actividad del TenantType
    createdBy: string;        // UUID del usuario que creó este TenantType
    updatedAt: Date;          // Fecha de última actualización
    createdAt: Date;          // Fecha de creación
}