
Config = {}
Translation = {}

Translation = {
    ['de'] = {
        ['DJ_interact'] = 'Drücke ~g~E~s~, um auf das DJ Pult zuzugreifen',
        ['title_does_not_exist'] = '~r~Dieser Titel existiert nicht!',
    },

    ['en'] = {
        ['DJ_interact'] = 'Dokme ~g~E~s~, Baraye Baz Shodan Pannel DJ',
        ['title_does_not_exist'] = '~r~This title does not exist!',
    }
}

Config.Locale = 'en'

Config.useESX = true -- can not be disabled without changing the callbacks
Config.enableCommand = false

Config.enableMarker = true -- purple marker at the DJ stations

Config.DJPositions = {
    {
        name = 'StreetClub',
        pos = vector3(121.09833, -1281.293, 29.480466),
        requiredJob = "streetblub",
        range = 25.0,
        volume = 1.0 --[[ do not touch the volume! --]]
    },
    {
        name = 'Cafe',
        pos = vector3(99.5, 203.46, 108.37),
        requiredJob = "cafe",
        range = 25.0,
        volume = 1.0 --[[ do not touch the volume! --]]
    },
    {
        name = 'Bahamas',
        pos = vector3(-1378.85, -629.35, 30.63),
        requiredJob = "bahamas",
        range = 25.0,
        volume = 1.0 --[[ do not touch the volume! --]]
    },
    {
        name = 'WerdenClub',
        pos = vector3(-369.54, 204.25, 80.95),
        requiredJob = "WerdenClub",
        range = 25.0,
        volume = 1.0 --[[ do not touch the volume! --]]
    },
    {
        name = 'Casino',
        pos = vector3(1121.09, 214.87, -49.44),
        requiredJob = "casino",
        range = 40.0,
        volume = 1.0 --[[ do not touch the volume! --]]
    }
}