C = {}

C.version = 1.0
C.Locale = 'tr'

C.Jobs = {
    ["orange"] = {
        ["name"] = "orange",
        ["label"] = "Portakal",
        ["coords"] = {
            {x = 1934.474, y = 4869.289, z = 46.933, h = 113.23634338379},
            {x = 1933.414, y = 4870.203, z = 46.959, h = 44.396816253662}, 
            {x = 1931.387, y = 4872.226, z = 46.985, h = 18.630479812622},     
            {x = 1929.609, y = 4874.151, z = 46.982, h = 51.477382659912},

            {x = 1928.095, y = 4873.085, z = 46.929, h = 226.64685058594},
            {x = 1929.433, y = 4871.819, z = 46.932, h = 224.18395996094},
            {x = 1930.951, y = 4870.525, z = 46.957, h = 227.49624633789},
            {x = 1933.387, y = 4867.651, z = 46.951, h = 227.54277038574}
        },
        ["stop"] = 8000,
        ["count"] = 1, -- Kaç adet verecek?
        ["anim"] = {
            ["dict"] = "random@mugging4",
            ["name"] = "struggle_loop_b_thief",
        },
    },
    ["domates"] = {
        ["name"] = "domates",
        ["label"] = "Domates",
        ["coords"] = {
            {x = 706.9710, y = 6468.446, z = 30.420, h = 231.00534057617},
            {x = 714.6986, y = 6469.180, z = 29.708, h = 81.419174194336},
            {x = 711.2349, y = 6474.257, z = 29.261, h = 38.081314086914},
            {x = 703.6701, y = 6472.673, z = 29.948, h = 116.88928222656},
            {x = 702.7828, y = 6464.450, z = 30.616, h = 192.53173828125},
            {x = 710.7714, y = 6462.367, z = 30.583, h = 258.9873046875},
            {x = 717.2108, y = 6465.189, z = 30.290, h = 302.76928710938},
            {x = 720.3830, y = 6471.264, z = 29.231, h = 336.53176879883},
            {x = 725.2246, y = 6464.415, z = 30.723, h = 208.80030822754},
            {x = 723.1754, y = 6457.770, z = 31.142, h = 162.2827911377},
        },
        ["stop"] = 5000,
        ["count"] = 1, -- Kaç adet verecek?
        ["anim"] = {
            ["dict"] = "amb@world_human_gardener_plant@male@idle_a",
            ["name"] = "idle_b",
        },
    },
}

Locales = {
    ["tr"] = {
        ["press_E_to_pickup"] = "toplamak için ~INPUT_PICKUP~ bas.",
        ["pickup"] = " topladın.",
        ["collecting"] = "Topluyorsun...",
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
