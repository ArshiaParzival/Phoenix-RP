Config = {}

local StringCharset = {}
local NumberCharset = {}

Config.MaxInventorySlots = 25

Config.HasInventoryOpen = false
Config.InventoryBusy = false

Config.Keys = {
 ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
 ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
 ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
 ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
 ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
 ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
 ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
 ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Config.Dumpsters = {
 [1] = {['Model'] = 666561306,    ['Name'] = 'Blauwe Bak'},
 [2] = {['Model'] = 218085040,    ['Name'] = 'Light Blue Bin'},
 [3] = {['Model'] = -58485588,    ['Name'] = 'Gray Bin'},
 [4] = {['Model'] = 682791951,    ['Name'] = 'Big Blue Bin'},
 [5] = {['Model'] = -206690185,   ['Name'] = 'Big Green Bin'},
 [6] = {['Model'] = 364445978,    ['Name'] = 'Big Green Bin'},
 [7] = {['Model'] = 143369,       ['Name'] = 'Small Bin'},
 [8] = {['Model'] = -2140438327,  ['Name'] = 'Unknown Bin'},
 [9] = {['Model'] = -1851120826,  ['Name'] = 'Unknown Bin'},
 [10] = {['Model'] = -1543452585, ['Name'] = 'Unknown Bin'},
 [11] = {['Model'] = -1207701511, ['Name'] = 'Unknown Bin'},
 [12] = {['Model'] = -918089089,  ['Name'] = 'Unknown Bin'},
 [13] = {['Model'] = 1511880420,  ['Name'] = 'Unknown Bin'},
 [14] = {['Model'] = 1329570871,  ['Name'] = 'Unknown Bin'},
}

Config.JailContainers = {
 [1] = {['Model'] = 1923262137, ['Name'] = 'Electric Cabinet 1'},
 [2] = {['Model'] = -686494084, ['Name'] = 'Electric Cabinet 2'},
 [3] = {['Model'] = 1419852836, ['Name'] = 'Electric Cabinet 3'},
}

Config.TrunkClasses = {
 [0] = {['MaxWeight'] = 80000, ['MaxSlots'] = 10},
 [1] = {['MaxWeight'] = 100000, ['MaxSlots'] = 15},
 [2] = {['MaxWeight'] = 100000, ['MaxSlots'] = 15},
 [3] = {['MaxWeight'] = 80000, ['MaxSlots'] = 10},
 [4] = {['MaxWeight'] = 80000, ['MaxSlots'] = 10},
 [5] = {['MaxWeight'] = 80000, ['MaxSlots'] = 10},
 [6] = {['MaxWeight'] = 80000, ['MaxSlots'] = 10},
 [7] = {['MaxWeight'] = 80000, ['MaxSlots'] = 10},
 [9] = {['MaxWeight'] = 100000, ['MaxSlots'] = 15},
 [10] = {['MaxWeight'] = 300000, ['MaxSlots'] = 15},
 [11] = {['MaxWeight'] = 300000, ['MaxSlots'] = 15},
 [12] = {['MaxWeight'] = 300000, ['MaxSlots'] = 15},
 [14] = {['MaxWeight'] = 100000, ['MaxSlots'] = 15},
 [15] = {['MaxWeight'] = 100000, ['MaxSlots'] = 15},
 [17] = {['MaxWeight'] = 100000, ['MaxSlots'] = 15},
 [18] = {['MaxWeight'] = 350000, ['MaxSlots'] = 15},
 [19] = {['MaxWeight'] = 300000, ['MaxSlots'] = 20},
 [20] = {['MaxWeight'] = 300000, ['MaxSlots'] = 20},
}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(StringCharset, string.char(i)) end
for i = 97, 122 do table.insert(StringCharset, string.char(i)) end

Config.RandomStr = function(length)
	if length > 0 then
		return Config.RandomStr(length-1) .. StringCharset[math.random(1, #StringCharset)]
	else
		return ''
	end
end

Config.RandomInt = function(length)
	if length > 0 then
		return Config.RandomInt(length-1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

Config.BackEngineVehicles = {
    'ninef',
    'adder',
    'vagner',
    't20',
    'infernus',
    'zentorno',
    'reaper',
    'comet2',
    'comet3',
    'jester',
    'jester2',
    'cheetah',
    'cheetah2',
    'prototipo',
    'turismor',
    'pfister811',
    'ardent',
    'nero',
    'nero2',
    'tempesta',
    'vacca',
    'bullet',
    'osiris',
    'entityxf',
    'turismo2',
    'fmj',
    're7b',
    'tyrus',
    'italigtb',
    'penetrator',
    'monroe',
    'ninef2',
    'stingergt',
    'surfer',
    'surfer2',
    'comet3',
}

Config.WeaponAttachments = {
  ["WEAPON_CARBINERIFLE_MK2"] = {
    ["suppressor"] = {
        component = "COMPONENT_AT_AR_SUPP",
        label = "Damper",
        item = "rifle_suppressor",
    },
    ["extendedclip"] = {
        component = "COMPONENT_CARBINERIFLE_MK2_CLIP_01",
        label = "Extended Clip",
        item = "rifle_extendedclip",
    },
    ["flashlight"] = {
        component = "COMPONENT_AT_AR_FLSH",
        label = "Flashlight",
        item = "rifle_flashlight",
    },
    ["scope"] = {
        component = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
        label = "Scope",
        item = "rifle_scope",
    },
},
["WEAPON_ASSAULTRIFLE_MK2"] = {
    ["suppressor"] = {
        component = "COMPONENT_AT_AR_SUPP_02",
        label = "Damper",
        item = "rifle_suppressor",
    },
    ["extendedclip"] = {
        component = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
        label = "Extended Clip",
        item = "rifle_extendedclip",
    },
    ["flashlight"] = {
        component = "COMPONENT_AT_AR_FLSH",
        label = "Flashlight",
        item = "rifle_flashlight",
    },
    ["scope"] = {
        component = "COMPONENT_AT_SCOPE_MACRO_MK2",
        label = "Scope",
        item = "rifle_scope",
    },
},
["WEAPON_HEAVYPISTOL"] = {
    ["suppressor"] = {
        component = "COMPONENT_AT_PI_SUPP",
        label = "Damper",
        item = "pistol_suppressor",
    },
},
["WEAPON_SNSPISTOL_MK2"] = {
    ["extendedclip"] = {
        component = "COMPONENT_PISTOL_MK2_CLIP_02",
        label = "Extended Clip",
        item = "pistol_extendedclip",
    },
},
["WEAPON_MACHINEPISTOL"] = {
    ["suppressor"] = {
        component = "COMPONENT_AT_PI_SUPP",
        label = "Damper",
        item = "pistol_suppressor",
    },
    ["extendedclip"] = {
        component = "COMPONENT_MACHINEPISTOL_CLIP_02",
        label = "Extended Clip",
        item = "pistol_extendedclip",
    },
},
["WEAPON_VINTAGEPISTOL"] = {
    ["suppressor"] = {
        component = "COMPONENT_AT_PI_SUPP",
        label = "Damper",
        item = "pistol_suppressor",
    },
    ["extendedclip"] = {
        component = "COMPONENT_VINTAGEPISTOL_CLIP_02",
        label = "Extended Clip",
        item = "pistol_extendedclip",
    },
},
["WEAPON_APPISTOL"] = {
    ["suppressor"] = {
        component = "COMPONENT_AT_PI_SUPP",
        label = "Damper",
        item = "pistol_suppressor",
    },
    ["extendedclip"] = {
        component = "COMPONENT_APPISTOL_CLIP_02",
        label = "Extended Clip",
        item = "pistol_extendedclip",
    },
},
["WEAPON_COMBATPISTOL"] = {
    ["suppressor"] = {
        component = "COMPONENT_AT_PI_SUPP",
        label = "Damper",
        item = "pistol_suppressor",
    },
    ["extendedclip"] = {
        component = "COMPONENT_COMBATPISTOL_CLIP_02",
        label = "Extended Clip",
        item = "pistol_extendedclip",
    },
},
["WEAPON_SMG"] = {
    ["suppressor"] = {
        component = "COMPONENT_AT_PI_SUPP",
        label = "Damper",
        item = "rifle_suppressor",
    },
    ["extendedclip"] = {
        component = "COMPONENT_SMG_CLIP_02",
        label = "Extended Clip",
        item = "rifle_extendedclip",
    },
},
}