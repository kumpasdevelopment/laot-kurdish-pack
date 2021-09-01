Citizen.CreateThread(function()
    loadBans()
end)

banData = {}
deferConnection = false

loadBans = function()
    print("loading bans.")
    banData = {}
    MySQL.Async.fetchAll(
		'SELECT * FROM laot_bans',
		{},
		function (data)

		  for i=1, #data, 1 do
			table.insert(banData, {
                license    = data[i].license,
				identifier = data[i].identifier,
				discord    = data[i].discord,
				reason     = data[i].reason,
				expiration = data[i].expiration
			  })
		  end
    end)
end

log = function(playerName, text)
    local connect = {
            {
                ["color"] = color,
                ["title"] = "**".. playerName .."**",
                ["description"] = text,
                ["footer"] = {
                    ["text"] = "",
                },
            }
        }
    PerformHttpRequest(C.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "", embeds = connect}), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(120000)
        loadBans()
    end
end)

local function laotPlayerCheck(name, setKickReason, deferrals)
    deferrals.defer()
    identifiers = GetPlayerIdentifiers(source)
    local hex = identifiers[1]
    local license = identifiers[2]

    print(license)
    local discord = identifiers[3]

	if hex ~= nil and discord ~= nil then
        for k, v in pairs(C.Blacklist) do
            if hex == v then
                deferrals.done(Locales[C.Locale]["blacklist"])
                log(name, "Karalistede olan oyuncu giriş yapmaya çalıştı.")
            else
                deferConnection = true
            end
        end

        for i = 1, #banData, 1 do

            if license == banData[i].license or hex == banData[i].identifier or discord == banData[i].discord then
                print(banData[i].expiration)
                print(os.date("%d%m%Y"))
                if banData[i].expiration > os.date("%d%m%Y") then
                    deferrals.done('Sunucudan uzaklaştırılmış oyuncusun, sebep: '.. banData[i].reason)
                    log(name, "**Bu kişi sunucudan yasaklı.**\n\nSebep: " .. banData[i].reason .. "\nSüre: ".. banData[i].expiration)
                    deferConnection = false
                end
            else
                deferConnection = true
            end

        end

        Citizen.Wait(100)
        if deferConnection then
            deferrals.done()
        end
	end
  
end

AddEventHandler("playerConnecting", laotPlayerCheck)