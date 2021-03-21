local MetricsAPIRequest = "https://api.kanersps.pw/em/metrics?uuid=" .. _UUID

function postMetrics()
    PerformHttpRequest(MetricsAPIRequest, function(eer, rText, headers) end, "POST", "", {
        startingCash = settings.defaultSettings['startingCash'],
        startingBank = settings.defaultSettings['startingBank'],
        enableRankDecorators = settings.defaultSettings['enableRankDecorators'],
        nativeMoneySystem = settings.defaultSettings['nativeMoneySystem']
        commandDelimeter = settings.defaultSettings['commandDelimeter'],
        enableLogging = settings.defaultSettings['enableLogging'],
        enableCustomData = settings.defaultSettings['enableCustomData']
        defaultDatabase = settings.defaultDatabase['defaultDatabase']]
    })
end

Citizen.CreateThread(function()
    while true do
        postMetrics()
        Citizen.Wait(3600000)
    end
end)