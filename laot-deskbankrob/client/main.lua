local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

INFO = {}
isRobber = false

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('laot-deskbankrob:Sync')
AddEventHandler('laot-deskbankrob:Sync', function(value)
    INFO = value
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if LAOT.Game.GetDistance(C.BankLocation.x, C.BankLocation.y, C.BankLocation.z) < 20 then
			for k,v in pairs(C.Locations) do
				if LAOT.Game.GetDistance(v.x, v.y, v.z) < 3 then
					LAOT.DrawText3D(v.x, v.y, v.z, _U(v.locale))
					if IsControlJustPressed(0, Keys["E"]) then
						startRob(v.locale)
					end
				end
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

startRob = function(rob)
	TriggerServerEvent("laot-deskbankrob:Sync")
	Citizen.Wait(500)
	if rob == 'desk_rob' then
		print("Vezne soygunu")
		if not INFO.robbing then
			ESX.TriggerServerCallback("laot-deskbankrob:GetItemAmount", function(amount)
				if amount > 0 then
					isRobber = true
					TriggerServerEvent("laot-deskbankrob:Robbing", true, true)
					exports["t0sic_loadingbar"]:StartDelayedFunction("Kapıyı zorluyorsun", 8000, function()
						TriggerServerEvent("laot-deskbankrob:OpenDeskDoor")
					end)
				else
					LAOT.Notification("error", "Maymuncuğun yok.")
				end
			end, "lockpick")
		end
	end
	if rob == 'bank_rob' then
		print("Banka soygunu")
		if isRobber then
			TriggerServerEvent("laot-deskbankrob:Robbing", true, true)
			LAOT.Notification("inform", "Kapıyı zorluyorsun...")
			ESX.TriggerServerCallback("laot-deskbankrob:GetItemAmount", function(amount)
				if amount > 0 then
					LAOT.Notification("inform", "Kapıyı güvenlik kartı ile açıyorsun...")
					ESX.TriggerServerCallback("laot-deskbankrob:PoliceCount", function(Cops)
						if Cops >= C.CopsBank then
							animation()
						else
							LAOT.Notification("error", "Yeterli polis yok.")
						end
					end)
				else
					ESX.TriggerServerCallback("laot-deskbankrob:GetItemAmount", function(amount)
						if amount > 0 then
							local skil = exports["reload-skillbar"]:taskBar(2000,math.random(5,15))
							if skil ~= 100 then
								exports['mythic_notify']:SendAlert('error', 'Başarısız oldun', 2500)				   
							else
								loadAnimDict("anim@heists@ornate_bank@thermal_charge")
								SetPtfxAssetNextCall("scr_ornate_heist")
								local PlayerPos = GetEntityCoords(PlayerPedId())
								local doorvault = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('v_ilev_gb_vauldr'), 0, 0, 0)
								local b = GetEntityCoords(doorvault)
								local ped = GetPlayerPed(-1)
								local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", b.x,b.y,b.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
								ApplyDamageToPed(PlayerPedId(), 2, false)
								TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
								TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, 0, 0, 0)
								
								exports["t0sic_loadingbar"]:StartDelayedFunction("Kapı eritiliyor", 8000, function()
									StopParticleFxLooped(effect, 0)

									exports['mythic_notify']:SendAlert('inform', 'Kapı açıldı!', 2500)
									TriggerServerEvent("laot-deskbankrob:OpenVaultDoor")
								end)
							end   
						end
					end, "thermite")
				end
			end, "securitycardsbank")
		else
			LAOT.Notification("error", "Önce vezneyi soymalısın.")
		end
	end
end

RegisterNetEvent('laot-deskbankrob:ResetDeskDoor')
AddEventHandler('laot-deskbankrob:ResetDeskDoor', function()
	local cashier = C.Locations["desk"]

	local door = GetClosestObjectOfType(cashier.x, cashier.y, cashier.z, 1.0, 4163212883, 0, 0, 0)
	SetEntityHeading(door, cashier.dh)
	print(door)
end)

RegisterNetEvent('laot-deskbankrob:OpenDeskDoor')
AddEventHandler('laot-deskbankrob:OpenDeskDoor', function()
    local playerPed		= GetPlayerPed(-1)
    local coords		= GetEntityCoords(playerPed)

	local cashier = C.Locations["desk"]

	local door = GetClosestObjectOfType(cashier.x, cashier.y, cashier.z, 1.0, 4163212883, 0, 0, 0)

	local distance = GetDistanceBetweenCoords(cashier.x, cashier.y, cashier.z, coords.x, coords.y, coords.z, true)

	if distance < 3 then

		SetEntityHeading(door, -200)

	end

end)

RegisterNetEvent('laot-deskbankrob:OpenVaultDoorClient')
AddEventHandler('laot-deskbankrob:OpenVaultDoorClient', function()
	ResetDoor()
	
	OpenVaultDoor()
end)

RegisterNetEvent('laot-deskbankrob:ResetVaultDoor')
AddEventHandler('laot-deskbankrob:ResetVaultDoor', function()
	ResetDoor()
end)

Citizen.CreateThread(function()
	ResetDoor()
	TriggerEvent("laot-deskbankrob:ResetDeskDoor")
end)

function OpenVaultDoor()
	print("Kapı açılıyor:")

	local PlayerPos = GetEntityCoords(PlayerPedId())
	local doorvault = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('v_ilev_gb_vauldr'), 0, 0, 0)
	local doorvault2 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('hei_prop_heist_sec_door'), 0, 0, 0) 
	local rotation = GetEntityRotation(door, -15.835)
	local heading = GetEntityHeading(doorvault) - 0.10
	local heading2 = GetEntityHeading(doorvault2) - 0.10

	local heading = GetEntityHeading(doorvault) - 50.90
	local heading2 = GetEntityHeading(doorvault2) - 50.90

	SetEntityHeading(doorvault, heading)
	SetEntityHeading(doorvault2, heading2)

	Citizen.CreateThread(function()
		FreezeEntityPosition(doorvault, false)
		FreezeEntityPosition(doorvault2, false)

            Citizen.Wait(1)

            rotation = rotation - 0.25

			SetEntityHeading(doorvault, heading)

		FreezeEntityPosition(doorvault, true)
		FreezeEntityPosition(doorvault2, true)
    end)

end

function ResetDoor()
	local PlayerPos = GetEntityCoords(PlayerPedId())
    local doorvault = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('v_ilev_gb_vauldr'), 0, 0, 0)
	local doorvault2 = GetClosestObjectOfType(PlayerPos.x, PlayerPos.y, PlayerPos.z, 100.0, GetHashKey('hei_prop_heist_sec_door'), 0, 0, 0) 

	SetEntityHeading(doorvault, 250.00)
	SetEntityHeading(doorvault2, 250.00)
end

function animation()
	local playerPed = GetPlayerPed(-1)
    local coords, shn = GetEntityCoords(PlayerPedId()), true 
    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do
        Citizen.Wait(1)
	end
	
    local ped = PlayerPedId()
 	for k,v in pairs(C.AnimCoords) do
		if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 5 then 
			SetEntityCoords(ped, v.x, v.y, v.z)
			SetEntityHeading(ped, v.h)
			local pedco = GetEntityCoords(PlayerPedId())
			IdProp = CreateObject(GetHashKey("p_ld_id_card_01"), pedco, 1, 1, 0)
			local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

			AttachEntityToEntity(IdProp, ped, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
			TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", -1, true)
			exports["t0sic_loadingbar"]:StartDelayedFunction("Güvenlik kartı kullanılıyor", 8000, function()
				DeleteEntity(IdProp)
				Citizen.Wait(1500)
				DetachEntity(IdProp, false, false)
				Citizen.Wait(500)
				ClearPedTasksImmediately(ped)
				TriggerServerEvent("laot-deskbankrob:OpenVaultDoor")
			end)
		end
	end
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
     Citizen.Wait(5)
    end
end