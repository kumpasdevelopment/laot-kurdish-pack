ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

AddEventHandler("disc-inventoryhud:MoveToEmpty", function(data)
	print("Move to empty.")
	local oyuncu = GetPlayerServerId(PlayerId())
	TriggerServerEvent("laot-logs:MoveToEmpty", oyuncu, data)
end)

AddEventHandler("disc-inventoryhud:EmptySplitStack", function(data)
	local oyuncu = GetPlayerServerId(PlayerId())
	TriggerServerEvent("laot-logs:EmptySplitStack", oyuncu, data)
end)

AddEventHandler("disc-inventoryhud:TopoffStack", function(data)
	local oyuncu = GetPlayerServerId(PlayerId())
	TriggerServerEvent("laot-logs:TopoffStack", oyuncu, data)
end)

AddEventHandler("disc-inventoryhud:SplitStack", function(data)
	local oyuncu = GetPlayerServerId(PlayerId())
	TriggerServerEvent("laot-logs:SplitStack", oyuncu, data)
end)

AddEventHandler("disc-inventoryhud:SwapItems", function(data)
	local oyuncu = GetPlayerServerId(PlayerId())
	TriggerServerEvent("laot-logs:SwapItems", oyuncu, data)
end)

AddEventHandler("disc-inventoryhud:CombineStack", function(data)
	local oyuncu = GetPlayerServerId(PlayerId())
	TriggerServerEvent("laot-logs:CombineStack", oyuncu, data)
end)

AddEventHandler("disc-laot:laotLOG1", function(data)
	local oyuncu = GetPlayerServerId(PlayerId())
	TriggerServerEvent("laot-logs:ItemUse", oyuncu, data)
end)

AddEventHandler('onPlayerKilled', function(playerId, attackerId, reason, position)
    local reasonString = 'öldürdü'
    local player = GetPlayerByServerId(playerId)
    local attacker = GetPlayerByServerId(attackerId)

    if reason == 0 or reason == 56 or reason == 1 or reason == 2 then
        reasonString = 'yumruklayarak öldürdü'
    elseif reason == 3 then
        reasonString = 'bıçakladı'
    elseif reason == 4 or reason == 6 or reason == 18 or reason == 51 then
        reasonString = 'bombaladı'
    elseif reason == 5 or reason == 19 then
        reasonString = 'yaktı'
    elseif reason == 7 or reason == 9 then
        reasonString = 'vurarak öldürdü'
    elseif reason == 10 or reason == 11 then
        reasonString = 'pompalı ile öldürdü'
    elseif reason == 12 or reason == 13 or reason == 52 then
        reasonString = 'SMG ile öldürdü'
    elseif reason == 14 or reason == 15 or reason == 20 then
        reasonString = 'tarayarak öldürdü'
    elseif reason == 16 or reason == 17 then
        reasonString = 'sniper ile öldürdü'
    elseif reason == 49 or reason == 50 then
        reasonString = 'üzerinden geçti'
    end

    if playerId and attackerId then
        TriggerServerEvent('playerDied', player.name , " ".. reasonString .." " , attacker.name)
    end
end)


local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Car = { 133987706, -1553120962 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }

Citizen.CreateThread(function()
    local alreadyDead = false

    while true do
        Citizen.Wait(50)
        local playerPed = GetPlayerPed(-1)
        if IsEntityDead(playerPed) and not alreadyDead then

			local playerName = GetPlayerServerId(PlayerId())
            for id = 0, 64 do
                if killer == GetPlayerPed(id) then
                    killername = GetPlayerServerId(id)
                end
            end

            local death = GetPedCauseOfDeath(playerPed)

            if checkArray (Animal, death) then
                TriggerServerEvent('playerDied2', playerName , " bir hayvan tarafından öldürüldü.")
            elseif checkArray (FallDamage, death) then
                TriggerServerEvent('playerDied2', playerName , " düşerek öldü.")
            elseif checkArray (Explosion, death) then
                TriggerServerEvent('playerDied2', playerName , " bir patlamada öldü.")
            elseif checkArray (Gas, death) then
                TriggerServerEvent('playerDied2', playerName , " gazdan dolayı öldü.")
            elseif checkArray (Burn, death) then
                TriggerServerEvent('playerDied2', playerName , " yanarak öldü.")
            elseif checkArray (Drown, death) then
                TriggerServerEvent('playerDied2', playerName , " boğuldu.")
            else
                TriggerServerEvent('playerDied2', playerName , " bilinmeyen bir güç tarafından öldü.")
            end

            alreadyDead = true
        end

        if not IsEntityDead(playerPed) then
            alreadyDead = false
        end
    end
end)

function checkArray (array, val)
    for name, value in ipairs(array) do
        if value == val then
            return true
        end
    end
    return false
end

