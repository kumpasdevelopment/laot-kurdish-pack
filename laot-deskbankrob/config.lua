C = {}

C.version = 1.0
C.Locale = 'tr'

C.CopsBank = 0 -- Gerekli polis sayısı*
C.WaitMS = 5000 -- Bir soygundan ne kadar sonra soygun yapılabilecek?

C.BankLocation = {x = 309.2829, y = -279.484, z = 54.164} -- Banka lokasyonu
C.Locations = {
	["desk"] = {x = 309.2829, y = -279.484, z = 54.164, h = 254.10961914062, dh = -110.13402557373047, locale = "desk_rob"}, -- Vezne soygunu kordinatları
	["bank"] = {x = 311.0509, y = -284.033, z = 54.164, h = 241.17642211914, locale = "bank_rob"}, -- Banka soygunu kordinatları
}
C.AnimCoords = {
    {x = 146.61, y = -1046.0, z = 28.35, h = 245.44},
    {x = 310.98, y = -284.4, z = 53.20, h = 248.34},
    {x = -354.1, y = -55.24, z = 48.10, h = 243.42},
    {x = -1210.96, y = -336.68, z = 36.70, h = 293.14}, 
    {x = -2956.68, y = 481.34, z = 14.7, h = 352.26} 
}

Locales = {
	["tr"] = {
		["desk_rob"] = "~r~E ~w~- Vezneyi Soy",
		["bank_rob"] = "~o~E ~w~- Bankayı Soy"
	}
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

