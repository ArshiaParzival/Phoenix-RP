ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('duty:police')
AddEventHandler('duty:police', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade

    if job == "police" then
        xPlayer.setJob('offpolice', grade)
    elseif job == "offpolice" then
        xPlayer.setJob('police', grade)
    end
end)


RegisterServerEvent('duty:ambulance')
AddEventHandler('duty:ambulance', function(job)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    if job == "ambulance" then
        xPlayer.setJob('offambulance', grade)
    elseif job == "offambulance" then
        xPlayer.setJob('ambulance', grade)
    end
end)

RegisterServerEvent('duty:dadgostari')
AddEventHandler('duty:dadgostari', function(job)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade
        if job == "dadgostari" then
            xPlayer.setJob('offdadgostari', grade)
        elseif job == "offdadgostari" then
            xPlayer.setJob('dadgostari', grade)
        end
end)

RegisterServerEvent('duty:weazel')
AddEventHandler('duty:weazel', function(job)

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local job = xPlayer.job.name
        local grade = xPlayer.job.grade

        if job == "weazel" then
            xPlayer.setJob('offweazel', grade)
        elseif job == "offweazel" then
            xPlayer.setJob('weazel', grade)
        end
end)

function sendNotification(xSource, message, messageType, messageTimeout)
    TriggerClientEvent("esx:showNotification", xSource, message)
end