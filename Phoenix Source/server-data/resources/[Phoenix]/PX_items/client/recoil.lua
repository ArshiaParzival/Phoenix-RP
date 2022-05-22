ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local PlayerData = {}
local Wh = true
local WhiteList = {
	"police",
    "dadgostari"
}

AddEventHandler('capture:inCapture', function(bool)
	inCapture = bool
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    PlayerData = ESX.GetPlayerData()
	for k, v in pairs(WhiteList) do
		if v == PlayerData.job.name then
			Wh = false
			break 
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
	for k, v in pairs(WhiteList) do
		if v == PlayerData.job.name then
			Wh = false
			break
		end
	end
end)

local nWeapons = {

	["WEAPON_STUNGUN"] = 0.01,

	["WEAPON_FLAREGUN"] = 0.01,

	["WEAPON_SNSPISTOL"] = 0.02,

	["WEAPON_SNSPISTOL_MK2"] = 0.025,

	["WEAPON_PISTOL"] = 0.025,

	["WEAPON_PISTOL_MK2"] =  0.03,

	["WEAPON_APPISTOL"] = 0.05,

	["WEAPON_COMBATPISTOL"] = 0.03,

	["WEAPON_PISTOL50"] = 0.05,

	["WEAPON_HEAVYPISTOL"] = 0.03,

	["WEAPON_VINTAGEPISTOL"] = 0.025,

	["WEAPON_MARKSMANPISTOL"] = 0.03,

	["WEAPON_REVOLVER"] = 0.045,

	["WEAPON_REVOLVER_MK2"] = 0.055,

	["WEAPON_DOUBLEACTION"] = 0.025,

	["WEAPON_MICROSMG"] = 0.035,

	["WEAPON_COMBATPDW"] = 0.045,

	["WEAPON_SMG"] = 0.045,

	["WEAPON_SMG_MK2"] = 0.055,

	["WEAPON_ASSAULTSMG"] = 0.050,

	["WEAPON_MACHINEPISTOL"] = 0.035,

	["WEAPON_MINISMG"] = 0.035,

	["WEAPON_MG"] = 0.07,

	["WEAPON_COMBATMG"] = 0.08,

	["WEAPON_COMBATMG_MK2"] = 0.085,

	["WEAPON_ASSAULTRIFLE"] = 0.07,

	["WEAPON_ASSAULTRIFLE_MK2"] = 0.075,

	["WEAPON_CARBINERIFLE"] = 0.06,

	["WEAPON_CARBINERIFLE_MK2"] = 0.065,

	["WEAPON_ADVANCEDRIFLE"] = 0.06,

	["WEAPON_GUSENBERG"] = 0.05,

	["WEAPON_SPECIALCARBINE"] = 0.06,

	["WEAPON_SPECIALCARBINE_MK2"] = 0.075,

	["WEAPON_BULLPUPRIFLE"] = 0.05,

	["WEAPON_BULLPUPRIFLE_MK2"] = 0.065,

	["WEAPON_COMPACTRIFLE"] = 0.05,

	["WEAPON_PUMPSHOTGUN"] = 0.07,

	["WEAPON_PUMPSHOTGUN_MK2"] = 0.085,

	["WEAPON_SAWNOFFSHOTGUN"] = 0.06,

	["WEAPON_ASSAULTSHOTGUN"] = 0.12,

	["WEAPON_BULLPUPSHOTGUN"] = 0.08,

	["WEAPON_DBSHOTGUN"] = 0.05,

	["WEAPON_AUTOSHOTGUN"] = 0.08,

	["WEAPON_MUSKET"] = 0.04,

	["WEAPON_HEAVYSHOTGUN"] = 0.13,

	["WEAPON_SNIPERRIFLE"] = 0.2,

	["WEAPON_HEAVYSNIPER"] = 0.3,

	["WEAPON_HEAVYSNIPER_MK2"] = 0.35,

	["WEAPON_MARKSMANRIFLE_MK2"] = 0.1,

	["WEAPON_GRENADELAUNCHER"] = 0.08,

	["WEAPON_RPG"] = 0.9,

	["WEAPON_HOMINGLAUNCHER"] = 0.9,

	["WEAPON_MINIGUN"] = 0.20,

	["WEAPON_RAILGUN"] = 1.0,

	["WEAPON_COMPACTLAUNCHER"] = 0.08,

	["WEAPON_FIREWORK"] = 0.5

}



local recoils = {

	[453432689] = 0.3, -- PISTOL

	[3219281620] = 0.3, -- PISTOL MK2

	[1593441988] = 0.2, -- COMBAT PISTOL

	[584646201] = 0.1, -- AP PISTOL

	[2578377531] = 0.6, -- PISTOL .50

	[324215364] = 0.2, -- MICRO SMG

	[736523883] = 0.1, -- SMG

	[2024373456] = 0.1, -- SMG MK2

	[4024951519] = 0.1, -- ASSAULT SMG

	[3220176749] = 0.2, -- ASSAULT RIFLE

	[961495388] = 0.2, -- ASSAULT RIFLE MK2

	[2210333304] = 0.1, -- CARBINE RIFLE

	[4208062921] = 0.1, -- CARBINE RIFLE MK2

	[2937143193] = 0.1, -- ADVANCED RIFLE

	[2634544996] = 0.1, -- MG

	[2144741730] = 0.1, -- COMBAT MG

	[3686625920] = 0.1, -- COMBAT MG MK2

	[487013001] = 0.4, -- PUMP SHOTGUN

	[1432025498] = 0.4, -- PUMP SHOTGUN MK2

	[2017895192] = 0.7, -- SAWNOFF SHOTGUN

	[3800352039] = 0.4, -- ASSAULT SHOTGUN

	[2640438543] = 0.2, -- BULLPUP SHOTGUN

	[911657153] = 0.1, -- STUN GUN

	[100416529] = 0.5, -- SNIPER RIFLE

	[205991906] = 0.7, -- HEAVY SNIPER

	[177293209] = 0.7, -- HEAVY SNIPER MK2

	[856002082] = 1.2, -- REMOTE SNIPER

	[2726580491] = 1.0, -- GRENADE LAUNCHER

	[1305664598] = 1.0, -- GRENADE LAUNCHER SMOKE

	[2982836145] = 0.0, -- RPG

	[1752584910] = 0.0, -- STINGER

	[1119849093] = 0.01, -- MINIGUN

	[3218215474] = 0.2, -- SNS PISTOL

	[2009644972] = 0.25, -- SNS PISTOL MK2

	[1627465347] = 0.1, -- GUSENBERG

	[3231910285] = 0.2, -- SPECIAL CARBINE

	[-1768145561] = 0.25, -- SPECIAL CARBINE MK2

	[3523564046] = 0.5, -- HEAVY PISTOL

	[2132975508] = 0.2, -- BULLPUP RIFLE

	[-2066285827] = 0.25, -- BULLPUP RIFLE MK2

	[137902532] = 0.4, -- VINTAGE PISTOL

	[-1746263880] = 0.4, -- DOUBLE ACTION REVOLVER

	[2828843422] = 0.7, -- MUSKET

	[984333226] = 0.2, -- HEAVY SHOTGUN

	[3342088282] = 0.3, -- MARKSMAN RIFLE

	[1785463520] = 0.35, -- MARKSMAN RIFLE MK2

	[1672152130] = 0, -- HOMING LAUNCHER

	[1198879012] = 0.9, -- FLARE GUN

	[171789620] = 0.2, -- COMBAT PDW

	[3696079510] = 0.9, -- MARKSMAN PISTOL

  	[1834241177] = 2.4, -- RAILGUN

	[3675956304] = 0.3, -- MACHINE PISTOL

	[3249783761] = 0.6, -- REVOLVER

	[-879347409] = 0.65, -- REVOLVER MK2

	[4019527611] = 0.7, -- DOUBLE BARREL SHOTGUN

	[1649403952] = 0.3, -- COMPACT RIFLE

	[317205821] = 0.2, -- AUTO SHOTGUN

	[125959754] = 0.5, -- COMPACT LAUNCHER

	[3173288789] = 0.1, -- MINI SMG		

}



local hWeapon = {}



for k,v in pairs(nWeapons) do

	local hash = GetHashKey(k)

	local recoil = v

	hWeapon[hash] = recoil

end



function ManageReticle()

    local ped = GetPlayerPed( -1 )

    local _, hash = GetCurrentPedWeapon( ped, true )

    if not recoils[hash] then 

        ShowHudComponentThisFrame( 0 )

	end 

end

Citizen.CreateThread(function()

	tv = 0

	while true do

		Citizen.Wait(0)

		local ped = GetPlayerPed( -1 )

		local weapon = GetSelectedPedWeapon(ped)

		

		if weapon ~= -1569615261 then

			ManageReticle()

			

			if IsPedArmed(ped, 6) then

				DisableControlAction(1, 140, true)

				DisableControlAction(1, 141, true)

				DisableControlAction(1, 142, true)

			end

			

			DisplayAmmoThisFrame(true)

			
			if not useLSD and not inCapture then
				if Wh then
					if hWeapon[weapon] then	

						if IsPedShooting(ped) then

							if ReduceRecoil then

								ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', (hWeapon[weapon]/3)*2)

							else

								ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', hWeapon[weapon])

							end

						end

					end
				end
			end
			if recoils[weapon] and recoils[weapon] ~= 0 then

				if IsPedShooting(ped) then

					local hold = ReduceRecoil and ((recoils[weapon]*2)/3) or recoils[weapon]

					if not (tv >= hold) then

						p = GetGameplayCamRelativePitch()

						if GetFollowPedCamViewMode() ~= 4 then

							SetGameplayCamRelativePitch(p+0.1, 0.2)

						end

						tv = tv+0.1

					end

				else

					tv = 0

				end

			end

			if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") then		

				if IsPedShooting(ped) then

					SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))

				end

			end



			if weapon == GetHashKey("WEAPON_MINIGUN") then		

				if IsPedShooting(ped) then

					SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_MINIGUN"))

				end

			end

		end
	end
end)


local timeUseLSD = 0
RegisterNetEvent('weaponry:client:use:lsd')
AddEventHandler('weaponry:client:use:lsd', function()
    timeUseLSD = timeUseLSD + 1
    if timeUseLSD < 2 then
        useLSD = true
        SetTimeout(30 * 1000 * 60, function()
            useLSD = false
            ESX.ShowNotification("Masraf LSD Shoma Az Beyn Raft, Lotfan 15min Baraye Masraf Dobare Sabr Konid!", 'info')
        end)
        SetTimeout(45 * 1000 * 60, function()
            timeUseLSD = 0
            ESX.ShowNotification("Shoma Dobare Mitavanid LSD Use Konid!!", 'info')
        end)
    elseif timeUseLSD >= 2 then
        SetEntityHealth(PlayerPedId(), 0)
        timeUseLSD = 0
        ESX.ShowNotification("Shoma OverDose Kardid!", 'info')
    end
end)

local timeUseAdrenalin = 0
RegisterNetEvent('weaponry:client:use:adrenalin')
AddEventHandler('weaponry:client:use:adrenalin', function()
    timeUseAdrenalin = timeUseAdrenalin + 1
    local hp = GetEntityHealth(PlayerPedId()) + 20
    SetEntityHealth(PlayerPedId(), hp)
    if timeUseAdrenalin < 2 then
        SetTimeout(10 * 1000 * 60, function()
            timeUseAdrenalin = 0
            ESX.ShowNotification("Shoma Dobare Mitavanid Adrenalin Use Konid!!", 'info')
        end)
    elseif timeUseAdrenalin >= 2 then
        SetEntityHealth(PlayerPedId(), 0)
        timeUseAdrenalin = 0
        ESX.ShowNotification("Shoma OverDose Kardid!", 'info')
    end
end)

RegisterNetEvent('weaponry:client:use:sianoor')
AddEventHandler('weaponry:client:use:sianoor', function()
	SetEntityHealth(PlayerPedId(), 0)
	Wait(10000)
	TriggerEvent("esx_ambulancejob:parchesefid")
end)