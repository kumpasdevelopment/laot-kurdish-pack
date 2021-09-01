C = {}

C.version = 1.0
C.Locale = 'tr'

C.RobMS = 600000 -- Bir soygundan ne kadar sonra soygun yapabilsin?

C.MinimumPoliceCount = 1 -- Gereken polis sayısı
C.LockpickItem = 'lockpick' -- Maymuncuk itemi
C.RobHouses = { -- Soyulabilir evler
	[1] = { id=1, x = 1303.136, y = -527.636, z = 71.460, h = 342.64508056641 },
	[2] = { id=2, x = 1328.361, y = -536.063, z = 72.440, h = 254.04473876953 },
	[3] = { id=3, x = 1348.281, y = -546.949, z = 73.891, h = 335.72634887695 },
	[4] = { id=4, x = 1341.482, y = -597.271, z = 74.700, h = 50.41556930542 },
	[5] = { id=5, x = 1241.541, y = -566.212, z = 69.657, h = 133.3024597168 },
	[6] = { id=6, x = 1240.514, y = -601.638, z = 69.782, h = 91.958824157715 },
	[7] = { id=7, x = 1301.002, y = -574.167, z = 71.732, h = 169.20040893555 },
	[8] = { id=8, x = 1251.233, y = -515.560, z = 69.349, h = 77.49397277832 },
	[9] = { id=9, x = 1251.780, y = -494.192, z = 69.906, h = 77.11351776123 },
	[10] = { id=10, x = 1259.736, y = -479.934, z = 70.188, h = 121.50205230713 }
}

C.NPC = {
	["hash"] = "a_m_m_malibu_01",
	["coords"] = json.decode('{"z":2.1,"y":-1.070,"x":-7.02637,"h":270.49}'),
}

Locales = {
	["tr"] = {
		["Rob_House"] = "~r~E ~w~- Evi Maymuncukla",
		["Exit_House"] = "~r~E ~w~- Evden Çık",
		["You_Dont_Have_Lockpick"] = "Maymuncuğun yok!",
		["Not_Now"] = "Şu an gece değil!",
		["Lockpicking"] = "Evi maymuncukluyorsun...",
		["Nothing"] = "Hiç bir şey bulamadın!",
		["You_Cant"] = "Şu an soygun yapamazsın, beklemelisin!",
		["Police"] = "Yeterli polis yok!"
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

