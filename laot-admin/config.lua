C = {}

C.version = 1.0
C.Locale = 'tr' -- Dil dosyası

C.MenuTxd = "shopui_title_sm_hangar"
C.AdminMenuKey = 207 -- Admin Menüsü Tuşu [PAGE DOWN] / 207
C.NoclipKey = 121 -- Noclip Menüsü Tuşu [INSERT] / 121

C.BanWebhook = true -- Biri ban atınca mesaj yollasın mı? [true/false]
C.BanWebhookURL = "" -- Webhook URL

C.AdminGrades = { -- Admin Seviyeleri ve Yetkileri
	[0] = {
		["spectate"] = true, ["freeze"] = false, ["kick"] = false, ["player_blips"] = false, ["player_names"] = false, ["repair"] = false, ["admin"] = false,
		["envanter"] = false, ["slay"] = false, ["ban"] = false, ["clear_area"] = true, ["noclip"] = false, ["rev"] = false, ["bring"] = true, ["skinmenu"] = false,
	},
	[1] = {
		["spectate"] = true, ["freeze"] = true, ["kick"] = true, ["player_blips"] = false, ["player_names"] = true, ["repair"] = true, ["admin"] = true,
		["envanter"] = false, ["slay"] = true, ["ban"] = true, ["clear_area"] = true, ["noclip"] = true, ["rev"] = true, ["bring"] = true, ["skinmenu"] = true,
	},
	[2] = {
		["spectate"] = true, ["freeze"] = true, ["kick"] = true, ["player_blips"] = true, ["player_names"] = true, ["repair"] = true, ["admin"] = true,
		["envanter"] = true, ["slay"] = true, ["ban"] = true, ["clear_area"] = true, ["noclip"] = true, ["rev"] = true, ["bring"] = true, ["skinmenu"] = true,
	}
}

C.Admins = { -- Discord ID kullanın.
}

Locales = { -- Dil Dosyaları
	["tr"] = {
		["Menu_Title"] = "",
		["Menu_SubTitle"] = "Ana Sayfa",
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

