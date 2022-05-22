AmbulanceConfig                            = {}

AmbulanceConfig.DrawDistance               = 7.0

AmbulanceConfig.Marker                     = { type = 20, x = 0.5, y = 0.5, z = 0.3, r = 255, g = 255, b = 255, a = 100, rotate = false }

AmbulanceConfig.ReviveReward               = 19999  -- revive reward, set to 0 if you don't want it enabled
AmbulanceConfig.AntiCombatLog              = true -- enable anti-combat logging?
AmbulanceConfig.LoadIpl                    = false -- disable if you're using fivem-ipl or other IPL loaders

AmbulanceConfig.Locale                     = 'en'

local second = 1000
local minute = 60 * second

AmbulanceConfig.EarlyRespawnTimer          = 15 * minute  -- Time til respawn is available
AmbulanceConfig.BleedoutTimer              = 5 * minute -- Time til the player bleeds out

AmbulanceConfig.EnablePlayerManagement     = true

AmbulanceConfig.RemoveWeaponsAfterRPDeath  = true
AmbulanceConfig.RemoveCashAfterRPDeath     = true
AmbulanceConfig.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
AmbulanceConfig.EarlyRespawnFine           = true
AmbulanceConfig.EarlyRespawnFineAmount     = 5000

AmbulanceConfig.RespawnPoint = { coords = vector3(342.5, -1397.76, 33.51), heading = 47.48 }

AmbulanceConfig.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(342.5, -1397.76, 33.51),
			sprite = 305,
			scale  = 0.9,
			color  = 1
			
		},

		AmbulanceActions = {
			vector3(349.82, -1446.65, 32.51)
		},

		Pharmacies = {
			vector3(360.17, -1425.53, 32.51)  
		},

		Vehicles = {
			{
				Spawner = vector3(317.7, -1376.91, 31.93),
				InsideShop = vector3(317.7, -1376.91, 31.93),
				Marker = { type = 36, x = 0.7, y = 0.7, z = 0.7, r = 0, g = 250, b = 0, a = 500, rotate = true },
				SpawnPoints = {
					{ coords = vector3(310.77, -1374.78, 31.85), heading = 318.25, radius = 4.0, heli = vector3(299.56, -1453.28, 46.51) }
				}
			}

		},

		VehiclesDeleter = {
			{
				Marker = { type = 24, x = 0.7, y = 0.7, z = 0.7, r = 255, g = 0, b = 0, a = 500, rotate = true },
				Deleter = vector3(311.71, -1373.92, 31.44)
			},
			{
				Marker = { type = 24, x = 0.7, y = 0.7, z = 0.7, r = 255, g = 0, b = 0, a = 500, rotate = true },
				Deleter = vector3(299.56, -1453.28, 46.51)
			}
		},

		FastTravels = {

		},

		FastTravelsPrompt = {

		}

	},
	SandyShores = {

		Blip = {
			coords = vector3(1826.9, 3666.62, 34.28),
			sprite = 305,
			scale  = 1.0,
			color  = 1
		},

		AmbulanceActions = {
			vector3(1832.86, 3689.51, 33.27)
		},

		Pharmacies = {
			vector3(1821.36, 3668.44, 33.27)
		},

		BossAction = {
			vector3(1821.36, 3668.44, -34.27)
		},

		Vehicles = {
			{
				Spawner = vector3(1835.81, 3671.12, 34.28),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(408.85, -637.42, 28.69), heading = 88.26, radius = 4.0, heli = vector3(1850.98, 3636.18, 46.01) }
				}
			}
		},

		VehiclesDeleter = {
			{
				Marker = { type = 24, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(408.85, -637.42, 28.69)
			},
			{
				Marker = { type = 24, x = 3.5, y = 3.5, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				Deleter = vector3(411.9, -642.37, 42.37)
			}
		},

		FastTravels = {
		},

		FastTravelsPrompt = {
		}

	}
}

AmbulanceConfig.Items = {
	label = "Hospital Shop",
	slots = 30,
	items = {
		[1] = {
		  name = "medikit",
		  price = 250,
		  count = 50,
		  info = {},
		  type = "item",
		  slot = 1,
		},
		[2] = {
		  name = "bandage",
		  price = 75,
		  count = 50,
		  info = {},
		  type = "item",
		  slot = 2,
		},
		[3] = {
		  name = "radio",
		  price = 0,
		  count = 50,
		  info = {},
		  type = "item",
		  slot = 3,
		},
	 }
  }