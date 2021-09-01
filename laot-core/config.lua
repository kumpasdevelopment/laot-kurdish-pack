LAOT = {}

LAOT.adminMenu = false -- Laot-core admin Menu
LAOT.adminGrades = {
    [0] = { player_blips = false, player_names = false, kick = false, freeze = false, spectate = true, repair = false },
    [1] = { player_blips = false, player_names = true, kick = true, freeze = true, spectate = true, repair = true },
    [2] = { player_blips = true, player_names = true, kick = true, freeze = true, spectate = true, repair = true },
}

LAOT.adminSettings = {
    menuKey = 11,
    noclipKey = 121
}

LAOT.admins = { -- Discord ID koyun.
}

-- #2

Blips = {
    ["1"] = {
        title="Sahil Satıcısı", colour=29, id=59, scale = 0.75, x = -1840.03, y = -1234.14, z = 13.017
    },
    --["2"] = {
    --    title="Diamond Casino", colour=57, id=617, scale = 1.0, x = 918.8554, y = 51.84082, z = 80.898
    --},
    --["3"] = {
    --    title="Kasap", colour=1, id=273, scale = 0.5, x = 968.8758, y = -2107.93, z = 31.475
    --},
    --["4"] = {
    --    title="Avcılık Kulübü", colour=0, id=58, scale = 0.7, x = -769.075, y = 5595.274, z = 33.485
    --},
    ["5"] = {
        title="Portakal Tarlası", colour=5, id=285, scale = 0.6, x = 1936.496, y = 4866.515, z = 46.918
    },
    ["6"] = {
        title="Domates Tarlası", colour=1, id=285, scale = 0.6, x = 706.9710, y = 6468.446, z = 30.420
    },
}

LAOT.Hacker = {}

LAOT.giyin = true -- /giyin
LAOT.deathToVehicle = true -- Ölüyü araca bindirme scripti
LAOT.removeCashAndBank = true
LAOT.crouch = true

l = {
    ['player_blips'] = 'Oyuncu Blipleri',
    ['player_names'] = 'Oyuncu İsimleri',
    ['players'] = 'Aktif Oyuncular',
    ['spectate_player'] = 'Kişiyi İzle',
    ['kick_player'] = 'Kişiyi Oyundan At',
    ['freeze_player'] = 'Kişiyi Dondur',
    ['specText'] = '~INPUT_CURSOR_SCROLL_UP~ ~INPUT_CURSOR_SCROLL_DOWN~ Yakınlaş / Uzaklaştır',
    ['repair'] = 'Arabayı Tamir Et',
}
