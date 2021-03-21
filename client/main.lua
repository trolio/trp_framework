local loaded = false
local oldPos
local pvpEnabled = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local pos = GetEntityCoords(PlayerPedId())

        if (oldPos ~= pos) then
            TriggerServerEvent('trp:updatePositions', pos.x, pos.y, pos.z)
            oldPos = pos
        end
    end
end)

local myDecorators = {}

RegisterNetEvent("trp:setPlayerDecorator")
AddEventHandler("trp:setPlayerDecorator", function(key, value, doNow)
    myDecorators[key] = value
    DecorRegister(key, 3)

    if (doNow) then
        DecorSetInit(PlayerPedId(), key, value)
    end
end)

local enableNative = {}
local firstSpawn = true

AddEventHandler("playerSpawned", function()
    for k, v in pairs(myDecorators) do
        DecorSetInit(PlayerPedId(), k, v)
    end
    TriggerServerEvent(playerSpawned)
end)

RegisterNetEvent("trp:enablePVP")
AddEventHandler("trp:enablePVP", function()
    pvpEnabled = true
end)