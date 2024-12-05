
ALTER TABLE public.users ALTER COLUMN "userTypeId" DROP NOT NULL;
-- ir a la api y crear el usuario base
-- ALTER TABLE public.users ALTER COLUMN "userTypeId" SET NOT NULL;




INSERT INTO public."tenantTypes"
    (name)
VALUES
    ('ROOT');



INSERT INTO public.tenants
    (
    name, address, phone, email, "tenantTypeId", "userId")
VALUES
    ('super root', 'stree', '00000', 'superSu@tenant.com', (SELECT id
        FROM public."tenantTypes"
        WHERE name = 'ROOT'), (SELECT id
        FROM public.users
        where email = 'super.admin@example.com'));


SELECT id
FROM public.tenants;

INSERT INTO public."userTypes"
    (
    name, "tenantId")
VALUES
    ( 'ROOT', (SELECT id
        FROM public."tenants"
        WHERE email = 'superSu@tenant.com'));

SELECT id
FROM public."userTypes";

UPDATE public.users
	SET  "userTypeId"= '9c8f3c61-baa1-4be6-b725-46ce26d8cf02'
	WHERE email = 'super.admin@example.com';

ALTER TABLE public.users ALTER COLUMN "userTypeId"
SET
NOT NULL;


INSERT INTO public.sections
    (
    icon, code, name, path)
VALUES
    ( 'ajust-icon', '00S-1', 'Ajustes', 'settings');


INSERT INTO public.options
    (
    icon, code, name, path, "sectionsId")
VALUES
    ( 'set-icon', '00O-1', 'secciones', 'sections', (SELECT id
        FROM public.sections
        where code = '00S-1'));

INSERT INTO public.permissions
    ( code, name)
VALUES
    ( 'R', 'Read Permission'),
    ( 'W', 'Write Permission'),
    ( 'U', 'update Permission'),
    ( 'D', 'delete Permission');



INSERT INTO public.user_permissions
    (
    "userId", "userTypeId", "optionId", "permissionId")
VALUES
    ( (SELECT id
        FROM public.users
        where email = 'super.admin@example.com'), null, (SELECT id
        FROM public."options"
        where code = '00O-1'), (SELECT id
        FROM public.permissions
        where code = 'D') );



select public.login('super.admin@example.com');


