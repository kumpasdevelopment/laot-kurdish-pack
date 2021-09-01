-- Şans faktörü nasıl işler?
--[[

    1 veya 100 arası bir değer girin.
        Rastgele seçecektir.
                                - laot

--]]

Search = {
    [1] = {
        ID = 1,
        ["label"] = "Sandık",
        ["coords"] = json.decode('{"z":2.5,"y":1.33868212,"x":-9.084908691,"h":2.2633972168}'),
        ["searched"] = false,

        ["Items"] = {
            [1] = { i = "cash", label = "Para", amount = math.random(200, 480), chance = 30 },
            [2] = { i = "laot_tohum", label = "Esrar Tohumu", amount = math.random(1, 3), chance = 25 },
            [3] = { i = "secure4", label = "Kuyumcu Kartı", amount = 1, chance = 15 },
            [4] = { i = "securitycardsbank", label = "Güvenlik Kartı", amount = 1, chance = 15 },
            [5] = { i = "rolex", label = "Rolex", amount = math.random(1,2), chance = 18 },
            [6] = { i = "laptop", label = "Dizüstü Bilgisayar", amount = 1, chance = 8 },
        },
    },
    [2] = {
        ID = 2,
        ["label"] = "Yatak Altı",
        ["coords"] = json.decode('{"z":2.0,"y":-1.6434,"x":-6.7085,"h":2.2633972168}'),
        ["searched"] = false,

        ["Items"] = {
            [1] = { i = "cash", label = "Para", amount = math.random(100, 180), chance = 35 },
            --[2] = { i = "WEAPON_PISTOL", label = "Tabanca", amount = 1, chance = 8 },
            [2] = { i = "laot_tohum", label = "Esrar Tohumu", amount = math.random(1, 3), chance = 10 },
            [3] = { i = "secure4", label = "Kuyumcu Kartı", amount = 1, chance = 15 },
            [4] = { i = "wallet2", label = "Deri Cüzdan", amount = 1, chance = 16 },
        },
    },
    [3] = {
        ID = 3,
        ["label"] = "Dolap",
        ["coords"] = json.decode('{"z":2.0,"y":6.4798828125,"x":1.95,"h":2.2633972168}'),
        ["searched"] = false,

        ["Items"] = {
            [1] = { i = "cash", label = "Para", amount = math.random(20, 50), chance = 23 },
            [2] = { i = "sackurutma", label = "Saç Kurutma Makinesi", amount = 1, chance = 29 },
            [3] = { i = "kablo", label = "Gereksiz Kablo", amount = math.random(1, 5), chance = 26 },
            [4] = { i = "bospaket", label = "Boş Paket", amount = math.random(1,2), chance = 31 },
            [5] = { i = "cash", label = "Para", amount = math.random(50,150), chance = 12 },
            [6] = { i = "boscanta", label = "Çanta", amount = 1, chance = 21 },
        },
    },
    [4] = {
        ID = 4,
        ["label"] = "Buzdolabı",
        ["coords"] = json.decode('{"z":2.0,"y":3.4798828125,"x":-1.5,"h":2.2633972168}'),
        ["searched"] = false,

        ["Items"] = {
            [1] = { i = "donut", label = "Donut", amount = math.random(1,3), chance = 35 },
            [2] = { i = "cola", label = "Coca Cola", amount = math.random(1,2), chance = 25 },
            [3] = { i = "icetea", label = "Ice Tea", amount = 1, chance = 24 },
        },
    },
    [5] = {
        ID = 5,
        ["label"] = "Kolye Kutusu",
        ["coords"] = json.decode('{"z":3.5,"y":-0.290,"x":-2.499,"h":2.2633972168}'),
        ["searched"] = false,

        ["Items"] = {
            [1] = { i = "rolex", label = "Rolex Saat", amount = math.random(1,2), chance = 10 },
            [2] = { i = "cash", label = "Para", amount = math.random(200, 320), chance = 28 },
            [3] = { i = "diamond", label = "Elmas", amount = 1, chance = 20 },
            [4] = { i = "gold", label = "Altın", amount = math.random(1,2), chance = 24 },
        },
    },
    [6] = {
        ID = 6,
        ["label"] = "Masa",
        ["coords"] = json.decode('{"z":1.9,"y":-1.288,"x":1.286,"h":2.2633972168}'),
        ["searched"] = false,

        ["Items"] = {
            [1] = { i = "cash", label = "Para", amount = math.random(20, 50), chance = 27 },
            [2] = { i = "bospaket", label = "Boş Paket", amount = math.random(1,2), chance = 30 },
            [3] = { i = "cash", label = "Para", amount = math.random(50,150), chance = 14 },
            [4] = { i = "boscanta", label = "Çanta", amount = 1, chance = 26 },
            [5] = { i = "kacaksigara", label = "Kaçak Sigara", amount = 1, chance = 23 },
        },
    },
}