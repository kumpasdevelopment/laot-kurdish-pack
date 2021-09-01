RegisterNetEvent('laot-core:HackerUse')
AddEventHandler('laot-core:HackerUse', function()
    TriggerEvent("utk_fingerprint:Start", 2, 2, 5)
end)

bankAdd = function()
    TriggerServerEvent("laot-core:HackAddBank")
end