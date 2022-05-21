--[[ Shared AntiCheat Config ]]--
Config = {}
Config.DebugMode = false
Config.DebugPrint = false

--< OneSync Infinity >--
Config.OneSync_Infinity = true

--< ESX Shared Event Name >--
Config.ESX = "esx:getSharedObject"

--< Super Jump Detection >--
Config.SuperJump = { active = true, ban = false, kick = false, log = true }

--< Give Weapon Detection >--
Config.GiveWeapon = { active = true, ban = false, kick = false, log = true }
Config.GiveBlacklistedWeapon = { active = true, ban = false, kick = false, log = true }

--< Give Ammo or Clip Detection >--
Config.GiveAmmo = { active = false, ban = false, kick = false, log = true }

--< High Distance Shooting Detection >--
-- NEW
Config.HighDistanceShooting = { active = true, ban = false, kick = false, log = true } -- Tashkhise Tir andazi az rahe door

--[[ BlackListed Weapons ]]--
BlacklistedWeapons =
{
    --[GetHashKey("WEAPON_DAGGER")] = "WEAPON_DAGGER",
    [GetHashKey("WEAPON_PROXMINE")] = "WEAPON_PROXMINE",
    [GetHashKey("WEAPON_RAYMINIGUN")] = "WEAPON_RAYMINIGUN",
    [GetHashKey("WEAPON_COMPACTLAUNCHER")] = "WEAPON_COMPACTLAUNCHER",
    [GetHashKey("WEAPON_HOMINGLAUNCHER")] = "WEAPON_HOMINGLAUNCHER",
    [GetHashKey("WEAPON_RAILGUN")] = "WEAPON_RAILGUN",
    [GetHashKey("WEAPON_FIREWORK")] = "WEAPON_FIREWORK",
    [GetHashKey("WEAPON_MINIGUN")] = "WEAPON_MINIGUN",
    [GetHashKey("WEAPON_GRENADELAUNCHER_SMOKE")] = "WEAPON_GRENADELAUNCHER_SMOKE",
    [GetHashKey("WEAPON_GRENADELAUNCHER")] = "WEAPON_GRENADELAUNCHER",
    [GetHashKey("WEAPON_RPG")] = "WEAPON_RPG",
    [GetHashKey("WEAPON_MARKSMANRIFLE_MK2")] = "WEAPON_MARKSMANRIFLE_MK2",
    [GetHashKey("WEAPON_MARKSMANRIFLE")] = "WEAPON_MARKSMANRIFLE",
    [GetHashKey("WEAPON_HEAVYSNIPER_MK2")] = "WEAPON_HEAVYSNIPER_MK2",
    --[GetHashKey("WEAPON_SNIPERRIFLE")] = "WEAPON_SNIPERRIFLE",
    [GetHashKey("WEAPON_COMBATMG_MK2")] = "WEAPON_COMBATMG_MK2",
    [GetHashKey("WEAPON_COMBATMG")] = "WEAPON_COMBATMG",
    [GetHashKey("WEAPON_MG")] = "WEAPON_MG",
    [GetHashKey("WEAPON_COMPACTRIFLE")] = "WEAPON_COMPACTRIFLE",
    --[GetHashKey("WEAPON_BULLPUPRIFLE_MK2")] = "WEAPON_BULLPUPRIFLE_MK2",
    --[GetHashKey("WEAPON_BULLPUPRIFLE")] = "WEAPON_BULLPUPRIFLE",
    --[GetHashKey("WEAPON_SPECIALCARBINE_MK2")] = "WEAPON_SPECIALCARBINE_MK2",
    --[GetHashKey("WEAPON_SPECIALCARBINE")] = "WEAPON_SPECIALCARBINE",
    --[GetHashKey("WEAPON_CARBINERIFLE_MK2")] = "WEAPON_CARBINERIFLE_MK2",
    --[GetHashKey("WEAPON_ASSAULTRIFLE_MK2")] = "WEAPON_ASSAULTRIFLE_MK2",
    [GetHashKey("WEAPON_AUTOSHOTGUN")] = "WEAPON_AUTOSHOTGUN",
    [GetHashKey("WEAPON_DBSHOTGUN")] = "WEAPON_DBSHOTGUN",
    [GetHashKey("WEAPON_HEAVYSHOTGUN")] = "WEAPON_HEAVYSHOTGUN",
    --[GetHashKey("WEAPON_MUSKET")] = "WEAPON_MUSKET",
    --[GetHashKey("WEAPON_BULLPUPSHOTGUN")] = "WEAPON_BULLPUPSHOTGUN",
    --[GetHashKey("WEAPON_ASSAULTSHOTGUN")] = "WEAPON_ASSAULTSHOTGUN",
    --[GetHashKey("WEAPON_SAWNOFFSHOTGUN")] = "WEAPON_SAWNOFFSHOTGUN",
    [GetHashKey("WEAPON_PUMPSHOTGUN_MK2")] = "WEAPON_PUMPSHOTGUN_MK2",
    [GetHashKey("WEAPON_RAYCARBINE")] = "WEAPON_RAYCARBINE",
    --[GetHashKey("WEAPON_MINISMG")] = "WEAPON_MINISMG",
    [GetHashKey("WEAPON_MACHINEPISTOL")] = "WEAPON_MACHINEPISTOL",
    --[GetHashKey("WEAPON_SMG_MK2")] = "WEAPON_SMG_MK2",
    [GetHashKey("WEAPON_NAVYREVOLVER")] = "WEAPON_NAVYREVOLVER",
    [GetHashKey("WEAPON_CERAMICPISTOL")] = "WEAPON_CERAMICPISTOL",
    --[GetHashKey("WEAPON_PISTOL_MK2")] = "WEAPON_PISTOL_MK2",
    -- [GetHashKey("WEAPON_SNSPISTOL_MK2")] = "WEAPON_SNSPISTOL_MK2",
    [GetHashKey("WEAPON_RAYPISTOL")] = "WEAPON_RAYPISTOL",
    [GetHashKey("WEAPON_DOUBLEACTION")] = "WEAPON_DOUBLEACTION",
    [GetHashKey("WEAPON_REVOLVER_MK2")] = "WEAPON_REVOLVER_MK2",
    --[GetHashKey("WEAPON_REVOLVER")] = "WEAPON_REVOLVER",
    [GetHashKey("WEAPON_MARKSMANPISTOL")] = "WEAPON_MARKSMANPISTOL",
    [GetHashKey("WEAPON_FLAREGUN")] = "WEAPON_FLAREGUN",
    --[GetHashKey("WEAPON_VINTAGEPISTOL")] = "WEAPON_VINTAGEPISTOL",
    --[GetHashKey("WEAPON_APPISTOL")] = "WEAPON_APPISTOL",
    [GetHashKey("WEAPON_BOTTLE")] = "WEAPON_BOTTLE",
    [GetHashKey("WEAPON_GOLFCLUB")] = "WEAPON_GOLFCLUB",
    [GetHashKey("WEAPON_POOLCUE")] = "WEAPON_POOLCUE",
    --[GetHashKey("WEAPON_SMOKEGRENADE")] = "WEAPON_SMOKEGRENADE",
    --[GetHashKey("WEAPON_FLARE")] = "WEAPON_FLARE",
}

-- [[ Weapons Default Damages ]] --
weaponDamages = 
{
	[-1357824103] =
	{
		damage = 34,
		name = "AdvancedRifle"
	},
	[453432689] =
	{
		damage = 26,
		name = "Pistol"
	},
	[1593441988] =
	{
		damage = 27,
		name = "CombatPistol"
	},
	[584646201] =
	{
		damage = 25,
		name = "APPistol"
	},
	[-1716589765] =
	{
		damage = 51,
		name = "Pistol50"
	},
	[-1045183535] =
	{
		damage = 160,
		name = "Revolver"
	},
	[-1076751822] =
	{
		damage = 28,
		name = "SNSPistol"
	},
	[-771403250] =
	{
		damage = 40,
		name = "HeavyPistol"
	},
	[137902532] =
	{
		damage = 34,
		name = "VintagePistol"
	},
	[324215364] =
	{
		damage = 21,
		name = "MicroSMG"
	},
	[736523883] =
	{
		damage = 22,
		name = "SMG"
	},
	[-270015777] =
	{
		damage = 24,
		name = "AssaultSMG"
	},
	[-1121678507] =
	{
		damage = 22,
		name = "MiniSMG"
	},
	[-619010992] =
	{
		damage = 27,
		name = "MachinePistol"
	},
	[171789620] =
	{
		damage = 28.0,
		name = "CombatPDW"
	},
	[487013001] =
	{
		damage = 58,
		name = "PumpShotgun"
	},
	[2017895192] =
	{
		damage = 40,
		name = "SawnoffShotgun"
	},
	[-494615257] =
	{
		damage = 32,
		name = "AssaultShotgun"
	},
	[-1654528753] =
	{
		damage = 14,
		name = "BullpupShotgun"
	},
	[984333226] =
	{
		damage = 117,
		name = "HeavyShotgun"
	},
	[-1074790547] =
	{
		damage = 30,
		name = "AssaultRifle"
	},
	[-2084633992] =
	{
		damage = 32,
		name = "CarbineRifle"
	},
	[-1063057011] =
	{
		damage = 35,
		name = "SpecialCarbine"
	},
	[2132975508] =
	{
		damage = 32,
		name = "BullpupRifle"
	},
	[1649403952] =
	{
		damage = 34,
		name = "CompactRifle"
	},
	[-1660422300] =
	{
		damage = 40,
		name = "MG"
	},
	[2144741730] =
	{
		damage = 45,
		name = "CombatMG"
	},
	[1627465347] =
	{
		damage = 35.7,
		name = "Gusenberg"
	},
	[100416529] =
	{
		damage = 101,
		name = "SniperRifle"
	},
	[205991906] =
	{
		damage = 216,
		name = "HeavySniper"
	},
	[-952879014] =
	{
		damage = 65,
		name = "MarksmanRifle"
	},
	[1119849093] =
	{
		damage = 30,
		name = "Minigun"
	},
	[-1466123874] =
	{
		damage = 165,
		name = "Musket"
	},
	[911657153] =
	{
		damage = 1 ,
		name = "StunGun"
	},
	[1198879012] =
	{
		damage = 10 ,
		name = "FlareGun"
	},
	[-598887786] =
	{
		damage = 220,
		name = "MarksmanPistol"
	},
	[1834241177] =
	{
		damage = 30,
		name = "Railgun"
	},
	[-275439685] =
	{
		damage = 30,
		name = "DoubleBarrelShotgun"
	},
	[-1746263880] =
	{
		damage = 81,
		name = "Double Action Revolver"
	},
	[-2009644972] =
	{
		damage = 30,
		name = "SNS Pistol Mk II"
	},
	[-879347409] =
	{
		damage = 200 ,
		name = "Heavy Revolver Mk II"
	},
	[-1768145561] =
	{
		damage = 32,
		name = "Special Carbine Mk II"
	},
	[-2066285827] =
	{
		damage = 37,
		name = "Bullpup Rifle Mk II"
	},
	[1432025498] =
	{
		damage = 32,
		name = "Pump Shotgun Mk II"
	},
	[1785463520] =
	{
		damage = 75,
		name = "Marksman Rifle Mk II"
	},
	[961495388] =
	{
		damage = 40,
		name = "Assault Rifle Mk II"
	},
	[-86904375] =
	{
		damage = 37,
		name = "Carbine Rifle Mk II"
	},
	[-608341376] =
	{
		damage = 47,
		name = "Combat MG Mk II"
	},
	[177293209] =
	{
		damage = 230,
		name = "Heavy Sniper Mk II"
	},
	[-1075685676] =
	{
		damage = 32,
		name = "Pistol Mk II"
	},
	[2024373456] =
	{
		damage = 25,
		name = "SMG Mk II"
	}
}

BlacklistedEntities =
{
	[GetHashKey("prop_med_jet_01")] = 'prop_med_jet_01',
    [GetHashKey("prop_fnclink_05crnr1")] = 'prop_fnclink_05crnr1',
    [GetHashKey("xs_prop_hamburgher_wl")] = 'xs_prop_hamburgher_wl',
    [GetHashKey("xs_prop_plastic_bottle_wl")] = 'xs_prop_plastic_bottle_wl',
    [GetHashKey("prop_windmill_01")] = 'prop_windmill_01',
    [GetHashKey("p_spinning_anus_s")] = 'p_spinning_anus_s',
    [GetHashKey("stt_prop_ramp_adj_flip_m")] = 'stt_prop_ramp_adj_flip_m',
    [GetHashKey("stt_prop_ramp_adj_flip_mb")] = 'stt_prop_ramp_adj_flip_mb',
    [GetHashKey("stt_prop_ramp_adj_flip_s")] = 'stt_prop_ramp_adj_flip_s',
    [GetHashKey("stt_prop_ramp_adj_flip_sb")] = 'stt_prop_ramp_adj_flip_sb',
    [GetHashKey("stt_prop_ramp_adj_hloop")] = 'stt_prop_ramp_adj_hloop',
    [GetHashKey("stt_prop_ramp_adj_loop")] = 'stt_prop_ramp_adj_loop"',
    [GetHashKey("stt_prop_ramp_jump_l")] = 'stt_prop_ramp_jump_l"',
    [GetHashKey("stt_prop_ramp_jump_m")] = 'stt_prop_ramp_jump_m',
    [GetHashKey("stt_prop_ramp_jump_s")] = 'stt_prop_ramp_jump_s',
    [GetHashKey("stt_prop_ramp_jump_xl")] = 'stt_prop_ramp_jump_xl',
    [GetHashKey("stt_prop_ramp_jump_xs")] = 'stt_prop_ramp_jump_xs',
    [GetHashKey("stt_prop_ramp_jump_xxl")] = 'stt_prop_ramp_jump_xxl',
    [GetHashKey("stt_prop_ramp_multi_loop_rb")] = 'stt_prop_ramp_multi_loop_rb',
    [GetHashKey("stt_prop_ramp_spiral_l")] = 'stt_prop_ramp_spiral_l',
    [GetHashKey("stt_prop_ramp_spiral_l_l")] = 'stt_prop_ramp_spiral_l_l',
    [GetHashKey("stt_prop_ramp_spiral_l_m")] = 'stt_prop_ramp_spiral_l_m',
    [GetHashKey("stt_prop_ramp_spiral_l_s")] = 'stt_prop_ramp_spiral_l_s',
    [GetHashKey("stt_prop_ramp_spiral_l_xxl")] = 'stt_prop_ramp_spiral_l_xxl',
    [GetHashKey("stt_prop_ramp_spiral_m")] = 'stt_prop_ramp_spiral_m',
    [GetHashKey("stt_prop_ramp_spiral_s")] = 'stt_prop_ramp_spiral_s',
    [GetHashKey("stt_prop_ramp_spiral_xxl")] = 'stt_prop_ramp_spiral_xxl"',
    [GetHashKey("stt_prop_stunt_track_dwuturn")] = 'stt_prop_stunt_track_dwuturn',
    [GetHashKey("stt_prop_stunt_track_dwslope30")] = 'stt_prop_stunt_track_dwslope30',
    [GetHashKey("stt_prop_stunt_track_dwslope30")] = 'stt_prop_stunt_track_dwslope30',
    [GetHashKey("prop_beach_fire")] = 'prop_beach_fire',
}

BlacklistedAttachments =
{
    [GetHashKey("prop_mp_cone_01")] = {name = 'prop_mp_cone_01'},
	[GetHashKey("prop_mp_barrier_02b")] = {name = 'prop_mp_barrier_02b'},
	[GetHashKey("prop_barrier_work05")] = {name = 'prop_barrier_work05'},
	[GetHashKey("prop_mp_arrow_barrier_01")] = {name = 'prop_mp_arrow_barrier_01'},
	[GetHashKey("p_ld_stinger_s")] = {name = 'p_ld_stinger_s'},
	[GetHashKey("hei_prop_cash_crate_half_full")] = {name = 'hei_prop_cash_crate_half_full'},
	[GetHashKey("prop_roadcone02a")] = {name = 'prop_roadcone02a'},
	[GetHashKey("prop_toolchest_01")] = {name = 'prop_toolchest_01'},
	[GetHashKey("prop_ld_jerrycan_01")] = {name = 'prop_ld_jerrycan_01'},
	[GetHashKey("prop_golf_iron_01")] = {name = 'prop_golf_iron_01'},
	[GetHashKey("w_lr_firework")] = {name = 'w_lr_firework'},
	[GetHashKey("w_ar_musket")] = {name = 'w_ar_musket'},
	[GetHashKey("v_med_bed2")] = {name = 'v_med_bed2'},
	[GetHashKey("prop_cs_cardbox_01")] = {name = 'prop_cs_cardbox_01'},
	[GetHashKey("prop_cs_burger_01")] = {name = 'prop_cs_burger_01'},
	[GetHashKey("ba_prop_battle_glowstick_01")] = {name = 'ba_prop_battle_glowstick_01'},
	[GetHashKey("ba_prop_battle_hobby_horse")] = {name = 'ba_prop_battle_hobby_horse'},
	[GetHashKey("p_amb_brolly_01")] = {name = 'p_amb_brolly_01'},
	[GetHashKey("prop_boombox_01")] = {name = 'prop_boombox_01'},
	[GetHashKey("prop_byard_ladder01")] = {name = 'prop_byard_ladder01'},
	[GetHashKey("prop_ld_flow_bottle")] = {name = 'prop_ld_flow_bottle'},
	[GetHashKey("prop_food_bs_burger2")] = {name = 'prop_food_bs_burger2'},
	[GetHashKey("prop_ld_snack_01")] = {name = 'prop_ld_snack_01'},
	[GetHashKey("prop_tourist_map_01")] = {name = 'prop_tourist_map_01'},
	[GetHashKey("ng_proc_sodacan_01b")] = {name = 'ng_proc_sodacan_01b'},
	[GetHashKey("w_me_crowbar")] = {name = 'w_me_crowbar'},
	[GetHashKey("w_me_gclub")] = {name = 'w_me_gclub'},
	[GetHashKey("w_me_hammer")] = {name = 'w_me_hammer'},
	[GetHashKey("v_ret_ml_chips2")] = {name = 'v_ret_ml_chips2'},
	[GetHashKey("prop_pizza_box_02")] = {name = 'prop_pizza_box_02'},
	[GetHashKey("v_ret_247_bread1")] = {name = 'v_ret_247_bread1'},
	[GetHashKey("ng_proc_sodacan_01a")] = {name = 'ng_proc_sodacan_01a'},
	[GetHashKey("p_cs_lighter_01")] = {name = 'p_cs_lighter_01'},
	[GetHashKey("prop_player_phone_01")] = {name = 'prop_player_phone_01'},
	[GetHashKey("ng_proc_cigar01a")] = {name = 'ng_proc_cigar01a'},
	[GetHashKey("w_sb_smg_luxe_mag2")] = {name = 'w_sb_smg_luxe_mag2'},
	[GetHashKey("prop_bodyarmour_03")] = {name = 'prop_bodyarmour_03'},
	[GetHashKey("prop_cs_shot_glass")] = {name = 'prop_cs_shot_glass'},
	[1760825203] = {name = '1760825203'},
	[1336576410] = {name = '1336576410'},	
	[1070220657] = {name = 'Bracelet'},	
}