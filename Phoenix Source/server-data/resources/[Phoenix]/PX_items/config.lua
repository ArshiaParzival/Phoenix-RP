Config = Config or {}

Config.CurrentWeaponData = nil

Config.DurabilityBlockedWeapons = {"weapon_stungun", "weapon_unarmed", "weapon_molotov"}
Config.DurabilityMultiplier = {['weapon_carbinerifle_mk2'] = 0.25, ['weapon_assaultrifle_mk2'] = 0.25, ['weapon_smg'] = 0.25, ['weapon_microsmg'] = 0.25, ['weapon_heavypistol'] = 0.25, ['weapon_pistol_mk2'] = 0.25, ['weapon_snspistol_mk2'] = 0.25, ['weapon_nightstick'] = 0.5, ['weapon_flashlight'] = 0.5, ['weapon_switchblade'] = 0.5, ['weapon_wrench'] = 0.5, ['weapon_hatchet'] = 0.5, ['weapon_hammer'] = 0.5, ['weapon_bread'] = 0.5, ['weapon_sawnoffshotgun'] = 0.25, ['weapon_appistol'] = 0.25, ['weapon_machinepistol'] = 0.25, ['weapon_musket'] = 0.25, ['weapon_vintagepistol'] = 0.25}  

Config.WeaponsList = {
 -- // Unarmed \\ --
 [GetHashKey('weapon_unarmed')]     = {['Name'] = 'Hands',       ['IdName'] = 'weapon_unarmed',     ['AmmoType'] = nil,          ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_nightstick')]  = {['Name'] = 'Baton',       ['IdName'] = 'weapon_nightstick',  ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_flashlight')]  = {['Name'] = 'Flashlight',     ['IdName'] = 'weapon_flashlight',  ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_hatchet')]     = {['Name'] = 'Hatchet',     ['IdName'] = 'weapon_hatchet',     ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_switchblade')] = {['Name'] = 'Switchblade',     ['IdName'] = 'weapon_switchblade', ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_hammer')]      = {['Name'] = 'Hammer',      ['IdName'] = 'weapon_hammer',      ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_wrench')]      = {['Name'] = 'Wrench', ['IdName'] = 'weapon_wrench',      ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 [GetHashKey('weapon_bread')]       = {['Name'] = 'Bread',   ['IdName'] = 'weapon_bread',       ['AmmoType'] = 'AMMO_MELEE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 
 [GetHashKey('weapon_molotov')]     = {['Name'] = 'Molotov Cocktail', ['IdName'] = 'weapon_molotov',  ['AmmoType'] = 'AMMO_FIRE', ['MaxAmmo'] = nil, ['Recoil'] = nil},
 -- // Pistols \\ --
 [GetHashKey('weapon_snspistol_mk2')]  = {['Name'] = 'Sns Pistool',     ['IdName'] = 'weapon_snspistol_mk2',   ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 6, ['Recoil'] = 2.5},
 [GetHashKey('weapon_pistol_mk2')]     = {['Name'] = 'Glock 17',        ['IdName'] = 'weapon_pistol_mk2',      ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 12, ['Recoil'] = 2.5},
 [GetHashKey('weapon_heavypistol')]    = {['Name'] = 'Heavy Pistool',   ['IdName'] = 'weapon_heavypistol',     ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 18, ['Recoil'] = 2.5},
 [GetHashKey('weapon_vintagepistol')]  = {['Name'] = 'Clasic Pistool', ['IdName'] = 'weapon_vintagepistol',   ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 7, ['Recoil'] = 2.5},
 -- // SMG Pistols \\ --
 [GetHashKey('weapon_machinepistol')]  = {['Name'] = 'Machine Pistool',   ['IdName'] = 'weapon_machinepistol', ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 12, ['Recoil'] = 3.5},
 [GetHashKey('weapon_appistol')]       = {['Name'] = 'AP Pistool',        ['IdName'] = 'weapon_appistol',      ['AmmoType'] = 'AMMO_PISTOL', ['MaxAmmo'] = 18, ['Recoil'] = 3.5},
 -- // SMG \\ --
 [GetHashKey('weapon_microsmg')]       = {['Name'] = 'Micro SMG',         ['IdName'] = 'weapon_microsmg',      ['AmmoType'] = 'AMMO_SMG', ['MaxAmmo'] = 16, ['Recoil'] = 3.5},
 [GetHashKey('weapon_smg')]            = {['Name'] = 'SMG',               ['IdName'] = 'weapon_smg',           ['AmmoType'] = 'AMMO_SMG', ['MaxAmmo'] = 30, ['Recoil'] = 3.5},
 -- Shotgun --
 [GetHashKey('weapon_sawnoffshotgun')]  = {['Name'] = 'Shotgun',   ['IdName'] = 'weapon_sawnoffshotgun', ['AmmoType'] = 'AMMO_SHOTGUN', ['MaxAmmo'] = 8, ['Recoil'] = 0.35},
 [GetHashKey('weapon_musket')]          = {['Name'] = 'Musket',   ['IdName'] = 'weapon_musket', ['AmmoType'] = 'AMMO_SHOTGUN', ['MaxAmmo'] = 5, ['Recoil'] = 0.35},
 -- // Rifles \\ --
 [GetHashKey('weapon_carbinerifle_mk2')]  = {['Name'] = 'Carbine Rifle',   ['IdName'] = 'weapon_carbinerifle_mk2', ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 30, ['Recoil'] = 0.15},
 [GetHashKey('weapon_assaultrifle_mk2')]  = {['Name'] = 'Assault Rifle',   ['IdName'] = 'weapon_assaultrifle_mk2', ['AmmoType'] = 'AMMO_RIFLE', ['MaxAmmo'] = 30, ['Recoil'] = 0.15},
}

Config.WeaponAttachments = {
    ["WEAPON_CARBINERIFLE_MK2"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_AR_SUPP",
            label = "Demper",
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
        ["grip"] = {
            component = "COMPONENT_AT_AR_AFGRIP_02",
            label = "Grip",
            item = "rifle_grip",
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
            label = "Demper",
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
        ["grip"] = {
            component = "COMPONENT_AT_AR_AFGRIP_02",
            label = "Grip",
            item = "rifle_grip",
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
            label = "Demper",
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
            label = "Demper",
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
            label = "Demper",
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
            label = "Demper",
            item = "pistol_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_APPISTOL_CLIP_02",
            label = "Extended Clip",
            item = "pistol_extendedclip",
        },
    },
    ["WEAPON_SMG"] = {
        ["suppressor"] = {
            component = "COMPONENT_AT_PI_SUPP",
            label = "Demper",
            item = "rifle_suppressor",
        },
        ["extendedclip"] = {
            component = "COMPONENT_SMG_CLIP_02",
            label = "Extended Clip",
            item = "rifle_extendedclip",
        },
    },
}

Config.Products = {
    ['Weapon'] = {
      [1] = {
        name = "weapon_snspistol_mk2",
        price = 15000,
        count = 100,
        info = {},
        type = "item",
        slot = 1,
      },
      [2] = {
        name = "pistol-ammo",
        price = 400,
        count = 100,
        info = {},
        type = "item",
        slot = 2,
       },
       [3] = {
        name = "weapon_switchblade",
        price = 1000,
        count = 100,
        info = {},
        type = "item",
        slot = 3,
       },
    },
}

Config.Shops = {
  [1] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 21.77,
      ['Y'] = -1106.99,
      ['Z'] = 29.8,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [2] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -662.1,
      ['Y'] = -935.3,
      ['Z'] = 20.8,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [3] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 810.2,
      ['Y'] = -2157.3,
      ['Z'] = 28.6,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [4] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 1693.4,
      ['Y'] = 3759.5,
      ['Z'] = 33.7,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [5] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -330.2,
      ['Y'] = 6083.8,
      ['Z'] = 30.4,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [6] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 252.3,
      ['Y'] = -50.0,
      ['Z'] = 68.9,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [7] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 2567.6,
      ['Y'] = 294.3,
      ['Z'] = 107.7,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [8] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -1117.5,
      ['Y'] = 2698.6,
      ['Z'] = 17.5,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [9] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = 842.4,
      ['Y'] = -1033.4,
      ['Z'] = 27.1,
    },
    ['Product'] = Config.Products["Weapon"]
  },
  [10] = {
    ['Name'] = 'Weapon Store',
    ['Type'] = 'Store',
    ['Coords'] = {
      ['X'] = -1306.2,
      ['Y'] = -394.0,
      ['Z'] = 35.6,
    },
    ['Product'] = Config.Products["Weapon"]
  },
}