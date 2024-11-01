import { IUser } from ".";

export interface IUserType {
    id: string;                 // UUID de UserType
    name: string;               // Nombre único de UserType
    user: IUser;                // Relación con el modelo Users
    userId: string;             // UUID del usuario relacionado
    // UserPermissions?: IUserPermissions; // Relación opcional con UserPermissions
    isActive: boolean;          // Estado de actividad de UserType
    createdBy: string;          // UUID del usuario que creó este registro
    updatedAt: Date;            // Fecha de última actualización
    createdAt: Date;            // Fecha de creación
}