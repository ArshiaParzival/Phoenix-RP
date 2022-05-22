Config = {}

Config.BlackMoney = false -- for hold corner system


Config.Corners = {

    [1] = {
        coord = vector3(191.2, -1764.08, 29.16),
        items = {"packagedweed", "packagedmeth", "packagedcoca"},
        radius = 30.0,
        minMoney = 100,
        maxMoney = 150,
        spawnpoints = {
            vector3(244.52, -1745.2, 28.8),
            vector3(238.4, -1797.16, 27.84),
        }
    },
    [2] = {
        coord = vector3(451.64, -1829.6, 27.84),
        items = {"packagedweed", "packagedmeth", "packagedcoca"},
        radius = 30.0,
        minMoney = 100,
        maxMoney = 150,
        spawnpoints = {
            vector3(418.68, -1807.44, 28.68),
            vector3(407.56, -1861.72, 26.84),
        },
    }

}

Config.ItemsName = {

    ["packagedweed"] = "Package Weed",
    ["packagedmeth"] = "Package Meth",
    ["packagedcoca"] = "Arosak Cocain",

}


Config.methLab = {

    entry = { -- DON'T TOUCH!
        coord = vector3(809.89, -490.92, 30.63), 
        intcoord = vector3(997.48, -3200.8, -36.4), 
        entryheading = 194.3,
        intheading = 250.19,
        text = "[E] Estefade Az Cart Makhsos Baraye Vorod", 
        requiredItem = true,
        item = "labcard", 
    },
    exit = { -- DON'T TOUCH!
        intcoord = vector3(997.16, -3200.64, -36.4), 
        coord = vector3(809.89, -490.92, 30.63), 
        text = "[E] Khroj",
        heading = 90.0, 
    },
    cookZone = { -- DON'T TOUCH!
        coord = vector3(1005.80,-3200.40,-38.52),
        text = "[E] Pokht",
        startingCoord = vector3(1007.76, -3200.64, -39.0),
        startingText = "[E] Shoro Pokht",
        methMinCount = 10,
        methMaksCount = 20,
        takeMethText = "[E] Bardashtan Meth"
    },
    packageZone = { -- DON'T TOUCH!
        coord = vector3(1011.80,-3194.90,-38.99),
        text = "[E] Tabdil Be Package",
        takeMethText = "[E] Bardashtan Pack Meth",
    }

}

Config.Coca = {

    entry = { -- DON'T TOUCH!
        coord = vector3(1004.6, -1572.88, 30.8), 
        intcoord = vector3(1088.56, -3188.12, -39.0), 
        intheading = 183.55,
        text = "[E] Vrood", 
    },
    exit = { -- DON'T TOUCH!
        intcoord = vector3(1088.72, -3187.8, -39.0), 
        coord = vector3(1004.6, -1572.88, 30.8), 
        text = "[E] Khroj",
        heading = 90.0, 
    }, 
    gatheringZone = {
        coords = {
            [1] = {coord = vector3(1093.0, -3194.84, -39.0), heading = 183.39, rotx = -1.91, roty = -0.32, rotz = -0.60},
            [2] = {coord = vector3(1095.4, -3194.92, -39.0), heading = 183.39, rotx = -1.91, roty = -0.32, rotz = -0.60},
            [3] = {coord = vector3(1090.32, -3194.88, -39.0), heading = 183.39, rotx = -2.0, roty = -0.32, rotz = -0.60},
        },
        text = "[E] Joda Kardan Cocain",
        takeCoca = "[E] Bardashtan Cocain",
        count = 5, 
    },
    packageZone = {
        coord = vector3(1101.245,-3198.82,-39.0),
        text = "[E] jasaz Kardan Cocain Dar Arosak",
        takePackCoc = "[E] Bardashtan Arosak Cocain",
        heading = 180.34,
        count = 10, 
    }
}

Config.Weed = {
    entry = {
        coord = vector3(2482.22, 3722.56, 43.92),
        intcoord = vector3(1066.0, -3183.48, -39.16),
        intheading = 212.47,
        text = "[E] Vrood",
    },
    exit = {
        intcoord = vector3(1066.0, -3183.48, -39.16),
        coord = vector3(2482.22, 3722.56, 43.92),
        heading = 254.92,
        text = "[E] Khroj",
    },
    gatheringZone = {
        coords = {
            [1] = {coord = vector3(1057.56, -3196.76, -39.16), heading = 170.81},
            [2] = {coord = vector3(1062.92, -3190.92, -39.16), heading = 170.81},
            [3] = {coord = vector3(1051.44, -3204.0, -39.12), heading = 170.81},
        },
        text = "[E] Jam Kardan Cannabis",
        count = 1,
    },
    packageZone = {
        coords = {
            [1] = {coord =  vector3(1039.08, -3205.88, -37.72), heading = 83.31, rotx = -0.60, roty = 0.0, rotz = -1.4},
            [2] = {coord = vector3(1034.56, -3206.16, -37.68), heading = 83.31, rotx = -0.60, roty = 0.0, rotz = -1.4},
        },
        text = "[E] Pack Kardan Cannabis",
        count = 1, 
        takeText = "[E] Bardashtan Pack Weed",
    }
}


Config.Laundry = {
    entry = {
        coord = vector3(84.04, -1551.96, 29.6),
        intcoord = vector3(1138.0, -3198.96, -39.68),
        intheading = 11.64,
        text = "[E] Vrood",
    },
    exit = {
        intcoord = vector3(1138.0, -3198.96, -39.68),
        coord = vector3(83.64, -1551.64, 29.6),
        heading = 46.85,
        text = "[E] Khroj",
    },
    cuttingZone = {
        coords = vector3(1122.24, -3197.88, -40.4), 
        heading = 179.46,
        text = "[E] CORTAR DINERO",
        countmin = 100,
        countmax = 200,
    },
    packageZone = {
        coord = vector3(1120.12, -3197.88, -39.92), 
        heading = 180.93,
        text = "[E] LAVAR DINERO", 
    },
    washingZone = {
    coord = vector3(1122.32, -3194.6, -40.4), 
    heading = 346.76,
    text = "[E] RECOGER", 
}

}