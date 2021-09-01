Config = {}

Config.dev = false -- Değiştirmeyin!
Config.inventory = "disc" -- esx/disc inventory türü
Config.location = { x = 2235.762, y = 5576.571, z = 53.191 } -- Esrar yazısı ve mesafe ölçer konumu
Config.maxdistance = 5 -- Maxsimum esrar ekebilme mesafesi
Config.waitAfterQuestion = 20000 -- 5000 = 5 saniye tohum soruları arasındaki MS
Config.locProcess = { x = 1095.380, y = -3195.79, z = -38.99 }

Config.giveMath = {
    least = 1, max = 4 -- Tohumdan çıkar işlenmiş esrar / least = en az, max = en fazla
}

Config.giveMath2 = { -- İşlenmiş matematik hesabı
    ifor = 2, -- Kaç tanesine aşağıdaki kadar verilsin?
    ito = 1
}

Config.interior = {
    enter = { x = 2309.678, y = 4885.405, z = 40.808 }, -- Giriş kordinati
    exit = { x = 1088.552, y = -3187.74, z = -39.99 }, -- Çıkış kordinatı
    TP = { x = 1088.834, y = -3190.37, z = -39.99, h = 177.5258026123 }, -- İçeri taraf ışınlanma
    OUT = { x = 2307.896, y = 4887.311, z = 40.808, h = 42.630516052246 }, -- Dışarı taraf ışınlanma
}

Config.ped = {
    hash = "csb_prologuedriver", -- Hash isimi || https://docs.fivem.net/docs/game-references/ped-models/
    coords = { x = -1201.09, y = 3850.721, z = 488.89-15.0, h = 63.054508209229 },
    price = 420,
}

-- Locales
l = {
    ['buy_text'] = '~g~[~w~E~g~]~w~ Esrar Ekmeye Basla',
    ['disable_text'] = '~r~[~w~ESC~r~]~w~ Islemi Iptal Et',
    ['enter_interior'] = '~y~[~w~E~y~]~w~ Iceri Gir',
    ['exit_interior'] = '~r~[~w~E~r~]~w~ Disari Cik',
    ['proccess'] = '~y~[~w~E~y~]~w~ Isleme Yap',
    ['proccess_leave'] = '~r~[~w~E~r~]~w~ Islemeyi Durdur',
    ['client_text'] = '~r~[~w~E~r~]~w~ Gergin Görünüslü Alıcı',
    ['client_text_leave'] = '~y~[~w~E~y~]~w~ Satımı Iptal Et',
}