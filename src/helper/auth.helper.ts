



export const authParserJson = (permissions: any) => {
    const sectionsMap = new Map();


    permissions.forEach((x) => {
        const section = x.option.section;
        const option = x.option;
        const option_permissions = x.option.option_permissions;

        const permissionIn = x.permissions;
        if (!sectionsMap.has(section.code)) {
            sectionsMap.set(section.code, {
                id: section.id,
                code: section.code,
                name: section.name,
                options: []
            });
        }

        const sectionEntry = sectionsMap.get(section.code);

        if (permissionIn) option_permissions.push({
            permission: permissionIn
        })

        sectionEntry.options.push({
            id: option.id,
            name: option.name,
            path: option.path,
            permissions: option_permissions.map((op) => ({
                id: op.permission.id,
                code: op.permission.code,
                name: op.permission.name
            }))
        });
    })

    return Array.from(sectionsMap.values());

}
