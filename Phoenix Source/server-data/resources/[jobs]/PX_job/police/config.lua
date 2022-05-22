PDConfig                            = {}

PDConfig.DrawDistance               = 7.0
PDConfig.MarkerType                 = 2
PDConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.5 }
PDConfig.MarkerColor                = { r = 10, g = 15, b = 85 }

PDConfig.EnablePlayerManagement     = true
PDConfig.EnableArmoryManagement     = true
PDConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
PDConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
PDConfig.EnableSocietyOwnedVehicles = false
PDConfig.EnableLicenses             = true -- enable if you're using esx_license
PDConfig.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society

PDConfig.MaxInService               = -1
PDConfig.Locale                     = 'en'

PDConfig.PoliceStations = {

	MRPD = {

		Blip = {
			Pos     = { x = 445.94, y = -984.41, z = 30.69 },
			Sprite  = 60,
			Display = 4,
			Scale   = 0.9,
			Colour  = 3,
		},

		Cloakrooms = {
			{ x = 413.13, y = -988.92, z = 29.42 }
		},
		
		Stocks = {
			{ x = 631.84, y = -10.59, z = 182.58 }
		},


		Armories = {
			vector3(484.21, -1001.87, 25.73),
		},

		Vehicles = {
			{
				Spawner    = { x = 463.31, y = -975.44, z = 25.7 },
				SpawnPoint = { x = 434.97, y = -977.76, z = 25.7 },
				Heading    = 91.66,
				Heli    = { x = 449.36, y = -981.37, z = 43.69 },
				HHeading    = 89.68
			}
		},

		VehicleDeleters = {
			{ x = 453.21, y = -981.77, z = 25.7 },
			{ x = 449.0, y = -981.21, z = 43.69 },
			{ x = 481.49, y = -982.15, z = 41.01 }
		},

		BossActions = {
			{ x = 414.76, y = -983.59, z = 29.44 }
		},

	},

	Davis = {

		Blip = {
			Pos     = { x = 368.32, y = -1602.54, z = 29.29 },
			Sprite  = 60,
			Display = 4,
			Scale   = 0.9,
			Colour  = 5,
		},

		Cloakrooms = {
			{ x = 368.32, y = -1602.54, z = 29.29 }
		},
		
		Stocks = {
			{ x = 631.84, y = -10.59, z = 182.58 }
		},


		Armories = {
			vector3(365.49, -1608.94, 29.29),
		},

		Vehicles = {
			{
				Spawner    = { x = 375.01, y = -1616.59, z = 29.29 },
				SpawnPoint = { x = 388.68, y = -1622.07, z = 29.29 },
				Heading    = 320.29,
				Heli    = { x = 363.09, y = -1598.03, z = 36.95 },
				HHeading    = 142.75
			}
		},

		VehicleDeleters = {
			{ x = 388.68, y = -1622.07, z = 29.29 },
			{ x = 363.06, y = -1598.15, z = 36.95 }
		},

		BossActions = {
			{ x = 364.72, y = -1582.36, z = 33.36 }
		},

	},

	Vinewood = {

		Blip = {
			Pos     = { x = 603.65, y = 20.65, z = 90.65 },
			Sprite  = 60,
			Display = 4,
			Scale   = 0.9,
			Colour  = 3,
		},

		Cloakrooms = {
			{ x = 610.05, y = -2.24, z = 90.65 }
		},
		
		Stocks = {
			{ x = 631.84, y = -10.59, z = 182.58 }
		},


		Armories = {
			vector3(603.65, 20.65, 90.65),
		},

		Vehicles = {
			{
				Spawner    = { x = 617.0, y = 23.5, z = 88.85 },
				SpawnPoint = { x = 616.8, y = 33.35, z = 89.25 },
				Heading    = 249.18
			}
		},

		VehicleDeleters = {
			{ x = 616.8, y = 33.35, z = 89.25 }
		},

		BossActions = {
			{ x = 619.22, y = -28.49, z = 90.65 }
		},

	},

	Sandy = {

		Blip = {
			Pos     = { x = 1853.73, y = 3688.06, z = 34.76 },
			Sprite  = 60,
			Display = 4,
			Scale   = 0.9,
			Colour  = 5,
		},

		Cloakrooms = {
			{ x = 1845.98, y = 3693.48, z = 34.27 },
		},
		
		Stocks = {
			{ x = 631.84, y = -10.59, z = 182.58 }
		},


		Armories = {
			vector3(1861.88, 3690.06, 34.27),
		},

		Vehicles = {
			{
				Spawner    = { x = 1863.05, y = 3682.15, z = 33.78 },
				SpawnPoint = { x = 1873.24, y = 3692.72, z = 33.55 },
				Heading    = 214.58,
				Heli    = { x = 1851.03, y = 3636.35, z = 46.01 },
				HHeading    = 120.76
			}
		},

		VehicleDeleters = {
			{ x = 1865.18, y = 3702.51, z = 33.47 },
			{ x = 1851.03, y = 3636.35, z = 46.01 },
		},

		BossActions = {
			{ x = 1857.58, y = 3690.12, z = 38.07 }
		},

	}
}

PDConfig.Items = {
	label = "Police Gun Safe",
	slots = 30,
	items = {
		[1] = {
		  name = "weapon_pistol_mk2",
		  price = 500,
		  count = 1,
		  info = {
			  serie = "LSPD"..math.random(1000000, 10000000),
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
			  serie = "LSPD"..math.random(1000000, 10000000),
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
			serie = "LSPD"..math.random(1000000, 10000000),
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
			  serie = "LSPD"..math.random(1000000, 10000000),
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