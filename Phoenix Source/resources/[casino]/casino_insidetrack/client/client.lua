local ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(amount)
  end
end)

local cooldown = 60
local tick = 0
local checkRaceStatus = false
local insideTrackActive = false
local gameOpen = false
local insideTrackLocation = vector3(1099.46, 257.71, -51.24)

local function OpenInsideTrack()
    ESX.TriggerServerCallback("insidetrack:server:getbalance", function(balance)
        Utils.PlayerBalance = balance
    end)

    if insideTrackActive then
        return
    end

    insideTrackActive = true

    -- Scaleform
    Utils.Scaleform = RequestScaleformMovie('HORSE_RACING_CONSOLE')

    while not HasScaleformMovieLoaded(Utils.Scaleform) do
        Wait(0)
    end

    DisplayHud(false)
    SetPlayerControl(PlayerId(), false, 0)

    while not RequestScriptAudioBank('DLC_VINEWOOD/CASINO_GENERAL') do
        Wait(0)
    end

    Utils:ShowMainScreen()
    Utils:SetMainScreenCooldown(cooldown)

    -- Add horses
    Utils:AddHorses()

    Utils:DrawInsideTrack()
    Utils:HandleControls()
end

local function LeaveInsideTrack()
    insideTrackActive = false

    DisplayHud(true)
    --ExecuteCommand("togglehud")
    SetPlayerControl(PlayerId(), true, 0)
    SetScaleformMovieAsNoLongerNeeded(Utils.Scaleform)

    Utils.Scaleform = -1
end

function Utils:DrawInsideTrack()
    Citizen.CreateThread(function()
        while insideTrackActive do
            Wait(0)

            local xMouse, yMouse = GetDisabledControlNormal(2, 239), GetDisabledControlNormal(2, 240)

            -- Fake cooldown
            tick = (tick + 10)

            if (tick == 1000) then
                if (cooldown == 1) then
                    cooldown = 60
                end
                
                cooldown = (cooldown - 1)
                tick = 0

                Utils:SetMainScreenCooldown(cooldown)
            end
            
            -- Mouse control
            BeginScaleformMovieMethod(Utils.Scaleform, 'SET_MOUSE_INPUT')
            ScaleformMovieMethodAddParamFloat(xMouse)
            ScaleformMovieMethodAddParamFloat(yMouse)
            EndScaleformMovieMethod()

            -- Draw
            DrawScaleformMovieFullscreen(Utils.Scaleform, 255, 255, 255, 255)
        end
    end)
end

function Utils:HandleControls()
    Citizen.CreateThread(function()
        while insideTrackActive do
            Wait(0)

            if IsControlJustPressed(2, 194) then
                LeaveInsideTrack()
            end

            -- Left click
            if IsControlJustPressed(2, 237) then
                local clickedButton = Utils:GetMouseClickedButton()

                if Utils.ChooseHorseVisible then
                    if (clickedButton ~= 12) and (clickedButton ~= -1) then
                        Utils.CurrentHorse = (clickedButton - 1)
                        Utils:ShowBetScreen(Utils.CurrentHorse)
                        Utils.ChooseHorseVisible = false
                    end
                end

                -- Rules button
                if (clickedButton == 15) then
                    Utils:ShowRules()
                end

                -- Close buttons
                if (clickedButton == 12) then
                    if Utils.ChooseHorseVisible then
                        Utils.ChooseHorseVisible = false
                    end
                    
                    if Utils.BetVisible then
                        Utils:ShowHorseSelection()
                        Utils.BetVisible = false
                        Utils.CurrentHorse = -1
                    else
                        Utils:ShowMainScreen()
                    end
                end

                -- Start bet
                if (clickedButton == 1) then
                    Utils:ShowHorseSelection()
                end

                -- Start race
                if (clickedButton == 10) then
                    -- PlaySoundFrontend(-1, 'race_loop', 'dlc_vw_casino_inside_track_betting_single_event_sounds')
                    TriggerServerEvent("insidetrack:server:placebet", Utils.CurrentBet)
                    Utils:StartRace()
                    checkRaceStatus = true
                end

                -- Change bet
                if (clickedButton == 8) then
                    if (Utils.CurrentBet < Utils.PlayerBalance) then
                        Utils.CurrentBet = (Utils.CurrentBet + 100)
                        Utils.CurrentGain = (Utils.CurrentBet * 2)
                        Utils:UpdateBetValues(Utils.CurrentHorse, Utils.CurrentBet, Utils.PlayerBalance, Utils.CurrentGain)
                    end
                end

                if (clickedButton == 9) then
                    if (Utils.CurrentBet > 100) then
                        Utils.CurrentBet = (Utils.CurrentBet - 100)
                        Utils.CurrentGain = (Utils.CurrentBet * 2)
                        Utils:UpdateBetValues(Utils.CurrentHorse, Utils.CurrentBet, Utils.PlayerBalance, Utils.CurrentGain)
                    end
                end

                if (clickedButton == 13) then
                    Utils:ShowMainScreen()
                end

                -- Check race
                while checkRaceStatus do
                    Wait(0)

                    local raceFinished = Utils:IsRaceFinished()

                    if (raceFinished) then
                        StopSound(0)

                        if (Utils.CurrentHorse == Utils.CurrentWinner) then
                            TriggerServerEvent("insidetrack:server:winnings", Utils.CurrentGain)
                        end
                            
                        ESX.TriggerServerCallback("insidetrack:server:getbalance", function(balance)
                            Utils.PlayerBalance = balance
                        end)
						
                        Utils:UpdateBetValues(Utils.CurrentHorse, Utils.CurrentBet, Utils.PlayerBalance, Utils.CurrentGain)
                
                        Utils:ShowResults()

                        Utils.CurrentHorse = -1
                        Utils.CurrentWinner = -1
                        Utils.HorsesPositions = {}

                        checkRaceStatus = false
                    end
                end
            end
        end
    end)
end

local insideMarker = false

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(insideTrackLocation - coords)

        if dist <= 20.0 then
            Citizen.Wait(0)
			DrawMarker(29, insideTrackLocation.x, insideTrackLocation.y, insideTrackLocation.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.00, 1.00, 1.00, 36, 237, 157, 200, false, true, 2, true, false, false, false)
            if dist <= 1.0 and not insideTrackActive then
				DisplayHelpText("[~g~E~w~] Open - [~r~BACKSPACE~w~] to Exit")
                insideMarker = true
            end
        else
            insideMarker = false
            Citizen.Wait(1000)
        end
    end
end)

RegisterCommand("+InsideTrack", function()
    if insideMarker then
        OpenInsideTrack()
    end
end, false)
RegisterCommand("-InsideTrack", function()
end,false)
TriggerEvent("chat:removeSuggestion", "/+InsideTrack")
TriggerEvent("chat:removeSuggestion", "/-InsideTrack")

RegisterKeyMapping("+InsideTrack", "Interact with inside track at the casino", "keyboard" ,"E")

-- help text
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end