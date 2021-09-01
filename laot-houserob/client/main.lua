local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

local isLockpicking = false
local streetName, playerGender

coords = {}
userData = {}
userData.Robbing = false
userData.ID = nil
userData.Ped = nil
userData.Search = false
userData.houseObj = {}
userData.POIOffsets = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while LAOT == nil do
		TriggerEvent('laot:getSharedObject', function(obj) LAOT = obj end)
		Citizen.Wait(0)
	end
end)

TriggerEvent('skinchanger:getSkin', function(skin)
    playerGender = skin.sex
end)

AddEventHandler('skinchanger:loadSkin', function(character)
	playerGender = character.sex
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while true do
		while LAOT == nil do
			Citizen.Wait(10)
		end
		while ESX == nil do
			Citizen.Wait(10)
		end
		if not userData.Robbing then
			for k, v in pairs(C.RobHouses) do
				if Vdist2(GetEntityCoords(PlayerPedId()), v.x,v.y,v.z) < 5 then
					LAOT.DrawText3D(v.x, v.y, v.z, _U("Rob_House"))
					if IsControlJustPressed(0, Keys["E"]) then
						if isNight() then
							houseRob(v.x, v.y, v.z, v.id)
						else
							LAOT.Notification("error", _U("Not_Now"))
						end
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
		Citizen.Wait(1)
	end
end)

leaveHouseRob = function()
	exports['laot-interior']:DespawnInterior(userData.houseObj, function()
		local v = C.RobHouses[userData.ID]
		DoScreenFadeOut(100)
		TriggerEvent("InteractSound_CL:PlayOnOne", "doorexit", 1.0)
		Citizen.Wait(1500)
		userData.houseObj = {}
		userData.POIOffsets = {}
		userData.Robbing = false
		local ply = GetPlayerServerId(PlayerId())
		local entity = GetPlayerFromServerId(ply)
		DoScreenFadeOut(500)
		Citizen.Wait(500)
		StartPlayerTeleport(entity, v.x, v.y, v.z, v.h-180.0, false, true, false)
		DoScreenFadeIn(500)
		userData.ID = nil
		userData.Search = false
		if DoesEntityExist(userData.Ped) then
			DeleteEntity(userData.Ped)
			userData.Ped = nil
		end
		for k, v in pairs(Search) do
			v["searched"] = false
		end
    end)
end

houseRob = function(x,y,z, ID)
	ESX.TriggerServerCallback("laot-houserob:GetPolice", function(police)
		if police >= C.MinimumPoliceCount then
			ESX.TriggerServerCallback("laot-houserob:CanRob", function(canRob)
				if canRob then
					userData.Robbing = true
					ESX.TriggerServerCallback("laot-houserob:GetItemAmount", function(ahmetabi)
						if ahmetabi >= 1 then
							userData.ID = nil
							userData.Search = false
							if DoesEntityExist(userData.Ped) then
								DeleteEntity(userData.Ped)
								userData.Ped = nil
							end
							for k, v in pairs(Search) do
								v["searched"] = false
							end
							TriggerEvent("lockpickAnimationlaot")
							exports["t0sic_loadingbar"]:StartDelayedFunction(_U("Lockpicking"), 8000, function()
								isLockpicking = false
								
								togo = { ["x"] = x, ["y"] = y, ["z"] = z }
								coords = { x = (togo['x'] + math.random(15, 25)), y = (togo['y'] + math.random(15,30)), z = (togo['z'] - math.random(15, 70)) }
								data = exports['laot-interior']:CreateTier1HouseFurnished(coords)
								Citizen.Wait(100)
								userData.houseObj = data[1]
								userData.POIOffsets = data[2]
								userData.ID = ID
								Robbing()
								TriggerServerEvent('laot-houserob:server:RemoveItem', C.LockpickItem, 1)
								if math.random(1,2) == 1 then
									local playerPed = PlayerPedId()
									local playerCoords = GetEntityCoords(playerPed)
									local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
									local street1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
									local streetName = (GetStreetNameFromHashKey(street1))
									TriggerServerEvent('esx_outlawalert:houseRobberyinProgress', {
										x = ESX.Math.Round(playerCoords.x, 1),
										y = ESX.Math.Round(playerCoords.y, 1),
										z = ESX.Math.Round(playerCoords.z, 1)
									}, streetName, playerGender)
								end
								TriggerServerEvent("laot-houserob:server:robState", GetPlayerServerId(PlayerId()))
						
								Citizen.Wait(1000)
							end)
						else
							LAOT.Notification("error", _U("You_Dont_Have_Lockpick"))
						end
					end, C.LockpickItem)
				else
					LAOT.Notification("error", _U("You_Cant"))
				end
			end)
		else
			LAOT.Notification("error", _U("Police"))
		end
	end)
end

CreatePed = function()
	local model = LAOT.Utils.LoadModel(C.NPC["hash"])
	userData.Ped = CreatePed(0, model, coords.x - C.NPC["coords"]["x"], coords.y - C.NPC["coords"]["y"], coords.z + C.NPC["coords"]["z"], C.NPC["coords"]["h"], 1, 1)
	SetEntityAsMissionEntity(userData.Ped, false, true)
	LAOT.Utils.LoadAnimDict("dead")
	TaskPlayAnim(userData.Ped, "dead", 'dead_a', 100.0, 1.0, -1, 1, 0, 0, 0, 0)
end


Robbing = function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if userData.Robbing then
				local pedCoords = GetEntityCoords(PlayerPedId())
				if Vdist2(pedCoords, coords.x + 3.69693000, coords.y - 15.080020100, coords.z + 2.5) <= 3 then
					LAOT.DrawText3D(coords.x + 3.69693000, coords.y - 15.080020100, coords.z + 2.5, _U("Exit_House"))
					if IsControlJustPressed(0, Keys["E"]) then
						leaveHouseRob()
					end
				end
				for k, v in pairs(Search) do
					if Vdist2(pedCoords, coords.x - v["coords"]["x"], coords.y - v["coords"]["y"], coords.z + v["coords"]["z"]) <= 5.0 then
						if not Search[v.ID]["searched"] and not userData.Search then
							LAOT.DrawText3D(coords.x - v["coords"]["x"], coords.y - v["coords"]["y"], coords.z + v["coords"]["z"], "~o~E ~w~- ".. v["label"] .."")
							if IsControlJustPressed(0, Keys["E"]) and Vdist2(pedCoords, coords.x - v["coords"]["x"], coords.y - v["coords"]["y"], coords.z + v["coords"]["z"]) <= 1.5 then
								SearchFor(v.ID)
							end
						end
					end
				end
			else
				Citizen.Wait(1500)
			end
		end
	end)
end

isNight = function()
	local hour = GetClockHours()
	if hour > 19 or hour < 5 then
		return true
	end
end

RegisterCommand("gethousecoords", function()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	print("X: ".. coords.x - x)
	print("Y: ".. coords.y - y)
	print("Z: ".. coords.y + z)
end)

SearchFor = function(ID)
	if not userData.Search then
		userData.Search = true
		TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
		exports["t0sic_loadingbar"]:StartDelayedFunction("".. Search[ID]["label"] ..' arıyorsun...', 8000, function()
			for i=1, 10 do
				if not Search[ID]["searched"] then
					local Item = Search[ID]["Items"][math.random(1, #Search[ID]["Items"])]
					if math.random(1, 100) <= Item.chance then
						Search[ID]["searched"] = true
						userData.Search = false
						ClearPedTasksImmediately(PlayerPedId())
						LAOT.Notification("inform", Item.amount ..' '.. Item.label ..' buldun!')
						TriggerServerEvent("laot-houserob:server:Reward", Item.i, Item.amount)
					end
					if i == 10 and not Search[ID]["searched"] then
						Search[ID]["searched"] = true
						userData.Search = false
						ClearPedTasksImmediately(PlayerPedId())
						LAOT.Notification("inform", _U("Nothing"))
					end
				end
			end
		end)
	end
end

RegisterNetEvent("lockpickAnimationlaot")
AddEventHandler("lockpickAnimationlaot", function()
	isLockpicking = true 
	LAOT.Utils.LoadAnimDict('veh@break_in@0h@p_m_one@')
	while isLockpicking do
		DisableControlAction(0, 38, true) -- E tuşu iptal etme
		if not IsEntityPlayingAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 3) then
			TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
			Citizen.Wait(1500)
			ClearPedTasks(PlayerPedId())
		end
		Citizen.Wait(1)
	end
	ClearPedTasks(PlayerPedId())
end)

