CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- Insertar en la tabla UserTypes
INSERT INTO "userTypes" (id, name) 
VALUES 
    (uuid_generate_v4(), 'Admin');

-- Insertar en la tabla Users
INSERT INTO users (id, name, email, password, "userTypeId") 
VALUES 
    (uuid_generate_v4(), 'Alice Smith', 'alice.smith@example.com', '$2b$10$h6Dj4ae9YgbngMjQls3oquVsdSamosD66SnY4oWbq8xa4TeyM64km', 
    (SELECT id FROM "userTypes" WHERE name = 'Admin'));


    
-- Insertar en la tabla TenantTypes
INSERT INTO "tenantTypes" (id, name) 
VALUES 
    (uuid_generate_v4(), 'Corporate'),
    (uuid_generate_v4(), 'Individual');
    
-- Insertar en la tabla Tenants
INSERT INTO tenants (id, name, address, phone, email, "tenantTypeId" , "userId") 
VALUES 
    (uuid_generate_v4(), 'Company ABC', '123 Main St', '123-456-7890', 'contact@companyabc.com', 
    (SELECT id FROM "tenantTypes" WHERE name = 'Corporate'), 
    (SELECT id FROM users WHERE name = 'Alice Smith'));

-- Insertar en la tabla Sections
INSERT INTO sections (id, icon, code, name) 
VALUES 
    (uuid_generate_v4(), 'icon-dashboard', 'DASH_SEC', 'Dashboard Section'),
    (uuid_generate_v4(), 'icon-settings', 'SET_SEC', 'Settings Section');

-- Insertar en la tabla Options
INSERT INTO options (id, icon, code, name, path, "sectionsId") 
VALUES 
    (uuid_generate_v4(), 'icon-home', 'HOME', 'Home', '/home', (SELECT id FROM sections WHERE code = 'DASH_SEC')),
    (uuid_generate_v4(), 'icon-settings', 'SETTINGS', 'Settings', '/settings', (SELECT id FROM sections WHERE code = 'SET_SEC'));

-- Insertar en la tabla Permissions
INSERT INTO permissions (id, code, name) 
VALUES 
    (uuid_generate_v4(), 'R', 'Read Permission'),
    (uuid_generate_v4(), 'W', 'Write Permission'),
   (uuid_generate_v4(), 'U', 'update Permission'),
  (uuid_generate_v4(), 'D', 'update Permission');
 
 select * from "permissions";
    
-- Insertar en la tabla Option_Permissions
INSERT INTO option_permissions (id, "optionId", "permissionId") 
VALUES 
    (uuid_generate_v4(), 
     (SELECT id FROM options WHERE code = 'SETTINGS'), 
     (SELECT id FROM permissions WHERE code = 'W'));

-- Verificar las inserciones
SELECT * FROM permissions;



INSERT INTO public.user_permissions(
	id, "userId", "userTypeId", "optionId", "permissionId")
	VALUES (uuid_generate_v4(),'b36d9bea-c9e9-4348-8e44-375bcadf126c',null, '66f4367b-71db-4919-aad5-1559f37a1423', '53ac6ea4-df26-449e-a842-c0506da6cdd6');



