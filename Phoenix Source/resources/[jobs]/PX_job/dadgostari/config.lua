DadgostariConfig                            = {}

DadgostariConfig.DrawDistance               = 7.0
DadgostariConfig.MarkerType                 = 20
DadgostariConfig.MarkerSize                 = { x = 0.5, y = 0.5, z = 0.3 }
DadgostariConfig.MarkerColor                = { r = 255, g = 255, b = 255 }

DadgostariConfig.EnablePlayerManagement     = true
DadgostariConfig.EnableArmoryManagement     = true
DadgostariConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
DadgostariConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
DadgostariConfig.EnableSocietyOwnedVehicles = false
DadgostariConfig.EnableLicenses             = true -- enable if you're using esx_license
DadgostariConfig.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

DadgostariConfig.MaxInService               = -1
DadgostariConfig.Locale                     = 'en'

DadgostariConfig.DadgostariStations = {

	dadgostari = {

		Blip = {
			Pos     = { x = -544.96, y = -204.12, z = 38.22 }, 
			Sprite  = 419,
			Display = 4,
			Scale   = 1.0,
			Colour  = 0,
		},

		Cloakrooms = {
			{ x = -518.56, y = -192.48, z = 38.22 },
		},

		Stocks = {
			{ x = -545.45, y = -196.27, z = 47.41 },
		},


		Armories = {
			{ x = -517.17, y = -195.74, z = 38.22 },
		},

		Vehicles = {
			{
				Spawner    = { x = -520.68, y = -260.92, z = 35.51 },
				SpawnPoint = { x = -515.39, y = -263.88, z = 35.05 }, 
				Heading    = 112.44
			}
		},

		VehicleDeleters = {
			{ x = -520.98, y = -266.26, z = 35.33 },
		},

		BossActions = {
			{ x = -522.48, y = -195.24, z = 38.22 },
		},

	}

}

DadgostariConfig.Items = {
	label = "DOJ Gun Safe",
	slots = 30,
	items = {
		[1] = {
		  name = "weapon_pistol_mk2",
		  price = 500,
		  count = 1,
		  info = {
			  serie = "DOJ"..math.random(1000000, 10000000),
			  melee = false,
			  quality = 100.0,     
			  attachments = {{component = "COMPONENT_AT_PI_FLSH_02", label = "Flashlight"}}
		  },
		  type = "weapon",
		  slot = 1,
		},
		[2] = {
		  name = "weapon_stungun",
		  price = 300,
		  count = 1,
		  info = {
			  serie = "DOJ"..math.random(1000000, 10000000),
			  melee = false,
			  quality = 100.0,
		  },
		  type = "weapon",
		  slot = 2,
		},
		[3] = {
		  name = "weapon_carbinerifle_mk2",
		  price = 1000,
		  count = 1,
		  info = {
			serie = "DOJ"..math.random(1000000, 10000000),
			melee = false,
			quality = 100.0,
			attachments = {{component = "COMPONENT_AT_SCOPE_MEDIUM_MK2", label = "Scope"}, {component = "COMPONENT_AT_MUZZLE_05", label = "Muzzle Demper"}, {component = "COMPONENT_AT_AR_AFGRIP_02", label = "Grip"}, {component = "COMPONENT_AT_AR_FLSH", label = "Falshlight"}}    
		  },
		  type = "weapon",
		  slot = 3,
		},
		[4] = {
		  name = "weapon_flashlight",
		  price = 130,
		  count = 1,
		  info = {
			melee = true,
			quality = 100.0
		  },
		  type = "weapon",
		  slot = 4,
		},
		[5] = {
		  name = "weapon_nightstick",
		  price = 100,
		  count = 1,
		  info = {
			melee = true,
			quality = 100.0
		  },
		  type = "weapon",
		  slot = 5,
		},
		[6] = {
		  name = "pistol-ammo",
		  price = 50,
		  count = 50,
		  info = {},
		  type = "item",
		  slot = 6,
		},
		[7] = {
		  name = "rifle-ammo",
		  price = 150,
		  count = 50,
		  info = {},
		  type = "item",
		  slot = 7,
		},
		[8] = {
		  name = "taser-ammo",
		  price = 25,
		  count = 50,
		  info = {},
		  type = "item",
		  slot = 8,
		},
		[9] = {
		  name = "radio",
		  price = 300,
		  count = 50,
		  info = {},
		  type = "item",
		  slot = 9,
		},
		[10] = {
		  name = "weapon_sawnoffshotgun",
		  price = 2000,
		  count = 1,
		  info = {
			  serie = "DOJ"..math.random(1000000, 10000000),
			  melee = false,
			  quality = 100.0
		  },
		  type = "weapon",
		  slot = 10,
		},
		[11] = {
		  name = "shotgun-ammo",
		  price = 200,
		  count = 50,
		  info = {},
		  type = "item",
		  slot = 11,
		},
	 }
  }