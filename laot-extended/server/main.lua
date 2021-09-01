LAOT = {}

AddEventHandler('laot:getSharedObject', function(cb)
	cb(LAOT)
end)

function getSharedObject()
	return LAOT
end

RegisterNetEvent("laot-extended:ServerDiscordID")
AddEventHandler("laot-extended:ServerDiscordID", function(source)
    local src = source
    local discordIdentifier

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordIdentifier = tonumber(split(v, ":")[2])
            --print(discordIdentifier)
            TriggerClientEvent("laot-extended:ClientDiscordID", src, discordIdentifier)
        end
    end
end)

RegisterNetEvent("laot-extended:DebugPrint")
AddEventHandler("laot-extended:DebugPrint", function(text)
    print("^1LAOT: ".. text .."")
end)

function split(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
       if s ~= 1 or cap ~= "" then
          table.insert(t,cap)
       end
       last_end = e+1
       s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
       cap = str:sub(last_end)
       table.insert(t, cap)
    end
    return t
 end