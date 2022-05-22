--[[ Server-Side AntiCheat Config ]]--
Config.DisableInvalidPackets = true

--< Players Max Ping >--
Config.MaxPing = 1500 -- Min: 500

--< Crash Player's Game when he/she gets banned or kicked >--
Config.CrashPlayer = { active = true, onBan = true, onKick = false }

--< NUI DevTools Detection >--
Config.NUI = { active = true, ban = true, kick = true, log = true }

--< Freeze Lobby & Players Detection >--
Config.FreezePlayers = { active = true, ban = false, kick = false, log = false }

--< Give Weapon To Player Detection >--
Config.GiveWeaponToPlayer = { active = true, ban = true, kick = true, log = true }

--< Remove Weapon From Player Detection >--
Config.RemoveWeaponFromPlayer = { active = true, ban = true, kick = true, log = true }

--< Explosion Detection >--
Config.ExplosionChecker = { active = true } -- Shoma mitunid baraye har Explosion ban, kick ya log ro too confige khodesh set konid!

--< Particle Spawning Detection >--
Config.ParticleSpawning = {active = true, ban = true, kick = true, log = true} -- NEW

--< Ped Spawning Detection >--
Config.PedChecker = { active = true } -- Dakhele table e BlacklistedPeds mitunid ban, kick ya log e har ped ro set konid!
Config.PedSpawning = { active = false, ban = false, kick = false, log = true }
Config.PedSpamming = { active = false, ban = false, kick = false, log = true }
Config.Delete_Peds_AfterDisconnect = { active = true } -- Pak kardane ped haye spawn shode tavassote player ba'd az inke az server disconnect shod

--< Object Spawning Detection >--
Config.ObjectChecker = { active = true, ban = false, kick = false, log = true }
Config.ObjectSpawning = { active = true, ban = false, kick = false, log = true }
Config.ObjectSpamming = { active = false, ban = false, kick = false, log = false }
Config.Delete_Objects_AfterDisconnect = { active = true } -- Pak kardane object haye spawn shode tavassote player ba'd az inke az server disconnect shod

--< Vehicle Spawning Detection >--
Config.VehicleChecker = { active = true } -- Dakhele table e BlacklistedModels mitunid ban, kick ya log e har ped ro set konid!
Config.VehicleSpawning = { active = true, ban = false, kick = false, log = true }
Config.VehicleSpamming = { active = true, ban = false, kick = false, log = true }
Config.VehicleRamming = { active = true, ban = false, kick = false, log = true } -- NEW
Config.VehicleDuplicating = { active = false, ban = false, kick = false, log = true } -- NEW
Config.Delete_Vehicles_AfterDisconnect = { active = true } -- Pak kardane mashin haye spawn shode tavassote player ba'd az inke az server disconnect shod

--< Flying Cars Detection >--
Config.FlyingCars = { active = true, ban = false, kick = false, log = true } -- NEW

--< Firing Toggle (Enable or Disable?) >--
Config.FireToggle = { disable = true } -- true = Firing is Disabled, false = Firing is Enabled

--< Anti Connect With Blacklisted Names >--
Config.BLNames = { active = false }

--< Weapons Damages Modifiers Detection >--
Config.SS_WeaponDamageModifier = { active = true, ban = true, kick = true, log = true } -- (Server-Side)

--< Anti Taze Configuration >--
Config.AntiTaze = { active = true }
Config.AntiTazeJobs = -- List of Jobs that have Tazer
{
	'police',
	'sheriff',
	'fbi',
	'artesh',
	'dadgostari',
	'ambulance'
}

--< Anti Resource Inection >--
Config.CommandsChecker = { active = false, ban = true, kick = true, log = true }
Config.ACFreeze = { active = true, ban = false, kick = true, log = true }
Config.MenuInjection = { active = true, ban = false, kick = false, log = true }
Config.ResourceStart = { active = true, ban = false, kick = false, log = true }
Config.ResourceStop = { active = true, ban = false, kick = false, log = true }

--< Anti Trigger >--
Config.AntiTrigger = { active = true, ban = true, kick = true, log = true } -- NEW

--< Anti BlackListed Events Triggering (Server-Side) >--
Config.BlacklistedEvents = { active = true, ban = true, kick = true, log = true } -- Table Name => BlacklistedEvents

--< Anti VPN/Proxy >--
Config.AntiVPN = { active = false } -- NEW
Config.AntiVPN.Whitelisted_Users = -- Working with any Identifier
{
	'steam:1100001489be185',
	'license:222222222222222',
	'discord:333333333333333',
}

-- Whitelisted Countries ( 2 letter ISO-3166-1 country code <-> https://en.wikipedia.org/wiki/ISO_3166-1 )
Config.AntiVPN.Whitelisted_Countries =
{
	-- 'IR',
}

-- Blacklisted Countries ( 2 letter ISO-3166-1 country code <-> https://en.wikipedia.org/wiki/ISO_3166-1 )
Config.AntiVPN.Blacklisted_Countries =
{
	-- 'US',
}

--< Hardware ID Ban >--
Config.HWIDBan = true -- Do you want Hardware ID Ban feature? :)

--< Server Ban Options >--
Config.SBCheckWithPlayerName = false -- Check with Player Name (We prefer turn it off!)
Config.SBCheckWithSteam = true -- Check with Steam Account
Config.SBCheckWithLicense = true -- Check with License
Config.SBCheckWithLiveID = true -- Check with Live ID
Config.SBCheckWithXBLID = true -- Check with XBL ID
Config.SBCheckWithDiscord = true -- Check with Discord Account
Config.SBCheckWithIP = true -- Check with Player IP Address

--< Global Ban Options >--
Config.GlobalBan = { active = true }
Config.GBCheckWithPlayerName = false -- Check with Player Name (We prefer turn it off!)
Config.GBCheckWithSteam = true -- Check with Steam Account
Config.GBCheckWithLicense = true -- Check with License
Config.GBCheckWithLiveID = true -- Check with Live ID
Config.GBCheckWithXBLID = true -- Check with XBL ID
Config.GBCheckWithDiscord = true -- Check with Discord Account
Config.GBCheckWithIP = true -- Check with Player IP Address
Config.GB_Whitelisted_Users = -- Inja mitunid Identifier haye kasayi ke Global Ban hastan va mikhayd too whitelist bashan ro gharar bedid!
{ -- NEW
	'steam:111111111111111',
	'license:222222222222222',
	'discord:333333333333333',	
}

--< Console Options >--
Console = {}
Console.ShowBans = true -- Show bans messages in console or not?
Console.ShowKicks = true -- Show kicks messages in console or not?
Console.ShowWarnings = false -- Show anticheat warnings in console or not?

--< AntiCheat Auto Update Toggle >--
Config.AutoUpdate = true

--< Admins Warning System Configuration >--
Config.ADutyKey = "aduty"
Config.ShortMessages = false -- Payam haye warn ha kootah tar beshe?
Config.SendWarnPerMS = 500 -- Az har player har chand mili saniye warn daryaft beshe? -- NEW
Config.NoPunishment_PermissionLevel = 1 -- Az in perm be bala anticheat mojazati barashun dar nazar nemigire! (Yani age oon cheat ban dashte bashe admin ban nemishe amma logesh ersal mishe!)
Config.Whitelisted_PermissionLevel = 12 -- Az in perm be bala dige anticheat azashun warni nemide!
Config.Whitelisted_Admins = -- Inja ham mitunid yek seri Identifier bedid ke az ina hich warni daryaft nashe!
{
	'steam:11000013a72945f',
	'license:222222222222222',
	'discord:333333333333333',
}

--< Commands Permissions >--
Config.Ban_Permission = 5 -- Perme morede niyaz baraye commande: /acban
Config.Unban_Permission = 9 -- Perme morede niyaz baraye commande: /acunban

-- [[ License Key ]] --
LicenseKey = "WSVnzKHWlyxk2qiRrZDH6FTMZpsylxZFt5bXrEulPf2yqZv5rn"
-- [[ License Key ]] --

-- [[ Discord WebHook ]] --
Config.DiscordLogging = true
DiscordWebhook = "https://discord.com/api/webhooks/896813174228148276/ubPaDTQhlKgU4uzuATYeDKf4x2z2JP8RLoDKvo69BbH1-_m-ckRzwFqABaTBGpNmPvbh"

-- [[ Admins Ignored Objects ]] --
Config.DeleteAdminsIgnoredModels = false -- Delete admins ignored models?!
AdminsIgnoredModels = -- NEW
{
	[1336576410] = true, -- Parachute
}

-- [[ Ignored Objects ]] --
Config.DeleteIgnoredModels = false -- Delete ignored models?!
IgnoredModels =
{
	-- [1026431720] = true, -- Carbine Rifle
	[1336576410] = true, -- Parachute
}

-- [[ BlackListed Vehicles ]] --
BlacklistedModels = 
{
	-- Jobs
    [GetHashKey("insurgent")] = {name = "Insurgent", ban = false, kick = false, log = true, job = "artesh"},
	[GetHashKey("annihilator")] = {name = "Annihilator", ban = false, kick = false, log = true, job = "artesh"},
	[GetHashKey("barracks")] = {name = "Barracks", ban = false, kick = false, log = true, job = "artesh"},
	[GetHashKey("crusader")] = {name = "Crusader", ban = false, kick = false, log = true, job = "artesh"},
	[GetHashKey("valkyrie2")] = {name = "Valkyrie2", ban = false, kick = false, log = true, job = "artesh"},
	-- [GetHashKey("insurgent2")] = {name = "Insurgent2", ban = false, kick = false, log = true, job = "police"},
	-- Others
    [GetHashKey("cargoplane")] = {name = "Cargo Plane", ban = false, kick = false, log = true},
    [GetHashKey("dump")] = {name = "Dump", ban = false, kick = false, log = true},
    [GetHashKey("avenger")] = {name = "Avenger", ban = false, kick = false, log = true},
    [GetHashKey("avenger2")] = {name = "Avenger2", ban = false, kick = false, log = true},
    [GetHashKey("khanjali")] = {name = "Khanjali", ban = false, kick = false, log = true},
    [GetHashKey("rhino")] = {name = "Rhino", ban = false, kick = false, log = true},
    [GetHashKey("oppressor")] = {name = "Oprresor", ban = false, kick = false, log = true},
    [GetHashKey("oppressor2")] = {name = "Oprresor2", ban = false, kick = false, log = true},
    [GetHashKey("maverick")] = {name = "Maverick", ban = false, kick = false, log = true},
    [GetHashKey("blimp2")] = {name = "blimp2", ban = false, kick = false, log = true},
    [GetHashKey("blimp")] = {name = "blimp", ban = false, kick = false, log = true},
    [GetHashKey("blimp3")] = {name = "blimp3", ban = false, kick = false, log = true},
    [GetHashKey("freight")] = {name = "Freight", ban = false, kick = false, log = true},
    [GetHashKey("freightcar")] = {name = "FreightCar", ban = false, kick = false, log = true},
    [GetHashKey("limo2")] = {name = "Limo2", ban = false, kick = false, log = true},
    [GetHashKey("freightcont1")] = {name = "FreightCont1", ban = false, kick = false, log = true},
    [GetHashKey("freightcont2")] = {name = "FreightCont2", ban = false, kick = false, log = true},
    [GetHashKey("freightgrain")] = {name = "FreightGrain", ban = false, kick = false, log = true},
    [GetHashKey("cerberus3")] = {name = "Cerberus3", ban = false, kick = false, log = true},
    [GetHashKey("cerberus2")] = {name = "Cerberus2", ban = false, kick = false, log = true},
    [GetHashKey("cerberus")] = {name = "Cerberus", ban = false, kick = false, log = true},
    [GetHashKey("buzzard")] = {name = "Buzzard", ban = false, kick = false, log = true},
    [GetHashKey("phantom2")] = {name = "Phantom2", ban = false, kick = false, log = true},
    [GetHashKey("issi6")] = {name = "Issi6", ban = false, kick = false, log = true},
    [GetHashKey("issi3")] = {name = "Issi3", ban = false, kick = false, log = true},
    [GetHashKey("issi4")] = {name = "Issi4", ban = false, kick = false, log = true},
    [GetHashKey("issi5")] = {name = "Issi5", ban = false, kick = false, log = true},
    [GetHashKey("savage")] = {name = "Savage", ban = false, kick = false, log = true},
    [GetHashKey("hunter")] = {name = "Hunter", ban = false, kick = false, log = true},
    [GetHashKey("akula")] = {name = "Akula", ban = false, kick = false, log = true},
    [GetHashKey("cutter")] = {name = "Cutter", ban = false, kick = false, log = true},
    [GetHashKey("bulldozer")] = {name = "Bulldozer", ban = false, kick = false, log = true},
    [GetHashKey("barracks2")] = {name = "Barracks2", ban = false, kick = false, log = true},
    [GetHashKey("barracks3")] = {name = "Barracks3", ban = false, kick = false, log = true},
    [GetHashKey("barrage")] = {name = "Barrage", ban = false, kick = false, log = true},
    [GetHashKey("chernobog")] = {name = "Chernobog", ban = false, kick = false, log = true},	
    [GetHashKey("halftrack")] = {name = "HalfTrack", ban = false, kick = false, log = true},
    [GetHashKey("minitank")] = {name = "MiniTank", ban = false, kick = false, log = true},
    [GetHashKey("scarab")] = {name = "Scarab", ban = false, kick = false, log = true},
    [GetHashKey("scarab2")] = {name = "Scarab2", ban = false, kick = false, log = true},
    [GetHashKey("scarab3")] = {name = "Scarab3", ban = false, kick = false, log = true},
    [GetHashKey("thruster")] = {name = "Thruster", ban = false, kick = false, log = true},
    [GetHashKey("trailersmall2")] = {name = "Trailersmall2", ban = false, kick = false, log = true},
    [GetHashKey("brutus3")] = {name = "Brutus3", ban = false, kick = false, log = true},
    -- [GetHashKey("freecrawler")] = {name = "Freecrawler", ban = false, kick = false, log = true},
    [GetHashKey("monster")] = {name = "Monster", ban = false, kick = false, log = true},
    [GetHashKey("technical")] = {name = "Technical", ban = false, kick = false, log = true},
    [GetHashKey("technical3")] = {name = "Technical3", ban = false, kick = false, log = true},
    [GetHashKey("technical2")] = {name = "Technical2", ban = false, kick = false, log = true},
    [GetHashKey("nightshark")] = {name = "Nightshark", ban = false, kick = false, log = true},
    [GetHashKey("zhaba")] = {name = "Zhaba", ban = false, kick = false, log = true},
    [GetHashKey("formula")] = {name = "Formula", ban = false, kick = false, log = true},
    [GetHashKey("formula2")] = {name = "Formula2", ban = false, kick = false, log = true},
    [GetHashKey("scramjet")] = {name = "Scramjet", ban = false, kick = false, log = true},
    [GetHashKey("zr3802")] = {name = "Zr3802", ban = false, kick = false, log = true},
    [GetHashKey("raptor")] = {name = "Raptor", ban = false, kick = false, log = true},
    [GetHashKey("volatol")] = {name = "Volatol", ban = false, kick = false, log = true},
    [GetHashKey("voltic2")] = {name = "Voltic2", ban = false, kick = false, log = true},
    [GetHashKey("tula")] = {name = "Tula", ban = false, kick = false, log = true},
    [GetHashKey("strikeforce")] = {name = "Strikeforce", ban = false, kick = false, log = true},
    [GetHashKey("jet")] = {name = "Jet", ban = false, kick = false, log = true},
    [GetHashKey("cargoplane")] = {name = "Cargoplane", ban = false, kick = false, log = true},
    [GetHashKey("bombushka")] = {name = "Bombushka", ban = false, kick = false, log = true},
    [GetHashKey("bruiser3")] = {name = "Bruiser3", ban = false, kick = false, log = true},
    [GetHashKey("bruiser2")] = {name = "Bruiser2", ban = false, kick = false, log = true},
    [GetHashKey("bruiser")] = {name = "Bruiser", ban = false, kick = false, log = true},
    [GetHashKey("caracara")] = {name = "Caracara", ban = false, kick = false, log = true},
    [GetHashKey("dune5")] = {name = "Dune5", ban = false, kick = false, log = true},
    [GetHashKey("dune4")] = {name = "Dune4", ban = false, kick = false, log = true},
    [GetHashKey("dune3")] = {name = "Dune3", ban = false, kick = false, log = true},
    [GetHashKey("dune2")] = {name = "Dune2", ban = false, kick = false, log = true},
   -- [GetHashKey("dune")] = {name = "Dune", ban = false, kick = false, log = true}
}

BlacklistedPeds = 
{
    --[[[GetHashKey("a_m_y_mexthug_01")] = {name = "MexThug", ban = true, kick = false, log = false},
	[GetHashKey("A_C_MtLion")] = {name = "Lion", ban = true, kick = false, log = false},
    [GetHashKey("a_c_husky")] = {name = "Huskey", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_boar")] = {name = "Boar", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_sharkhammer")] = {name = "Sharkhammer", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_chimp")] = {name = "Chimp", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_chop")] = {name = "Chop", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_hen")] = {name = "Hen", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_humpback")] = {name = "Humpback", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_killerwhale")] = {name = "Killerwhale", ban = true, kick = false, log = false},
    [GetHashKey("a_c_rhesus")] = {name = "Rhesus", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_rottweiler")] = {name = "Rottweiler", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_sharktiger")] = {name = "SharkTiger", ban = true, kick = false, log = false}, 
    [GetHashKey("a_c_shepherd")] = {name = "Shepherd", ban = true, kick = false, log = false}, 
    [GetHashKey("u_m_y_zombie_01")] = {name = "Zombie", ban = true, kick = false, log = false},
    [GetHashKey("a_m_m_acult_01")] = {name = "Acult01", ban = true, kick = false, log = false},
    [GetHashKey("u_m_y_juggernaut_01")] = {name = "Juggernaut", ban = true, kick = false, log = false},
	[GetHashKey("s_m_y_swat_01")] = {name = "Swat", ban = true, kick = false, log = false},
	[GetHashKey("ig_wade")] = {name = "IG Wade (Tiago RPG)", ban = true, kick = false, log = false},
	[GetHashKey("a_m_m_afriamer_01")] = {name = "Afriamer (Tiago AK Attack)", ban = true, kick = false, log = false},
	[GetHashKey("csb_stripper_02")] = {name = "Stripper (Tiago RPG Attack)", ban = true, kick = false, log = false},]]
}

WhitelistedPeds =
{
	-- [GetHashKey("PED_MODEL_NAME")] = "PED_LABEL",
	-- [4678654] = "PED_LABEL",

	[GetHashKey("a_c_cat_01")] = "Gorbe",
	[GetHashKey("a_c_chop")] = "Chop",
	[GetHashKey("a_c_coyote")] = "Coyote",
	[GetHashKey("a_c_husky")] = "Husky",
	[GetHashKey("a_c_poodle")] = "Poodle",
	[GetHashKey("a_c_pug")] = "Pug",
	[GetHashKey("a_c_retriever")] = "Retriever",
	[GetHashKey("a_c_rottweiler")] = "Rottweiler",
	[GetHashKey("a_c_shepherd")] = "Shepherd",
	[GetHashKey("a_c_westy")] = "Westy",
	[GetHashKey("a_c_mtlion")] = "Shir",
	[GetHashKey("a_c_chickenhawk")] = "Shahin",
	[GetHashKey("a_c_pigeon")] = "Kabotar",
	[GetHashKey("a_c_seagull")] = "Morgh Daryai",
	[GetHashKey("a_c_hen")] = "Morgh",
	[GetHashKey("a_c_chimp")] = "Meymon",
	[GetHashKey("a_c_deer")] = "Aho",
	[GetHashKey("a_c_pig")] = "Pig",
	[GetHashKey("ig_hunter")] = "Hunter",
	[GetHashKey("s_f_m_fembarber")] = "Barber",
	[GetHashKey("ig_orleans")] = "Pa Gonde",
	[GetHashKey("cs_orleans")] = "Pa Gonde (Zan)",
	[GetHashKey("a_c_rabbit_01")] = "Khargosh",
	[GetHashKey("a_c_rat")] = "Mosh",
	-- [GetHashKey("u_m_y_zombie_01")] = "Zombie",
	-- [GetHashKey("u_m_y_juggernaut_01")] = "Juggernaut Bot",
}

BlacklistedNames = 
{
	{ word = '"', reason = 'Shoma dar esme khod nemitavanid az " estefade konid'},
	{ word = "'", reason = "Shoma dar esme khod nemitavanid az ' estefade konid"},
	{ word = "\\", reason = "Shoma dar esme khod nemitavanid az : estefade konid"},
	{ word = "*", reason = "Shoma dar esme khod nemitavanid az * estefade konid"},
	{ word = ";", reason = "Shoma dar esme khod nemitavanid az ; estefade konid"},
	{ word = ":", reason = "Shoma dar esme khod nemitavanid az : estefade konid"},
	{ word = "?", reason = "Shoma dar esme khod nemitavanid az ? estefade konid"},
	{ word = "<", reason = "Shoma dar esme khod nemitavanid az < estefade konid"},
	{ word = ">", reason = "Shoma dar esme khod nemitavanid az > estefade konid"},
	{ word = "~", reason = "Shoma dar esme khod nemitavanid az ~ estefade konid"},
}

WhitelistedEntities =
{
	-- artesh Objects
	[-1233399904] = {name = 'Cop Shield'},
	[519908417] = {name = 'Cop Box', jobs = {'artesh', 'sheriff'}},
	[GetHashKey("prop_mp_cone_01")] = {name = 'prop_mp_cone_01', jobs = {'police', 'sheriff', 'artesh', 'fbi', 'dadgostari'}},
	[GetHashKey("prop_mp_barrier_02b")] = {name = 'prop_mp_barrier_02b', jobs = {'police', 'sheriff', 'artesh', 'fbi', 'dadgostari'}},
	[GetHashKey("prop_barrier_work05")] = {name = 'prop_barrier_work05', jobs = {'police', 'sheriff', 'artesh', 'fbi', 'dadgostari'}},
	[GetHashKey("prop_mp_arrow_barrier_01")] = {name = 'prop_mp_arrow_barrier_01', jobs = {'police', 'sheriff', 'artesh', 'fbi', 'dadgostari'}},
	[GetHashKey("p_ld_stinger_s")] = {name = 'p_ld_stinger_s', jobs = {'police', 'sheriff', 'artesh', 'fbi', 'dadgostari'}},
	[GetHashKey("hei_prop_cash_crate_half_full")] = {name = 'hei_prop_cash_crate_half_full', jobs = {'police', 'sheriff', 'artesh', 'fbi', 'dadgostari'}},
	-- Mechanic Objects
	[GetHashKey("prop_roadcone02a")] = {name = 'prop_roadcone02a', jobs = {'mechanic', 'police', 'sheriff', 'artesh', 'fbi', 'dadgostari'}},
	[GetHashKey("prop_toolchest_01")] = {name = 'prop_toolchest_01', jobs = {'mechanic'}},
	[GetHashKey("prop_ld_jerrycan_01")] = {name = 'prop_ld_jerrycan_01'},
	[GetHashKey("w_me_bat")] = {name = 'w_me_bat'},
	[GetHashKey("prop_golf_iron_01")] = {name = 'prop_golf_iron_01'},
	[GetHashKey("prop_beach_fire")] = {name = 'prop_beach_fire'},
	[GetHashKey("prop_cash_case_02")] = {name = 'prop_cash_case_02'},
	[-875075437] = {name = 'Milk Obj'},
	[-1266741560] = {name = 'Milk Obj'},
	[358843520] = {name = 'Milk Obj'},
	[286149026] = {name = 'Milk Obj'},
	[-2122380018] = {name = 'Milk Obj'},
	[-180879779] = {name = 'Milk Obj'},
	[1545859325] = {name = 'Milk Obj'},
	[-859493159] = {name = 'Milk Obj'},
	[-2068855676] = {name = 'Milk Obj'},
	[1629176509] = {name = 'Milk Obj'},
	[1465528123] = {name = 'Milk Obj'},
	[1463746489] = {name = 'Milk Obj'},
	[-1218018752] = {name = 'Milk Obj'},
	[-1814932629] = {name = 'Milk Obj'},
	[-1928194470] = {name = 'Milk Obj'},
	[16180688] = {name = 'Milk Obj'},
	[125438837] = {name = 'Milk Obj'},
	[-1690030145] = {name = 'Milk Obj'},
	[-297480469] = {name = 'Milk Obj'},
	[1136664310] = {name = 'Milk Obj'},
	[-845035989] = {name = 'Milk Obj'},
	[-1987898602] = {name = 'Milk Obj'},
	[2116540373] = {name = 'Milk Obj'},
	[-370114164] = {name = 'Milk Obj'},
	[-1787068858] = {name = 'Milk Obj'},
	[-1430839454] = {name = 'Milk Obj'},
	[1136664310] = {name = 'Milk Obj'},
	[1411212000] = {name = 'Milk Obj'},
	[974707040] = {name = 'Milk Obj'},
	[-13720938] = {name = 'Milk Obj'},
	[1958725070] = {name = 'Milk Obj'},
	[260873931] = {name = 'Milk Obj'},
	[-437148257] = {name = 'Milk Obj'},
	[335898267] = {name = 'Milk Obj'},
	[-113902346] = {name = 'Comserv Prop'},
	[1959553115] = {name = 'Unknown'},
	[GetHashKey("w_lr_firework")] = {name = 'w_lr_firework'},
	[GetHashKey("w_sr_sniperrifle")] = {name = 'w_sr_sniperrifle'},
	[GetHashKey("w_ar_carbinerifle")] = {name = 'w_ar_carbinerifle'},
	[GetHashKey("w_ar_assaultrifle")] = {name = 'w_ar_assaultrifle'},
	[GetHashKey("w_ar_specialcarbine")] = {name = 'w_ar_specialcarbine'},
	[GetHashKey("w_ar_bullpuprifle")] = {name = 'w_ar_bullpuprifle'},
	[GetHashKey("w_ar_advancedrifle")] = {name = 'w_ar_advancedrifle'},
	[GetHashKey("w_sg_assaultshotgun")] = {name = 'w_sg_assaultshotgun'},
	[GetHashKey("w_sg_bullpupshotgun")] = {name = 'w_sg_bullpupshotgun'},
	[GetHashKey("w_sg_pumpshotgun")] = {name = 'w_sg_pumpshotgun'},
	[GetHashKey("w_ar_musket")] = {name = 'w_ar_musket'},
	[GetHashKey("w_sb_microsmg")] = {name = 'w_sb_microsmg'},
	[GetHashKey("w_sb_assaultsmg")] = {name = 'w_sb_assaultsmg'},
	[GetHashKey("w_sb_smg")] = {name = 'w_sb_smg'},
	[GetHashKey("w_sb_gusenberg")] = {name = 'w_sb_gusenberg'},
	[GetHashKey("w_sb_combatpdw")] = {name = 'w_sb_combatpdw'},
	[GetHashKey("v_med_bed2")] = {name = 'v_med_bed2'},
	[GetHashKey("prop_amb_phone")] = {name = 'prop_amb_phone'},
	[GetHashKey("prop_cs_cardbox_01")] = {name = 'prop_cs_cardbox_01'},
	[GetHashKey("prop_cs_burger_01")] = {name = 'prop_cs_burger_01'},
	[GetHashKey("ba_prop_battle_glowstick_01")] = {name = 'ba_prop_battle_glowstick_01'},
	[GetHashKey("ba_prop_battle_hobby_horse")] = {name = 'ba_prop_battle_hobby_horse'},
	[GetHashKey("p_amb_brolly_01")] = {name = 'p_amb_brolly_01'},
	[GetHashKey("prop_notepad_01")] = {name = 'prop_notepad_01'},
	[GetHashKey("hei_prop_heist_box")] = {name = 'hei_prop_heist_box'},
	[GetHashKey("prop_single_rose")] = {name = 'prop_single_rose'},
	[GetHashKey("prop_cs_ciggy_01")] = {name = 'prop_cs_ciggy_01'},
	[GetHashKey("hei_heist_sh_bong_01")] = {name = 'hei_heist_sh_bong_01'},
	[GetHashKey("prop_ld_suitcase_01")] = {name = 'prop_ld_suitcase_01'},
	[GetHashKey("prop_security_case_01")] = {name = 'prop_security_case_01'},
	[GetHashKey("prop_police_id_board")] = {name = 'prop_police_id_board'},
	[GetHashKey("p_amb_coffeecup_01")] = {name = 'p_amb_coffeecup_01'},
	[GetHashKey("prop_drink_whisky")] = {name = 'prop_drink_whisky'},
	[GetHashKey("prop_amb_beer_bottle")] = {name = 'prop_amb_beer_bottle'},
	[GetHashKey("prop_plastic_cup_02")] = {name = 'prop_plastic_cup_02'},
	[GetHashKey("prop_amb_donut")] = {name = 'prop_amb_donut'},
	[GetHashKey("prop_sandwich_01")] = {name = 'prop_sandwich_01'},
	[GetHashKey("prop_ecola_can")] = {name = 'prop_ecola_can'},
	[GetHashKey("prop_choc_ego")] = {name = 'prop_choc_ego'},
	[GetHashKey("prop_drink_redwine")] = {name = 'prop_drink_redwine'},
	[GetHashKey("prop_champ_flute")] = {name = 'prop_champ_flute'},
	[GetHashKey("prop_drink_champ")] = {name = 'prop_drink_champ'},
	[GetHashKey("prop_cigar_02")] = {name = 'prop_cigar_02'},
	[GetHashKey("prop_cigar_01")] = {name = 'prop_cigar_01'},
	[GetHashKey("prop_acc_guitar_01")] = {name = 'prop_acc_guitar_01'},
	[GetHashKey("prop_el_guitar_01")] = {name = 'prop_el_guitar_01'},
	[GetHashKey("prop_el_guitar_03")] = {name = 'prop_el_guitar_03'},
	[GetHashKey("prop_novel_01")] = {name = 'prop_novel_01'},
	[GetHashKey("prop_snow_flower_02")] = {name = 'prop_snow_flower_02'},
	[GetHashKey("v_ilev_mr_rasberryclean")] = {name = 'v_ilev_mr_rasberryclean'},
	[GetHashKey("p_michael_backpack_s")] = {name = 'p_michael_backpack_s'},
	[GetHashKey("p_amb_clipboard_01")] = {name = 'p_amb_clipboard_01'},
	[GetHashKey("prop_beggers_sign_03")] = {name = 'prop_beggers_sign_03'},
	[GetHashKey("prop_anim_cash_pile_01")] = {name = 'prop_anim_cash_pile_01'},
	[GetHashKey("prop_pap_camera_01")] = {name = 'prop_pap_camera_01'},
	[GetHashKey("ba_prop_battle_champ_open")] = {name = 'ba_prop_battle_champ_open'},
	[GetHashKey("p_cs_joint_02")] = {name = 'p_cs_joint_02'},
	[GetHashKey("prop_amb_ciggy_01")] = {name = 'prop_amb_ciggy_01'},
	[GetHashKey("prop_ld_case_01")] = {name = 'prop_ld_case_01'},
	[GetHashKey("prop_cs_tablet")] = {name = 'prop_cs_tablet'},
	[GetHashKey("prop_npc_phone_02")] = {name = 'prop_npc_phone_02'},
	[GetHashKey("prop_sponge_01")] = {name = 'prop_sponge_01'},
	[GetHashKey("prop_boombox_01")] = {name = 'prop_boombox_01'},
	[1760825203] = {name = 'no name'},
	[1070220657] = {name = 'cuff'},
	[1336576410] = {name = 'no name'},
	[GetHashKey("prop_byard_ladder01")] = {name = 'prop_byard_ladder01'},
	[GetHashKey("w_ex_flashbang")] = {name = 'w_ex_flashbang'},
	[GetHashKey("prop_cs_hand_radio")] = {name = 'prop_cs_hand_radio'},
	[GetHashKey("prop_ld_flow_bottle")] = {name = 'prop_ld_flow_bottle'},
	[GetHashKey("prop_food_bs_burger2")] = {name = 'prop_food_bs_burger2'},
	[GetHashKey("prop_ld_snack_01")] = {name = 'prop_ld_snack_01'},
	[GetHashKey("prop_tourist_map_01")] = {name = 'prop_tourist_map_01'},
	[GetHashKey("prop_pencil_01")] = {name = 'prop_pencil_01'},
	[GetHashKey("ng_proc_sodacan_01b")] = {name = 'ng_proc_sodacan_01b'},
	[GetHashKey("w_pi_sns_pistol")] = {name = 'w_pi_sns_pistol'},
	[GetHashKey("w_pi_combatpistol")] = {name = 'w_pi_combatpistol'},
	[GetHashKey("w_pi_pistol50")] = {name = 'w_pi_pistol50'},
	[GetHashKey("w_pi_pistol")] = {name = 'w_pi_pistol'},
	[GetHashKey("w_pi_heavypistol")] = {name = 'w_pi_heavypistol'},
	[GetHashKey("w_sb_pdw")] = {name = 'w_sb_pdw'},
	[GetHashKey("w_me_bat")] = {name = 'w_me_bat'},
	[GetHashKey("w_me_crowbar")] = {name = 'w_me_crowbar'},
	[GetHashKey("w_me_gclub")] = {name = 'w_me_gclub'},
	[GetHashKey("w_me_hammer")] = {name = 'w_me_hammer'},
	[GetHashKey("w_me_nightstick")] = {name = 'w_me_nightstick'},
	[GetHashKey("w_me_knife_01")] = {name = 'w_me_knife_01'},
	[GetHashKey("v_ret_ml_chips2")] = {name = 'v_ret_ml_chips2'},
	[GetHashKey("prop_pizza_box_02")] = {name = 'prop_pizza_box_02'},
	[GetHashKey("v_ret_247_bread1")] = {name = 'v_ret_247_bread1'},
	[GetHashKey("ng_proc_sodacan_01a")] = {name = 'ng_proc_sodacan_01a'},
	[GetHashKey("p_cs_lighter_01")] = {name = 'p_cs_lighter_01'},
	[GetHashKey("prop_player_phone_01")] = {name = 'prop_player_phone_01'},
	[GetHashKey("ng_proc_cigar01a")] = {name = 'ng_proc_cigar01a'},
	[GetHashKey("w_sb_smg_boxmag")] = {name = 'w_sb_smg_boxmag'},
	[GetHashKey("w_sb_smg_luxe_mag2")] = {name = 'w_sb_smg_luxe_mag2'},
	[GetHashKey("prop_v_cam_01")] = {name = 'prop_v_cam_01'},
	[GetHashKey("p_ing_microphonel_01")] = {name = 'p_ing_microphonel_01'},
	[GetHashKey("prop_v_bmike_01")] = {name = 'prop_v_bmike_01'},
	[GetHashKey("prop_bodyarmour_03")] = {name = 'prop_bodyarmour_03'},
	[GetHashKey("prop_cs_shot_glass")] = {name = 'prop_cs_shot_glass'},
	[1444640441] = {name = 'Unknown'},
	[1355733718] = {name = 'Unknown'},
	[-1018528175] = {name = 'Unknown'},
	[175786512] = {name = 'Unknown'},
	[439871883] = {name = 'Unknown'},
	[-1718229952] = {name = 'Unknown'},
	[-2120293549] = {name = 'Unknown'},
	[1776497632] = {name = 'Unknown'},
	[2074531687] = {name = 'Unknown'},
	[GetHashKey("prop_cctv_pole_01a")] = {name = 'police_radar'},
	[-415509317] = {name = 'Unknown'},
	[2035667964] = {name = 'Unknown'},
	[-415509317] = {name = 'Unknown'},
	[-746954904] = {name = 'Phone'},
	[GetHashKey("prop_beer_amopen")] = {name = 'Abjo'},
}

--[[ BlackListed Events ]]--
BlacklistedEvents = 
{
	"8321hiue89js",
	"adminmenu:allowall",
	"AdminMenu:giveBank",
	"AdminMenu:giveCash",
	"AdminMenu:giveDirtyMoney",
	"Tem2LPs5Para5dCyjuHm87y2catFkMpV",
	"dqd36JWLRC72k8FDttZ5adUKwvwq9n9m",
	"antilynx8:anticheat",
	"antilynxr4:detect",
	"antilynxr6:detection",
	"ynx8:anticheat",
	"antilynx8r4a:anticheat",
	"lynx8:anticheat",
	"AntiLynxR4:kick",
	"AntiLynxR4:log",
	"Banca:deposit",
	"Banca:withdraw",
	"BsCuff:Cuff696999",
	"CheckHandcuff",
	"cuffServer",
	"cuffGranted",
	":adminmenuenable",
	":askAwake",
	":checkup",
	":cleanareaentity",
	":cleanareapeds",
	":cleanareaveh",
	":enable",
	":invalid",
	":log",
	":openmenu",
	":spectate",
	":ViolationDetected",
	"dmv:success",
	"eden_garage:payhealth",
	"ems:revive",
	"esx_mechanicjob:onNPCJobCompleted",
	"BsCuff:Cuff696999",
	"veh_SR:CheckMoneyForVeh",
	"esx_carthief:alertcops",
	"mellotrainer:adminTempBan",
	"mellotrainer:adminKick",
    'esx_ambulancejob:syncDeadBody',
    'esx_ambulancejob:finishCPR',
    'esx_policejob:message',
    'db:updateUser',
    'esx_communityservice:sendToCommunityService',
    'esx_communityservice:endCommunityServiceCommand',
    'esx_communityservice:finishCommunityService',
    'esx-qalle-jail:changeJailStatusServerSided',
    'esx-qalle-jail:openJailMenu',
    'esx-qalle-jail:jailPlayer',
    'esx-qalle-jail:unJailPlayer',
    'esx-qalle-jail:jobSet',
    'esx-qalle-jail:updateJailTime',
    'esx-qalle-jail:prisonWorkReward',
    'HR_Comserv:OnlineJail',
    'cmg3_animations:syncTarget',
    'cmg3_animations:sync',
    'HR_Comserv:OfflineJail',
    'redst0nia:checking',
    'esx_artesh_job:handcuff',
    'esx_fbi_job:handovericuff',
    'hentailover:xdlol',
    'db:updateUseramirss',
    'bank:deposit',
    'bank:withdraw',
    'bank:transfer',
    'esx_policejob:soundplay',
    'antilynx8:anticheat',
    'antilynxr6:detection',
    'antilynx8r4a:anticheat',
    'antilynxr4:detect',
    'lynx8:anticheat',
    'adminmenu:allowall',
    'db:updateamirUsersiah',
    'esx_ambulancejob:setDeathStatus',
    'esx_ambulancejob:reviveoveramir',
    'h:xd',
    'esx_worek:naloz',
    'esx_worek:debugger',
    'esx_worek:zdejmijc',
    'gangprop:handcuffamirleviboro',
    'db:updateamirsiaUser',
    'db:updateamirUsersiahss',
    'irs:adminalarm',
    'gangprop:handcuffamirlevibboro',
    'HCheat:TempDisableDetection',
    'capture:CaptureEnded',
    'FAC:EzExec',
    'esx_ambulancejob:revive',
    'laundry:washcash',
    'sellDrugs',
    'CarryPeople:sync',
    'CarryPeople:stop',
    'esx_kekke_tackle:tryTackle',
    'esx_kekke_tackle:getTackled',
    'esx_kekke_tackle:playTackle',
    'gangprop:handcuff',
    'gangprop:drag',
    'gangprop:handcuffxx',
    'esx_slotmachine:sv:2',
    'mellotrainer:adminTempBan',
    'mellotrainer:adminKick',
    'esx-qalle-hunting:reward',
    'esx-qalle-hunting:sell',
    'moneytransfer:success',
    'AdminMenu:giveBank',
    'AdminMenu:giveCash',
    'esx_blanchisseur:startWhitening',
    'esx_blanchisseur:washMoney',
    'esx_vehicleshop:setVehicleOwned',
    'esx_vehicleshop:setVehicleOwnedSociety',
    'esx_vehicleshop:setVehicleOwnedPlayerId',
    'NB:recruterplayer',
    'MF_MobileMeth:RewardPlayers',
    'js:jailuser',
    'lscustoms:payGarage',
    'esx_mechanicjob:startHarvest',
    'esx_mechanicjob:startHarvest2',
    'esx_mechanicjob:startHarvest3',
    'esx_mechanicjob:startCraft',
    'esx_mechanicjob:startCraft2',
    'esx_mechanicjob:startCraft3',
    'esx:showNotification',
    'InteractSound_CL:PlayOnAlljland',
	--'esx_vangelico_robbery:gioielli',
	--'lester:vendita',
	'ServerValidEmote',
	'bankrobberies:receiveCash',
}