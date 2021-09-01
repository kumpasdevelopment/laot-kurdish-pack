LAOT = {}

LAOT.Home = {
    -- loc = { x = 152.8107, y = -1823.61, z = 27.868, h = 229.83488464355 }, -- Kapı giriş lokasyonu
    -- exitLoc = { x = 346.4631, y = -1012.69, z = -99.19, h = 182.87237548828 }, -- Çıkış lokasyonu
    markerType = 20, -- Satıcı marker tipi
    markerLoc = { x = 3259.643, y = -180.605, z = 21.552, h = 54.815788269043 }, -- Satıcı markerı
    bodyguardModel = "a_m_y_business_03",
    bodyguards = { -- Koruma ayarları
        [1] = { id = 1, x = 1567.414, y = -2174.68, z = 76.543, h = 23.134965896606 },
    },
    NPC = { -- Satıcı NPC ayarları
        hash = "a_m_m_og_boss_01",
        coords = { x = 3259.076, y = -180.242, z = 20.70, h = 242.2409362793 },
    },
    DriveTo = { -- Siparişi getirecek ped
        spawnLoc = { x = 161.4931, y = -1813.97, z = 28.410, h = 46.154289245605 },
        carHash = "rumpo3",
        pedHash = "a_m_m_afriamer_01",
        pedSpawnLoc = { x = 169.8995, y = -1811.24, z = 28.789, h = 140.47340393066 }
    },
}


local seconds = 1000
local minutes = 60 * seconds

LAOT.items = { -- Satıcı içindeki itemler
    [1] = { id = 1, type = nil, item = "WEAPON_PISTOL", label = "Kaçak Tabanca", price = 48000, waitMSRandom = 60 * seconds, waitMSRandom2 = 120 * seconds }, 
    [2] = { id = 2, type = "slider", item = "laot_tohum", label = "Esrar Tohumu", price = 350, waitMSRandom = 40 * seconds, waitMSRandom2 = 70 * seconds, min = 1, max = 16 }, 
    [3] = { id = 3, type = "slider", item = "weed", label = "Kaçak Cigara", price = 150, waitMSRandom = 20 * seconds, waitMSRandom2 = 60 * seconds, min = 1, max = 5 }, 
    [4] = { id = 4, type = nil, item = "thermite", label = "Thermite", price = 5950, waitMSRandom = 40 * seconds, waitMSRandom2 = 70 * seconds }, 
    [5] = { id = 5, type = nil, item = "susturucu", label = "Susturucu", price = 2500, waitMSRandom = 30 * seconds, waitMSRandom2 = 45 * seconds }, 
    [6] = { id = 6, type = nil, item = "fener", label = "Silah Feneri", price = 1850, waitMSRandom = 30 * seconds, waitMSRandom2 = 45 * seconds }, 
    [7] = { id = 7, type = nil, item = "durbun", label = "Silah Dürbünü", price = 10000, waitMSRandom = 45 * seconds, waitMSRandom2 = 60 * seconds }, 
    [8] = { id = 8, type = nil, item = "WEAPON_HEAVYPISTOL", label = "Kaçak Heavy Pistol", price = 94000, waitMSRandom = 60 * seconds, waitMSRandom2 = 120 * seconds }, 
    [9] = { id = 9, type = nil, item = "WEAPON_SNSPISTOL", label = "Kaçak SNS Pistol", price = 34000, waitMSRandom = 60 * seconds, waitMSRandom2 = 120 * seconds }, 
    [10] = { id = 10, type = nil, item = "HeavyArmor", label = "Ağır Zırh", price = 3000, waitMSRandom = 10 * seconds, waitMSRandom2 = 12 * seconds },
   -- [11] = { id = 11, type = nil, item = "WEAPON_MACHINEPISTOL", label = "Makineli Tabanca TEC9", price = 140000, waitMSRandom = 60 * seconds, waitMSRandom2 = 80 * seconds },

    -- [3] = { id = 1, type = nil, item = "WEAPON_PISTOL", label = "Kaçak Tabanca", price = 18500, waitMS = 6 * seconds },
}

l = {
    ['enter'] = '~w~[~g~E~w~] Eve Gir',
    ['talk'] = '~w~[~r~E~w~] Gergin Gorusunlu Adam',
    ['success'] = '~r~SATICI: ~w~Al bakalım siparişini aslan parçası.\n',
    ['failure'] = '~r~SATICI: ~w~Bu para ne lan orospu evladı! Taşak mı geçiyosun?',
    ['order_rised'] = '~b~TELEFONUNA MESAJ:\n\n~w~Siparişin ayağına geliyor...\n~r~Gelince arkasına geç ve bagajından teslimatını al!'
}
