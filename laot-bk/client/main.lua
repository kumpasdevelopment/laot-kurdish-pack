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

RegisterNetEvent("laot-bk:notify")
AddEventHandler("laot-bk:notify", function(text, type)
	exports.pNotify:SetQueueMax("laot-bk", 4)
	exports.pNotify:SendNotification({
		text = text,
		type = type,
		timeout = "2500",
		layout = "topRight",
		queue = "laot-bk"
	})
end)

zoneNames = {
	AIRP = "Los Santos Uluslararası Havalimanı",
	ALAMO = "Alamo Denizi",
	ALTA = "Alta",
	ARMYB = "Zancuda Askeri Üs",
	BANHAMC = "Banham Kanyonu",
	BANNING = "Banning",
	BAYTRE = "Baytree Kanyonu", 
	BEACH = "Vespucci Kumsalı",
	BHAMCA = "Banham Kanyonu",
	BRADP = "Braddock Geçişi",
	BRADT = "Braddock Tüneli",
	BURTON = "Burton",
	CALAFB = "Calafia Köprüsü",
	CANNY = "Raton Kanyonu",
	CCREAK = "Cassidy Deresi",
	CHAMH = "Chamberlain Tepesi",
	CHIL = "Vinewood Tepesi",
	CHU = "Chumash",
	CMSW = "Chiliad Dağı Eyalet Bölgesi",
	CYPRE = "Cypress Evleri",
	DAVIS = "Davis",
	DELBE = "Del Perro Sahili",
	DELPE = "Del Perro",
	DELSOL = "La Puerta",
	DESRT = "Büyük Senora Çölü",
	DOWNT = "Downtown",
	DTVINE = "Downtown Vinewood",
	EAST_V = "Doğu Vinewood",
	EBURO = "El Burro Tepeleri",
	ELGORL = "El Gordo Deniz Feneri",
	ELYSIAN = "Cennet Adası",
	GALFISH = "Galilee Takas Kampı",
	GALLI = "Galileo Parkı",
	golf = "GWC ve Golf	Topluluğu",
	GRAPES = "Grapeseed",
	GREATC = "Büyük Chaparral",
	HARMO = "Harmony",
	HAWICK = "Hawick",
	HORS = "Vinewood Yarış Pisti",
	HUMLAB = "Humane Lab. ve Araştırma Ens.",
	JAIL = "Federal Hapishane",
	KOREAT = "Little Seoul",
	LACT = "Land Act Baraj Gölü",
	LAGO = "Zancudo Gölü",
	LDAM = "Land Act Barajı",
	LEGSQU = "Legion Meydanı",
	LMESA = "La Mesa",
	LOSPUER = "La Puerta",
	MIRR = "Mirror Park",
	MORN = "Morningwood",
	MOVIE = "Görkemli Richards",
	MTCHIL = "Chiliad Dağı",
	MTGORDO = "Gordo Dağı",
	MTJOSE = "Josiah Dağı",
	MURRI = "Murrieta Tepeleri",
	NCHU = "Kuzey Chumash",
	NOOSE = "N.O.O.S.E",
	OCEANA = "Pasifik Okyanusu",
	PALCOV = "Paleto Koy",
	PALETO = "Paleto Körefezi",
	PALFOR = "Paleto Ormanı",
	PALHIGH = "Palomino Dağlıkları",
	PALMPOW = "Palmer-Taylor Güç İstasyonu",
	PBLUFF = "Pacific Kayalıkları",
	PBOX = "Pillbox Tepeleri",
	PROCOB = "Procopio Sahili",
	RANCHO = "Rancho",
	RGLEN = "Richman Glen",
	RICHM = "Richman",
	ROCKF = "Rockford Tepeleri",
	RTRAK = "Redwood Motocross Pisti",
	SanAnd = "San Andreas",
	SANCHIA = "San Chianski Range Dağları",
	SANDY = "Sandy Shores",
	SKID = "Mission Row",
	SLAB = "Stab City",
	STAD = "Maze Bank Bölgesi",
	STRAW = "Strawberry",
	TATAMO = "Tataviam Dağları",
	TERMINA = "Terminal",
	TEXTI = "Textile City",
	TONGVAH = "Tongva Hills",
	TONGVAV = "Tongva Valley",
	VCANA = "Vespucci Kanalları",
	VESP = "Vespucci",
	VINE = "Vinewood",
	WINDF = "Ron Alternates Rüzgar Çiftliği",
	WVINE = "Güney Vinewood",
	ZANCUDO = "Zancudo Nehri",
	ZP_ORT = "Güney Los Santos Limanı",
	ZQ_UAR = "Davis Quartz Madencilik Sahası"
}

RegisterNetEvent("laot-bk:kod")
AddEventHandler("laot-bk:kod", function(kod)
	local playerPed = GetPlayerPed(-1)
	local plyPos = GetEntityCoords(GetPlayerPed(-1))
	local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
	local street1 = GetStreetNameFromHashKey(s1)
	zone = tostring(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
	local playerStreetsLocation = zoneNames[tostring(zone)]
	local street1 = street1 .. ", " .. playerStreetsLocation
	local street2 = GetStreetNameFromHashKey(s2)
	local adres = street1.. " " .. street2
	local v = GetEntityCoords(playerPed)
	print(v)
	print(kod)
	TriggerServerEvent('esx_outlawalert:kodAlertS', {
	  x = ESX.Math.Round(v.x, 1),
	  y = ESX.Math.Round(v.y, 1),
	  z = ESX.Math.Round(v.z, 1)
	}, adres, kod)
end)