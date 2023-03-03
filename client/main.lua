QBCore = exports['qb-core']:GetCoreObject()

CanTakeDailyMission = false 
CanTakeHourlyMission = false 


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('mst-mission:server:CheckMission', function(data)
        CanTakeDailyMission = data
    end, "dailymission")
    QBCore.Functions.TriggerCallback('mst-mission:server:CheckMission', function(data)
        CanTakeHourlyMission = data
    end, "hourlymission")
end)



RegisterNetEvent("mst-mission:client:TakeDailyMission", function()
    print(QBCore.Functions.GetPlayerData().metadata["dailymission"])
    if QBCore.Functions.GetPlayerData().metadata["dailymission"] == 0 or not QBCore.Functions.GetPlayerData().metadata["dailymission"] then  
        QBCore.Functions.TriggerCallback('mst-mission:server:CheckMission', function(data)
            if data then 
                local Random_Mission = math.random(1, #Config.Daily_Mission)
                TriggerServerEvent("mst-mission:server:TakeDailyMission", Random_Mission)
                TriggerEvent("mst-mission:client:CheckProgress", "dailymission")
            end
        end, "dailymission")
    else 
        QBCore.Functions.Notify("Bạn đã nhận một nhiệm vụ rồi, bạn có thể kiểm tra tiến độ")
    end 
end)

RegisterNetEvent("mst-mission:client:TakeHourlyMission", function()
    if QBCore.Functions.GetPlayerData().metadata["hourlymission"] == 0 or not QBCore.Functions.GetPlayerData().metadata["hourlymission"] then
        QBCore.Functions.TriggerCallback('mst-mission:server:CheckMission', function(data)
            if data then 
                local Random_Mission = math.random(1, #Config.Hourly_Mission)
                TriggerServerEvent("mst-mission:server:TakeHourlyMission", Random_Mission)
                TriggerEvent("mst-mission:client:CheckProgress", "hourlymission")
            end
        end, "hourlymission")
    else 
        QBCore.Functions.Notify("Bạn đã nhận một nhiệm vụ rồi, bạn có thể kiểm tra tiến độ")
    end 
end)


RegisterNetEvent("mst-mission:client:TakeHiddenMission", function(mission)
    local ID = Config.Hidden_Mission[mission].id
    if not QBCore.Functions.GetPlayerData().metadata[ID] then
        if not QBCore.Functions.GetPlayerData().metadata[ID.."_done"] then 
            QBCore.Functions.Notify("Bạn đã nhận được nhiệm vụ hàng giờ mang tên "..Config.Hidden_Mission[mission].name..", nhiệm vụ này yêu cầu bạn "..Config.Hidden_Mission[mission].label..".")
            TriggerServerEvent("mst-mission:server:TakeHiddenMission", ID)
            TriggerEvent("mst-mission:client:CheckHiddenProgress", mission)
        else 
            QBCore.Functions.Notify("Bạn đã hoàn thành nhiệm vụ này rồi.")
        end 
    else 
        QBCore.Functions.Notify("Bạn đã nhận nhiệm vụ này rồi, hãy cố gắng hoàn thành nó")
    end 
end)

RegisterNetEvent("mst-mission:client:CheckProgress", function(type)
    if type == "dailymission" then 
        if Config.Daily_Mission[QBCore.Functions.GetPlayerData().metadata["dailymission"]] then 
            TriggerServerEvent("mst-mission:server:CheckProgress", "dailymission", Config.Daily_Mission[QBCore.Functions.GetPlayerData().metadata["dailymission"]].required, Config.Daily_Mission[QBCore.Functions.GetPlayerData().metadata["dailymission"]].reward_item, Config.Daily_Mission[QBCore.Functions.GetPlayerData().metadata["dailymission"]].reward_money)
        end 
    else 
        if Config.Hourly_Mission[QBCore.Functions.GetPlayerData().metadata["hourlymission"]] then 
            TriggerServerEvent("mst-mission:server:CheckProgress", "hourlymission", Config.Hourly_Mission[QBCore.Functions.GetPlayerData().metadata["hourlymission"]].required, Config.Hourly_Mission[QBCore.Functions.GetPlayerData().metadata["hourlymission"]].reward_item, Config.Hourly_Mission[QBCore.Functions.GetPlayerData().metadata["hourlymission"]].reward_money)
        end 
    end 
end)

RegisterNetEvent("mst-mission:client:CheckHiddenProgress", function(key)
    if Config.Hidden_Mission[key] then
        if QBCore.Functions.GetPlayerData().metadata[Config.Hidden_Mission[key].id] then
            TriggerServerEvent("mst-mission:server:CheckProgress", Config.Hidden_Mission[key].id, Config.Hidden_Mission[key].required, Config.Hidden_Mission[key].reward_item, Config.Hidden_Mission[key].reward_money)
        end
    end 
end)