Locales = { -- Laot dil dosyaları
    ["tr"] = {
		["Ready"] = "Hazır!",
		["Cocaine_Text"] = "~g~[E] ~w~- Kokain Isle",
		["Pick"] = "~g~[E] ~w~- Topla",
    },
    ["en"] = {
        ["Ready"] = "Ready!",
    },
}

-- Burdan sonrasını değiştirmeyin / Don't change after this.

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