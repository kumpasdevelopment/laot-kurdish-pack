ESX = nil

local steamid  = "BOS"
local license  = "BOS"
local discord  = "BOS"
local xbl      = "BOS"
local liveid   = "BOS"
local ip       = "BOS"

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    for k,v in pairs(GetPlayerIdentifiers(xPlayer))do
       -- print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
      end
      laotChar = GetCharacterName(xPlayer)
      LOG(LAOT.Webhook.GIRISCIKIS, "**LOG TÜRÜ**\nGiriş\n\n**OYUNCU**\n".. laotChar .." [".. xPlayer .."]\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."", 3066993)
end)


AddEventHandler('playerDropped', function(reason) 
	local color = 16711680
	if string.match(reason, "Kicked") or string.match(reason, "Banned") then
		color = 16007897
    end
    for k,v in pairs(GetPlayerIdentifiers(source))do
        --print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    laotChar = GetCharacterName(source)
    LOG(LAOT.Webhook.GIRISCIKIS, "**LOG TÜRÜ**\nÇıkış / Ban / Kick\n\n**OYUNCU**\n".. steamid .."\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."\n\n**SEBEP**\n".. reason .."", color)
end)

function GetIDFromSource(Type, ID)
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

RegisterNetEvent('laot-logs:MoveToEmpty')
AddEventHandler('laot-logs:MoveToEmpty', function(oyuncu, data)
    for k,v in pairs(GetPlayerIdentifiers(oyuncu))do
       -- print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    laotChar = GetCharacterName(oyuncu)
    LOG(LAOT.Webhook.ENVANTER, "**LOG TÜRÜ**\nYere eşya atma/alma - slot değişikliği\n\n**OYUNCU**\n".. laotChar .." [".. oyuncu .."]\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."\n\n**İTEM**\n".. data.originItem.qty .." adet ".. data.originItem.label .."\n\n**İLK KONUM**\n".. data.originOwner .." - Slot ".. data.originSlot .."\n\n**HEDEF KONUM**\n".. data.destinationOwner .." - Slot ".. data.destinationSlot .."", 15158332)
end)

RegisterNetEvent('laot-logs:EmptySplitStack')
AddEventHandler('laot-logs:EmptySplitStack', function(oyuncu, data)
    for k,v in pairs(GetPlayerIdentifiers(oyuncu))do
       -- print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    laotChar = GetCharacterName(oyuncu)
    data.originItem.LAOTqty = data.originItem.qty + data.moveQty
    LOG(LAOT.Webhook.ENVANTER, "**LOG TÜRÜ**\nİtemler ayrıştırıldı\n\n**OYUNCU**\n".. laotChar .." [".. oyuncu .."]\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."\n\n**İTEM**\n".. data.originItem.LAOTqty .." adet ".. data.originItem.label .." içinden ".. data.moveQty .." ayrıştırıldı\n\n**İLK KONUM**\n".. data.originOwner .." - Slot ".. data.originSlot .."\n\n**HEDEF KONUM**\n".. data.destinationOwner .." - Slot ".. data.destinationSlot .."", 3447003)
end)

RegisterNetEvent('laot-logs:SwapItems')
AddEventHandler('laot-logs:SwapItems', function(oyuncu, data)
    for k,v in pairs(GetPlayerIdentifiers(oyuncu))do
       -- print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    laotChar = GetCharacterName(oyuncu)
    LOG(LAOT.Webhook.ENVANTER, "**LOG TÜRÜ**\nİtemler değiştirildi (Swap)\n\n**OYUNCU**\n".. laotChar .." [".. oyuncu .."]\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."\n\n**İTEM**\n".. data.originItem.qty .." adet ".. data.originItem.label .." ile ".. data.destinationItem.qty .." adet ".. data.destinationItem.label .." değiştirildi.\n\n**İLK KONUM**\n".. data.originOwner .." - Slot ".. data.originSlot .."\n\n**HEDEF KONUM**\n".. data.destinationOwner .." - Slot ".. data.destinationSlot .."", 3066993)
end)

RegisterNetEvent('laot-logs:TopoffStack')
AddEventHandler('laot-logs:TopoffStack', function(oyuncu, data)
    for k,v in pairs(GetPlayerIdentifiers(oyuncu))do
      --  print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    laotChar = GetCharacterName(oyuncu)
    LOG(LAOT.Webhook.ENVANTER, "**LOG TÜRÜ**\nİtemler birleştirildi (Topoff Stack)\n\n**OYUNCU**\n".. laotChar .." [".. oyuncu .."]\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."\n\n**İTEM**\n".. data.originItem.qty .." adet ".. data.originItem.label .." içinden ".. data.moveQty .." ayrıştırıldı\n\n**İLK KONUM**\n".. data.originOwner .." - Slot ".. data.originSlot .."\n\n**HEDEF KONUM**\n".. data.destinationOwner .." - Slot ".. data.destinationSlot .."", 3426654)
end)

RegisterNetEvent('laot-logs:SplitStack')
AddEventHandler('laot-logs:SplitStack', function(oyuncu, data)
    for k,v in pairs(GetPlayerIdentifiers(oyuncu))do
       -- print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    laotChar = GetCharacterName(oyuncu)
    LOG(LAOT.Webhook.ENVANTER, "**LOG TÜRÜ**\nİtemler birleştirildi (Split stack)\n\n**OYUNCU**\n".. laotChar .." [".. oyuncu .."]\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."\n\n**İTEM**\n".. data.originItem.qty .." adet ".. data.originItem.label .." eşyası birleştirilerek ".. data.destinationItem.qty .." adet oldu.\n\n**İLK KONUM**\n".. data.originOwner .." - Slot ".. data.originSlot .."\n\n**HEDEF KONUM**\n".. data.destinationOwner .." - Slot ".. data.destinationSlot .."", 3426654)
end)

RegisterNetEvent('laot-logs:CombineStack')
AddEventHandler('laot-logs:CombineStack', function(oyuncu, data)
    for k,v in pairs(GetPlayerIdentifiers(oyuncu)) do
        --print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    laotChar = GetCharacterName(oyuncu)
    LOG(LAOT.Webhook.ENVANTER, "**LOG TÜRÜ**\nİtemler birleştirildi (Combine stack)\n\n**OYUNCU**\n".. laotChar .." [".. oyuncu .."]\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."\n\n**İTEM**\n".. data.originQty .." adet ".. data.originItem.label .." eşyası birleştirilerek ".. data.destinationQty .." adet oldu.\n\n**İLK KONUM**\n".. data.originOwner .." - Slot ".. data.originSlot .."\n\n**HEDEF KONUM**\n".. data.destinationOwner .." - Slot ".. data.destinationSlot .."", 3426654)
end)

AddEventHandler('chatMessage', function(source, name, message)
    laotChar = GetCharacterName(source)
    LOG(LAOT.Webhook.CHAT, "**LOG TÜRÜ**\nChat mesajı.\n\n**OYUNCU**\n".. laotChar .." [".. source .."]\n".. name .."\n\n**MESAJ**\n".. message .."", 15105570)
end)

RegisterNetEvent("laot-logs:emote")
AddEventHandler("laot-logs:emote", function(oyuncu, tur, text)
  laotChar = GetCharacterName(oyuncu)
  LOG(LAOT.Webhook.CHAT, "**LOG TÜRÜ**\nEmote kullanımı.\n\n**OYUNCU**\n".. laotChar .." [".. oyuncu .."]\n\n**EMOTE METİNİ**\n/".. tur .." ".. text .."", 15844367)
end)

RegisterNetEvent('playerDied')
AddEventHandler('playerDied', function(oyuncu, msg, killer)
    local Lvictim = GetCharacterName(oyuncu)
    local Lkiller = GetCharacterName(killer)
    LOG(LAOT.Webhook.OLUM, "**LOG TÜRÜ**\nBir oyuncu öldürüldü.\n\n**ÖLDÜRÜLEN OYUNCU**\n".. Lvictim .." [".. oyuncu .."]\n\n**ÖLDÜREN OYUNCU**\n".. Lkiller .." [".. killer .."]\n\n**ÖLDÜRME AÇIKLAMASI**\n".. msg .."", 10038562)
end)

RegisterNetEvent('playerDied2')
AddEventHandler('playerDied2', function(oyuncu, msg)
    local Lvictim = GetCharacterName(oyuncu)
    LOG(LAOT.Webhook.OLUM, "**LOG TÜRÜ**\nBir oyuncu öldü.\n\n**ÖLEN OYUNCU**\n".. Lvictim .." [".. oyuncu .."]\n\n**ÖLME SEBEBİ**\n".. msg .."", 16007897)
end)

RegisterNetEvent('laot-logs:ItemUse')
AddEventHandler('laot-logs:ItemUse', function(oyuncu, data)
    for k,v in pairs(GetPlayerIdentifiers(oyuncu))do
       -- print(v)
            
          if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
          elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
          elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
          elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
          elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
          elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
          end
    end
    laotChar = GetCharacterName(oyuncu)
    LOG(LAOT.Webhook.ENVANTER, "**LOG TÜRÜ**\nİtem kullanma\n\n**OYUNCU**\n".. laotChar .." [".. oyuncu .."]\n".. steamid .."\n".. license .."\n".. discord .."\n".. liveid .."\n".. ip .."\n\n**İTEM**\n".. data.qty .." adet "..data.item.itemId .."\n\n**MESAJ**\n".. data.message .."", 15105570)
end)

function LOG(webhook, description, color)
	date = os.date('%m-%d-%Y %H:%M:%S', os.time())
	local connect = {
		  {
			  ["color"] = color,
			  ["title"] = "",
			  ["description"] = description,
			  ["footer"] = {
				  ["text"] = "".. date .." tarihinde istendi. M4DE BY LAOT",
			  },
		  }
	  }
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "", embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

function GetCharacterName(source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = GetPlayerIdentifiers(source)[1]
	})

	if result[1] and result[1].firstname and result[1].lastname then
		return ('%s %s'):format(result[1].firstname, result[1].lastname)
	end
end