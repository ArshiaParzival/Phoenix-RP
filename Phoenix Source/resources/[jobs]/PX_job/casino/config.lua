CasinoConfig                            = {}
CasinoConfig.DrawDistance               = 100.0
CasinoConfig.EnablePlayerManagement     = true
CasinoConfig.EnableSocietyOwnedVehicles = false
CasinoConfig.EnableVaultManagement      = true
CasinoConfig.EnableHelicopters          = true
CasinoConfig.EnableMoneyWash            = true
CasinoConfig.MaxInService               = -1
CasinoConfig.Locale                     = 'en'
CasinoConfig.MissCraft                  = 10 -- %

CasinoConfig.Blips = {
    
    Blip = {
      Pos     = { x = 923.72, y = 47.12, z = 81.11 },
      Sprite  = 617,
      Display = 4,
      Scale   = 0.8,
      Colour  = 27,
    },

}

CasinoConfig.Zones = {

    BossActions = {
        Pos   = { x = 1112.77, y = 241.65, z = -46.83 },
        Size  = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 0, g = 100, b = 0 },
        Type  = 1,
    },
	
	Vaults = {
        Pos   = { x = 1108.7, y = 249.7, z = -46.84 },
        Size  = { x = 1.3, y = 1.3, z = 0.5 },
        Color = { r = 30, g = 144, b = 255 },
        Type  = 1,
    },

}

-----------------------
----- TELEPORTERS -----

CasinoConfig.TeleportZones = {

  EnterHeliport = {
    Pos       = { x = 927.34, y = 53.07, z = 80.1 },
    Size      = { x = 2.0, y = 2.0, z = 0.5 },
    Color     = { r = 204, g = 204, b = 0 },
    Marker    = 1,
    Hint      = _U('e_to_enter_2'),
    Teleport  = { x = 970.99, y = 59.26, z = 120.24 },
  },

  ExitHeliport = {
    Pos       = { x = 970.99, y = 59.26, z = 119.24 },
    Size      = { x = 2.0, y = 2.0, z = 0.5 },
    Color     = { r = 204, g = 204, b = 0 },
    Marker    = 1,
    Hint      = _U('e_to_exit_2'),
    Teleport  = { x = 927.34, y = 53.07, z = 80.1 },
  },
}