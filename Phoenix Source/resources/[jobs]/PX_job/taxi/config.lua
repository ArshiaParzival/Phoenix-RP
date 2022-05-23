TaxiConfig                            = {}

TaxiConfig.DrawDistance               = 7.0

TaxiConfig.MaxInService               = -1
TaxiConfig.EnablePlayerManagement     = true
TaxiConfig.EnableSocietyOwnedVehicles = true

TaxiConfig.Locale                     = 'en'

TaxiConfig.Zones = {

	VehicleSpawner = {
		Pos   = {x = 915.039, y = -162.187, z = 74.8},
		Size  = {x = 0.5, y = 0.5, z = 0.3},
		Color = {r = 255, g = 255, b = 255},
		Type  = 20, Rotate = true
	},

	VehicleSpawnPoint = {
		Pos     = {x = 911.108, y = -177.867, z = 74.283},
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Type    = -1, Rotate = false,
		Heading = 225.0
	},

	VehicleDeleter = {
		Pos   = {x = 908.317, y = -183.070, z = 73.201},
		Size  = {x = 3.0, y = 3.0, z = 0.25},
		Color = {r = 255, g = 0, b = 0},
		Type  = 1, Rotate = false
	},

	TaxiActions = {
		Pos   = {x = 905.01, y = -159.13, z = 78.16},
		Size  = {x = 0.5, y = 0.5, z = 0.3},
		Color = {r = 255, g = 255, b = 255},
		Type  = 20, Rotate = true
	}
}