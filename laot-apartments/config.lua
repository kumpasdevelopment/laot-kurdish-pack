C = {}

C.version = 1.0
C.Locale = 'tr'

C.Apartment = {
	["Name"] = "Apartmante Jaura",
	["Location"] = { x = 186.0505, y = -1078.35, z = 29.274, h = 81.071792602539 },
	["Outside"] = { x = 188.7187, y = -1078.92, z = 29.274, h = 257.67498779297 },
}

Locales = {
	["tr"] = {
		["Enter_Apartment"] = "~g~E ~w~- Apartmana Gir",
		["Apartment_Menu"] = "Apartmante Jaura",
		["Enter_Room"] = "Odana Gir",

		["Stash_No"] = "Depoyu Aç",
		["Stash"] = "~b~E ~w~- Depoyu Aç",

		["Exit_No"] = "Evden Çık",
		["Exit"] = "~r~E ~w~- Evden Çık",
	},
}

function _U(str, ...)  -- Translate string

	if Locales[C.Locale] ~= nil then

		if Locales[C.Locale][str] ~= nil then
			return string.format(Locales[C.Locale][str], ...)
		else
			return '[' .. C.Locale .. '][' .. str .. '] bulunamadı!'
		end

	else
		return '[' .. C.Locale .. '] böyle bir lokal dosyası yok!'
	end

end

