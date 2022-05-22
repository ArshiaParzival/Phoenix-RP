--[[ Client-Side AntiCheat Config ]]--

--< Admin Cheat Menu >--
Config.CheatMenu = -- Menu e cheat baraye admin ha
{ 
	active = false, -- Fa'al ya gheyre fa'al kardan
	permission = 1, -- Permi ke niyaz dare bara fa'al shodan
	command = 'cmenu', -- Ba che commandi menu fa'al beshe?
	key = 'tab', -- Ba che dokmeyi menu fa'al beshe?
	-- Age az command mikhayd estefade konid key ro '' konid, age ham az key mikhayd estefade konid baraksesh
}

Config.AdminGodMode = { active = false } -- Anticheat admin haro godmode kone ya na?

--< Anti BlackListed Events Triggering (Client-Side) >--
-- NEW
Config.BlacklistedEvents = { active = true, ban = true, kick = true, log = true } -- Table Name => BlacklistedEvents

--< Local Ped Spawning >--
Config.PedSpawningProtection = { active = false }

--< Give Health Detection >-- 
Config.GiveHealth = { active = false, ban = false, kick = false, log = true } 

--< Give Armor Detection >-- 
Config.GiveArmor = { active = true, ban = false, kick = false, log = true } 

--< Health GodMode Detection >--
Config.HealthGodMode1 = { active = true, ban = false, kick = false, log = true } -- 100% GodMode
Config.HealthGodMode2 = { active = false, ban = true, kick = true, log = true } -- Heal > 200 (99% GodMode)
Config.HealthGodMode3 = { active = true, ban = false, kick = false, log = true } -- Tactical Detection (Can be false positive)
Config.HealthGodMode4 = { active = true, ban = false, kick = false, log = true } -- Proof Detection (Can be false positive)

--< Armor GodMode Detection >--
Config.ArmorGodMode1 = { active = true, ban = true, kick = true, log = true } -- Armor > 100
Config.ArmorGodMode2 = { active = true, ban = false, kick = false, log = true } -- Tactical Detection (Can be false positive)

--< Vehicle & Player Invisible Detection >--
Config.InvisiblePlayer = { active = true, ban = false, kick = false, log = true }
Config.InvisibleVehicle = { active = true, ban = false, kick = false, log = true }

--< Spectator Mode Detection >--
Config.SpectatorMode = { active = true, ban = false, kick = false, log = true }

--< Force GPS Detection >--
Config.ForceGPS = { active = true, ban = true, kick = true, log = true }

--< Thermal & Night Visions Detection >--
Config.ThermalVision = { active = true, ban = true, kick = true, log = true }
Config.NightVision = { active = true, ban = true, kick = true, log = true }

--< Weapons & Vehicles Damages Modifiers Detection >--
Config.WeaponDamageModifier = { active = true, ban = true, kick = true, log = true }
Config.WeaponDefenseModifier = { active = true, ban = true, kick = true, log = true }
Config.VehicleDamageModifier = { active = true, ban = true, kick = true, log = true }
Config.VehicleDefenseModifier = { active = true, ban = true, kick = true, log = true }
Config.MeleeDefenseModifier = { active = true, ban = true, kick = true, log = true }

--< Explosive Fist Detection >--
Config.ExplosiveFist = { active = true, ban = true, kick = true, log = true }

--< Explosive Weapon Detection >--
Config.ExplosiveWeapon = { active = true, ban = true, kick = true, log = true }

--< Teleport Hack Detection >--
Config.OnFootTP = { active = false, ban = false, kick = false, log = true }
Config.InVehicleTP = { active = false, ban = false, kick = false, log = true }

--< Noclip Detection >--
Config.OnFootNoclip = { active = false, ban = false, kick = false, log = true }
Config.InVehicleNoclip = { active = false, ban = false, kick = false, log = true }

--< Speed Hack Detection >--
Config.OnFoot_SpeedHack = { active = false, ban = false, kick = false, log = true }
Config.InVehicle_SpeedHack = { active = false, ban = false, kick = false, log = true }

--< Vehicle Color Changer Detection >--
Config.VehicleColorChanger = { active = false, ban = false, kick = false, log = true }

--< Vehicle Speed Changer Detection >--
Config.VehicleSpeedChanger = { active = false, ban = false, kick = false, log = true }

--< Skin Changer Detection >--
Config.SkinChanger = { active = true, ban = true, kick = true, log = true }

--< Blip Indicator Detection >--
Config.BlipIndicator = { active = false, ban = true, kick = true, log = true }

--< No Fall or No Ragdoll Detection >--
Config.NoFall = { active = false, ban = false, kick = false, log = true }

--< Infinite Stamina Detection >--
Config.InfiniteStamina = { active = false, ban = false, kick = false, log = true }

--< Anti Vehicle Gravity Changer >--
Config.VehicleGravityChanger = { active = true, ban = false, kick = false, log = true }

--< Onscreen Keyboard (Ham Mafia) Detection >--
Config.OnscreenKeyboard = { active = true, ban = false, kick = false, log = true }

--< Jobs Config >--
Config.MechanicJobName = 'mechanic' -- Name of your server mechanic job name (if you don't have mechanic job in your server don't edit this one!)
Config.MechanicJobPlaces =
{
	{ x = -211.38, y = -1325.19, z = 30.89 },
	{ x = -338.16, y = -136.73, z = 39.01 }
}

Config.ThermalVisionJobs = -- List of Thermal Vision Whitelisted Jobs
{
	'police',
	'sheriff',
	'fbi',
	'artesh',
	'dadgostari',
	'ambulance',
	'weazel'
}

Config.NightVisionJobs = -- List of Night Vision Whitelisted Jobs
{
	'police',
	'sheriff',
	'fbi',
	'artesh',
	'dadgostari',
	'ambulance',
	'weazel'
}

Config.BlipIndicatorJobs = -- List of Jobs that have GPS
{
	'police',
	'sheriff',
	'fbi',
	'artesh',
	'dadgostari',
	'mechanic',
	'ambulance',
	'taxi',
	'weazel'
}

Config.BlipIndicatorGangs = -- List of Gangs that have GPS
{
	'Mafia',
	'Cartel'
}

Config.WLVehicleClasses = -- List of Whitelisted Vehicle Classes
{
	-- [0] = "Compacts",
	-- [1] = "Sedans",
	-- [2] = "SUVs",
	-- [3] = "Coupes",
	-- [4] = "Muscle",
	-- [5] = "Sports Classics",
	-- [6] = "Sports",
	-- [7] = "Super",
	-- [8] = "Motorcycles",
	-- [9] = "Off-road",
	-- [10] = "Industrial",
	-- [11] = "Utility",
	-- [12] = "Vans",
	-- [13] = "Cycles",
	-- [14] = "Boats",
	-- [15] = "Helicopters",
	-- [16] = "Planes",
	-- [17] = "Service",
	-- [18] = "Emergency",
	-- [19] = "Military",
	-- [20] = "Commercial",
	-- [21] = "Trains",
}

--[[ WhiteListed Peds (Client-Side) ]]--
whitelistPeds =
{
	GetHashKey("player_zero"),
	GetHashKey("player_one"),
	GetHashKey("player_two"),
	GetHashKey("mp_f_freemode_01"),
	GetHashKey("mp_m_freemode_01"),
	GetHashKey("a_m_y_skater_01"),
	GetHashKey("a_m_y_skater_02")
}

--[[ BlackListed Events ]]--
BlacklistedEvents =
{	
	-- 'event1',
	-- 'event2',
	-- 'event3',
}