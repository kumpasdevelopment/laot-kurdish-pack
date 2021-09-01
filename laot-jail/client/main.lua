local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

user 		  = {}
user.inJail   = false
user.jailTime = nil

local seconds = 1000
local minutes = 60 * seconds

local vassoumodel = "prop_tool_broom"
local vassour_net = nil


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
	Citizen.Wait(1000)
	TriggerServerEvent("laot-jail:CheckJail", GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterCommand("hapishanetest", function()
	TriggerEvent("laot-jail:JailTarget")
end)

RegisterNetEvent("laot-jail:JailTarget")
AddEventHandler("laot-jail:JailTarget", function()
	if ESX.PlayerData.job.name == 'police' then
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		local closestPed = GetPlayerPed(closestPlayer)
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jailMenu',
			{
			  title = ('Hapis kaç dakika olacak?')
			},
			function(data, menu)
			  local amount = tonumber(data.value)
			  if amount == nil then
				LAOT.Notification("error", 'Geçersiz süre.')
			  else
				menu.close()
				TriggerServerEvent("laot-jail:ServerJail", GetPlayerServerId(closestPlayer), amount)
			  end
			end,
			function(data, menu)
			  menu.close()
			end)
		else
			LAOT.Notification("error", "Yakında oyuncu yok!")
		end
	end
end)

RegisterNetEvent("laot-jail:ClientJail")
AddEventHandler("laot-jail:ClientJail", function(amount)
	user.jailTime = amount
	user.inJail = true
	LAOT.Notification("error", "".. amount .. " dakika hapistesin!")

	local ply = GetPlayerServerId(PlayerId())
	local entity = GetPlayerFromServerId(ply)

	ApplyPrisonerSkin()

	local random = math.random(1, #C.cells)
	local v = C.cells[random]

	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	
	StartPlayerTeleport(entity, v.x, v.y, v.z, v.h, false, true, false)
	
	Citizen.Wait(2000)
	DoScreenFadeIn(2000)
end)

openJailMenu = function()
	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'userJailMenu', -- Replace the menu name
	{
	  title    = ('Hapishane Menüsü'),
	  align = 'top-right', -- Menu position
	  elements = { -- Contains menu elements
		{label = ('Hapishanede kalan süreniz:' .. user.jailTime .. ' dakika'),	value = 'test'},
	  }
	},
	function(data, menu) -- This part contains the code that executes when you press enter
	  if data.current.value == 'test' then
		menu.close()
	  end   
	end,
	function(data, menu) -- This part contains the code  that executes when the return key is pressed.
		menu.close() -- Close the menu
	end
  )
end

food = function()
	TriggerEvent('esx_status:add', 'hunger', 100000)
	TriggerEvent('esx_status:add', 'thirst', 100000)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if user.inJail then
			local ped = PlayerPedId()
			RemoveAllPedWeapons(ped, true)
			DisableControlAction(0, Keys["F2"], true)
			DisableControlAction(0, Keys["1"], true)
			DisableControlAction(0, Keys["2"], true)
			DisableControlAction(0, Keys["3"], true)
			DisableControlAction(0, Keys["4"], true)
			DisableControlAction(0, Keys["5"], true)
			if IsDisabledControlJustPressed(0, Keys["F2"]) then
				openJailMenu()
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if user.inJail then
			Citizen.Wait(60 * seconds)
			user.jailTime = user.jailTime - 1
			print(user.jailTime)
			if user.jailTime <= 0 then
				leaveJail()
			else
				TriggerServerEvent("laot-jail:ServerJail", GetPlayerServerId(PlayerId()), user.jailTime)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if user.inJail then
			local pCoords    = GetEntityCoords(PlayerPedId())
			local distance = GetDistanceBetweenCoords(pCoords, C.clean.x, C.clean.y, C.clean.z, true)

			if distance < 10 and not cleaning then

				ESX.ShowHelpNotification("Temizlik yapmak için ~INPUT_PICKUP~ basın.\n~b~Hapis süren azalacaktır.")
				if IsControlJustPressed(0, 38) then
					cleaning = true
					local cSCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
					local vassouspawn = CreateObject(GetHashKey(vassoumodel), cSCoords.x, cSCoords.y, cSCoords.z, 1, 1, 1)
					local netid = ObjToNet(vassouspawn)

					ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
						TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0, false, false, false)
						AttachEntityToEntity(vassouspawn,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422),-0.005,0.0,0.0,360.0,360.0,0.0,1,1,0,1,0,1)
						vassour_net = netid
					end)

					Citizen.Wait(30000)
					disable_actions = false
					DetachEntity(NetToObj(vassour_net), 1, 1)
					DeleteEntity(NetToObj(vassour_net))
					vassour_net = nil
					ClearPedTasks(PlayerPedId())
					user.jailTime = user.jailTime - 1
					cleaning = false
				end

			else
				Citizen.Wait(1500)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if user.inJail then
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local dst = GetDistanceBetweenCoords(x, y, z, C.food.x, C.food.y, C.food.z, true)

			if dst <= 5 then
				LAOT.DrawText3D(C.food.x, C.food.y, C.food.z, "~y~E~w~ - Yemek Ye")
				if IsControlJustPressed(0, 38) then
					food()
				end
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

enterYard = function()
	local ply = GetPlayerServerId(PlayerId())
	local entity = GetPlayerFromServerId(ply)

	local v = C.yard["inside"]

	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	
	StartPlayerTeleport(entity, v.x, v.y, v.z, v.h, false, true, false)
	
	Citizen.Wait(2000)
	DoScreenFadeIn(2000)
end

leaveYard = function()
	local ply = GetPlayerServerId(PlayerId())
	local entity = GetPlayerFromServerId(ply)

	local v = C.yard["outside"]

	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	
	StartPlayerTeleport(entity, v.x, v.y, v.z, v.h, false, true, false)
	
	Citizen.Wait(2000)
	DoScreenFadeIn(2000)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if user.inJail then
			local v = C.yard["outside"]
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local dst = GetDistanceBetweenCoords(x, y, z, v.x, v.y, v.z, true)

			if dst <= 5 then
				LAOT.DrawText3D(v.x, v.y, v.z, "~y~E~w~ - Içeri Gir")
				if IsControlJustPressed(0, 38) then
					enterYard()
				end
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

function ApplyPrisonerSkin()

	local playerPed = PlayerPedId()

	if DoesEntityExist(playerPed) then

		Citizen.CreateThread(function()

			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, C.Uniforms['prison_wear'].male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, C.Uniforms['prison_wear'].female)
				end
			end)

		SetPedArmour(playerPed, 0)
		ClearPedBloodDamage(playerPed)
		ResetPedVisibleDamage(playerPed)
		ClearPedLastWeaponDamage(playerPed)
		ResetPedMovementClipset(playerPed, 0)

		end)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if user.inJail then
			local v = C.yard["inside"]
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local dst = GetDistanceBetweenCoords(x, y, z, v.x, v.y, v.z, true)

			if dst <= 5 then
				LAOT.DrawText3D(v.x, v.y, v.z, "~y~E~w~ - Dısarı Çık")
				if IsControlJustPressed(0, 38) then
					leaveYard()
				end
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

leaveJail = function()
	local ply = GetPlayerServerId(PlayerId())
	local entity = GetPlayerFromServerId(ply)

	user.jailTime = nil
	user.inJail = false
	TriggerServerEvent("laot-jail:RemoveFromJail", GetPlayerServerId(PlayerId()))
	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	
	StartPlayerTeleport(entity, C.outside.x, C.outside.y, C.outside.z, C.outside.h, false, true, false)
	
	Citizen.Wait(2000)
	DoScreenFadeIn(2000)
end