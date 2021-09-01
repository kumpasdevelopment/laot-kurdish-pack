local Keys = {["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118}

ESX = nil
LAOT = nil

plyHouse	    = {}
plyHouse.report = false

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

Citizen.CreateThread(function()
	while LAOT == nil do
		TriggerEvent('laot:getSharedObject', function(obj) LAOT = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('laot-house:BuzzC')
AddEventHandler('laot-house:BuzzC', function(player, discord, data, homeID)
	local discordID = LAOT.Utils.GetDiscordID()
	if discordID == tonumber(discord) then
		buzzQuestion(player, data.firstname, homeID)
	end
end)

RegisterNetEvent("laot-house:EnterHouse")
AddEventHandler("laot-house:EnterHouse", function(id)
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	local dst = GetDistanceBetweenCoords(x, y, z, C.HouseMenu["loc"].x, C.HouseMenu["loc"].y, C.HouseMenu["loc"].z, true)

	if dst <= 8 then
		enterHouse(id)
	end
end)

RegisterNetEvent("laot-house:Notification")
AddEventHandler("laot-house:Notification", function(type, text)
	LAOT.Notification(type, text)
end)

buzzQuestion = function(id, char, home)
	print(id)
	print(char)
	print(home)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'questionBuzz',
	{
		title    = char .." kapını çalıyor.",
		align = C.HouseMenu["ESXMenu"]["align"],
		elements = {
			{ label = "Kabul et", name = "yes" },
			{ label = "Reddet", name = "no" },
		}
	},
	function(data, menu)
		if data.current.name then
			if data.current.name == 'yes' then
				TriggerServerEvent("laot-house:BuzzAnswer", id, home["ID"], 'yes')
			end
			if data.current.name == 'no' then
				TriggerServerEvent("laot-house:BuzzAnswer", id, home["ID"], 'no')
			end
			menu.close()
		end
	end,
	function(data, menu)
	  TriggerServerEvent("laot-house:BuzzAnswer", id, home["ID"], 'no')
	  menu.close()
	end)
end

CheckOwnership = function(houseID)
	local discordID = LAOT.Utils.GetDiscordID()

	local v = C.Houses[houseID]
	for k, owner in pairs(v["owners"]) do 
		if owner == discordID then
			return true
		end
	end
end

reportSeller = function()
	if not plyHouse.report then
		plyHouse.report = true
		TriggerServerEvent("laot-house:ReportServer")
		LAOT.Notification("inform", "Ev satın alma isteğin yetkililere iletildi!")
		Citizen.Wait(14000)
		plyHouse.report = false
	end
end

openBuzzMenu = function()
	local allHouses = {}

	for k, v in pairs(C.Houses) do
		table.insert(allHouses, { label = (v["label"]), value = v["ID"] })
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buzzMenu',
	{
		title    = (l["buzzMenu"]),
		align = C.HouseMenu["ESXMenu"]["align"],
		elements = allHouses
	},
	function(data, menu)
		if data.current.value then
			local house = C.Houses[data.current.value]
			local mainOwner = house["mainOwner"]

			TriggerServerEvent("laot-house:BuzzServer", mainOwner, house)
			menu.close()
		end
	end,
	function(data, menu)
	  openHouseMenu()
	end)
end

enterHouse = function(ID)
	local v = C.Houses[ID]
	if v then

		local ply = GetPlayerServerId(PlayerId())
		local entity = GetPlayerFromServerId(ply)

		DoScreenFadeOut(2000)
		Citizen.Wait(2000)
		
		--SetEntityCoords(entity, v["insideHome"].x, v["insideHome"].y, v["insideHome"].z, 0.0, 0.0, 0.0, false)
		StartPlayerTeleport(entity, v["insideHome"].x, v["insideHome"].y, v["insideHome"].z, v["insideHome"].h, false, true, false)
		
		Citizen.Wait(2000)
		DoScreenFadeIn(2000)

	end
end

exitHouse = function()
	local ply = GetPlayerServerId(PlayerId())
	local entity = GetPlayerFromServerId(ply)

	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	
	StartPlayerTeleport(entity, C.HouseMenu["loc"].x, C.HouseMenu["loc"].y, C.HouseMenu["loc"].z, C.HouseMenu["loc"].h, false, true, false)
	
	Citizen.Wait(2000)
	DoScreenFadeIn(2000)
end

openMyHousesMenu = function()

	local houses = {}

	local discordID = LAOT.Utils.GetDiscordID()

	for k, v in pairs(C.Houses) do
		for k, owner in pairs(v["owners"]) do 
			if owner == discordID then
				table.insert(houses, { label = (v["label"]), value = v["ID"] })
			end
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'myHouses',
	{
		title    = (l["my_houses"]),
		align = C.HouseMenu["ESXMenu"]["align"],
		elements = houses
	},
	function(data, menu)
		if data.current.value then
			menu.close()
			enterHouse(data.current.value)
		end
	end,
	function(data, menu)
	  openHouseMenu()
	end)
end

openHouseMenu = function()
	local elements = {}

	table.insert(elements, { label = (l["report_seller"]), value = "report_seller" })
	table.insert(elements, { label = (l["buzz"]), value = "buzz" })
	table.insert(elements, { label = (l["open_houses"]), value = "houses" })

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu',
	{
		title    = (l["house_menu"]),
		align = C.HouseMenu["ESXMenu"]["align"], -- Menu position
		elements = elements
	},
	function(data, menu)
		if data.current.value then
			if data.current.value == 'houses' then
				openMyHousesMenu()
			elseif data.current.value == 'report_seller' then
				reportSeller()
			elseif data.current.value == 'buzz' then
				openBuzzMenu()
			end
		end
	end,
	function(data, menu)
	  menu.close()
	end)
end

OpenStash = function(type, owner)	
	TriggerEvent("disc-inventoryhud:openInventory", {
		["type"] = type,
		["owner"] = owner,
	})
end

Citizen.CreateThread(function()
	if C.HouseMenu and C.Houses then
		while true do
			Citizen.Wait(0) -- House menu
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local dst = GetDistanceBetweenCoords(x, y, z, C.HouseMenu["loc"].x, C.HouseMenu["loc"].y, C.HouseMenu["loc"].z, true)

			if dst <= 8 then
				LAOT.DrawText3D(C.HouseMenu["loc"].x, C.HouseMenu["loc"].y, C.HouseMenu["loc"].z+0.50, l["house_menu3D"])
				DrawMarker(C.HouseMenu["markerType"], C.HouseMenu["loc"].x, C.HouseMenu["loc"].y, C.HouseMenu["loc"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 200, 50, 200, 1.0, true, true, 0.0, nil, nil, false)
				if IsControlJustPressed(0, 38) and dst <= 1 then
					openHouseMenu()
				end
			else
				Citizen.Wait(1000)
			end
		end
	else
		LAOT.DebugPrint("Error loading Config of laot-house!")
	end
end)

Citizen.CreateThread(function()
	if C.blipCreator then
		newblip = AddBlipForCoord(C.HouseMenu["loc"].x, C.HouseMenu["loc"].y, C.HouseMenu["loc"].z)
    
		SetBlipSprite(newblip, 476)
		SetBlipScale(newblip, 1.0)
		SetBlipColour(newblip, 5)
		SetBlipAsShortRange(newblip, false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Apartman")
		EndTextCommandSetBlipName(newblip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) -- House menu
		for k, v in pairs(C.Houses) do
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local dst = GetDistanceBetweenCoords(x, y, z, v["exit"].x, v["exit"].y, v["exit"].z, true)

			if dst <= 5 then
				LAOT.DrawText3D(v["exit"].x, v["exit"].y, v["exit"].z+0.20, l["exit"])
				if IsControlJustPressed(0, 38) and dst <= 2 then
					exitHouse()
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0) -- House menu stash
		for k, v in pairs(C.Houses) do
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
			local dst = GetDistanceBetweenCoords(x, y, z, v["stash"]["loc"].x, v["stash"]["loc"].y, v["stash"]["loc"].z, true)

			if dst <= 5 and CheckOwnership(v["ID"]) then
				LAOT.DrawText3D(v["stash"]["loc"].x, v["stash"]["loc"].y, v["stash"]["loc"].z+0.20, l["stash"])
				if IsControlJustPressed(0, 38) and dst <= 2 then
					OpenStash("houseLaot", v["label"])
				end
			end
		end
	end
end)
