Config = {
    -- Hvor meget xp hvert level skal have (MAX 3 Levels)
    Levels = {
        [1] = 100,
        [2] = 400,
        [3] = 800,
    },

    Logs = {
        XPGain = "", -- XP Gain logs
        CraftWeapon = "", -- Craft Weapon logs
        LevelUp = "", -- Level up logs
        AddedPlayer = "", -- Added player logs
    },

    WeaponBenchLocation = {
        [1] = vector3(2141.3, 4770.98, 41.06),
    },

    EyeSettings = {
        label = "Tilgå våbencraft",
        icon = 'fa-solid fa-cube'
    },

    RequiredItems = {
        weapon_pistol = {
            { item = 'steel', amount = 5 },
            { item = 'plastic', amount = 2 },
        },
        weapon_pistol50 = {
            { item = 'steel', amount = 5 },
            { item = 'plastic', amount = 2 },
        },
        weapon_vintagepistol = {
            { item = 'steel', amount = 5 },
            { item = 'plastic', amount = 2 },
        },
        weapon_ceramicpistol = {
            { item = 'steel', amount = 5 },
            { item = 'plastic', amount = 2 },
        },
        weapon_snspistol = {
            { item = 'steel', amount = 5 },
            { item = 'plastic', amount = 2 },
        },
        weapon_machinepistol = {
            { item = 'steel', amount = 5 },
            { item = 'plastic', amount = 2 },
        },
        weapon_assaultrifle = {
            { item = 'steel', amount = 5 },
            { item = 'plastic', amount = 2 },
        },
        -- Tilføje så man kan crafte det!
        -- våben navnet skal være det samme som i weapon_name    = {
        --     { item = 'steel', amount = 5 },
        --     { item = 'plastic', amount = 2 },
        -- },
    },
    Weapons = {
        {
            title = "Sns Pistol",
            description = "Et våben der bruges af kriminelle.",
            level = 0,
            weapon_name = "weapon_snspistol",
            resources = { "Blueprint", "Sns Part 1", "Sns Part 2", "Sns Part 3"}
        },
        {
            title = "Ceramic Pistol",
            description = "Et våben der bruges af kriminelle.",
            level = 0,
            weapon_name = "weapon_ceramicpistol",
            resources = {"Blueprint", "Part 1", "Part 2", "Part 3", "Part 4"}
        },
        {
            title = "Vintage Pistol",
            description = "Et våben der bruges af kriminelle.",
            level = 0,
            weapon_name = "weapon_vintagepistol",
            resources = {"Blueprint", "Part 1", "Part 2", "Part 3", "Part 4"}
        },
        {
            title = "9MM Pistol",
            description = "Et våben der bruges af kriminelle.",
            level = 1,
            weapon_name = "weapon_pistol",
            resources = {"Blueprint", "Part 1", "Part 2", "Part 3", "Part 4"}
        },
        {
            title = "Desert Eagel",
            description = "Et våben der bruges af kriminelle.",
            level = 2,
            weapon_name = "weapon_pistol50",
            resources = {"Blueprint", "Part 1", "Part 2", "Part 3", "Part 4"}
        },
        {
            title = "Machinepistol",
            description = "Et våben der bruges af kriminelle.",
            level = 2,
            weapon_name = "weapon_machinepistol",
            resources = {"Blueprint", "Part 1", "Part 2", "Part 3", "Part 4"}
        },
        {
            title = "Ak-47",
            description = "Et våben der bruges af kriminelle.",
            level = 3,
            weapon_name = "weapon_assaultrifle",
            resources = { "Blueprint: 1", "Stål: 150", "Stål: 150" }
        },

        -- Sådan tilføjer du et våben
        -- {
        --     title = "Våben title",
        --     description = "En beskrivelse",
        --     level = Det level man skal bruge for at kunne crafte våbnet,
        --     weapon_name = "våben navnet fx weapon_pistol",
        --     resources = { "Item 1", "Item 2" osv}
        -- },
    }
}