-- made by laot#0101
LAOT = {}

CASINO = {
    ["item"] = "cchip", -- Casino içinde kullanılan çip ismi
    ["price"] = 1, -- Çip tane ücreti
    ["NPC"] = { -- NPC ayarları
        [1] = {
            ["id"] = 1,
            ["hash"] = "s_f_y_casino_01", -- Hash adı | https://docs.fivem.net/docs/game-references/ped-models/
            ["coords"] = { x = 1117.481, y = 220.8248, z = -50.43, h = 41.122989654541 }, -- Konumu
        },
        [2] = {
            ["id"] = 2,
            ["hash"] = "s_m_y_casino_01", -- Hash adı | https://docs.fivem.net/docs/game-references/ped-models/
            ["coords"] = { x = 1117.493, y = 219.1684, z = -50.43, h = 130.60911560059 }, -- Konumu
        },
    },
    ["Markers"] = { -- Markerlar
        ["buy"] = { -- Alma yeri
            ["text"] = "~w~[~g~E~w~] Chip Satin Al",
            ["coords"] = vector3(1116.506, 218.1021, -49.43),
        },
        ["sell"] = { -- Satma yeri
            ["text"] = "~w~[~r~E~w~] Chip Bozdur",
            ["coords"] = vector3(1116.203, 221.8360, -49.43),
        },
    },
}