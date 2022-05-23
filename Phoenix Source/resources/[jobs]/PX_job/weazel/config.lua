WeazelConfig = {}

WeazelConfig.DrawDistance 			  = 20.0
WeazelConfig.MarkerType    			  = 20
WeazelConfig.MarkerSize   			  = { x = 0.5, y = 0.5, z = 0.3 }
WeazelConfig.MarkerColor                = { r = 255, g = 255, b = 255 }
WeazelConfig.MarkerDeletersColor        = { r = 255, g = 0, b = 0 }

WeazelConfig.EnablePlayerManagement     = true
WeazelConfig.EnableArmoryManagement     = true
WeazelConfig.EnableESXIdentity          = false -- enable if you're using esx_identity
WeazelConfig.EnableSocietyOwnedVehicles = false
WeazelConfig.EnableLicenses             = false -- enable if you're using esx_license

WeazelConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
WeazelConfig.HandcuffTimer              = 10 * 60000 -- 10 mins

WeazelConfig.EnableJobBlip              = true -- enable blips for colleagues, requires esx_society
WeazelConfig.EnablePoliceFine           = true -- enable fine, requires esx_policejob

WeazelConfig.MaxInService               = -1
WeazelConfig.Locale = 'en'

WeazelConfig.weazelStations = {

	weazel = {

		Blip = {
			Pos     = { x = -602.15, y = -930.8, z = 23.86 },
			Sprite  = 564,
			Display = 4,
			Scale   = 0.9,
			Colour  = 37,
		},

		Vehicles = {
			{
				Spawner    = { x = -548.9, y = -888.97, z = 25.14 },
	            SpawnPoints = {
					{ x = -545.34, y = -903.16, z = 23.9, heading = 161.17, radius = 6.0 }
		        }
			},
		},

		VehicleDeleters = {
			{ x = -532.65, y = -893.08, z = 24.20 },
			{ x = -583.5, y = -930.17, z = 37.0 }
	    },

		BossActions = {
			{ x = -575.06, y = -938.63, z = 28.82 }
	    },

		Elevator = {
	 	{
				Top = { x = -555.24, y = -196.52, z = 47.41 },
				Down = { x = -550.2, y = -182.2, z = 38.22 },
				Parking = { x = -596.41, y = -179.56, z = 37.87 }
        }

		},

    },
}