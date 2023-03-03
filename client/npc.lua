

    -- CREATE NPCs -- 
Citizen.CreateThread(function()
    -- NPC DAILY 
    RequestModel(Config.Daily_NPC.ped)
    while not HasModelLoaded(Config.Daily_NPC.ped) do
        Citizen.Wait(1)
    end

    Daily_NPC =  CreatePed(4, Config.Daily_NPC.ped, Config.Daily_NPC.coords.x, Config.Daily_NPC.coords.y, Config.Daily_NPC.coords.z-0.5, 3374176, false, true)
    SetEntityHeading(Daily_NPC, Config.Daily_NPC.coords.w)
    FreezeEntityPosition(Daily_NPC, true)
    SetEntityInvincible(Daily_NPC, true)
    SetBlockingOfNonTemporaryEvents(Daily_NPC, true)



    -- NPC HOURLY 

    RequestModel(Config.Hourly_NPC.ped)
    while not HasModelLoaded(Config.Hourly_NPC.ped) do
        Citizen.Wait(1)
    end

    Hourly_NPC =  CreatePed(4, Config.Hourly_NPC.ped, Config.Hourly_NPC.coords.x, Config.Hourly_NPC.coords.y, Config.Hourly_NPC.coords.z-1, 3374176, false, true)
    SetEntityHeading(Hourly_NPC, Config.Hourly_NPC.coords.w)
    FreezeEntityPosition(Hourly_NPC, true)
    SetEntityInvincible(Hourly_NPC, true)
    SetBlockingOfNonTemporaryEvents(Hourly_NPC, true)




    -- NPC HIDDEN POINTS

    for k, v in pairs(Config.Hidden_Mission) do 
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do
            Citizen.Wait(1)
        end

        Hidden_NPC =  CreatePed(4, v.ped, v.coords.x, v.coords.y, v.coords.z-1, 3374176, false, true)
        SetEntityHeading(Hidden_NPC, v.coords.w)
        FreezeEntityPosition(Hidden_NPC, true)
        SetEntityInvincible(Hidden_NPC, true)
        SetBlockingOfNonTemporaryEvents(Hidden_NPC, true)


    end 
end)

local InDailyZone = false 
local InHourlyZone = false 
local InHiddenZone = false 
local CurrentHiddenZone = nil

CreateThread(function() 
    while true do 
        Wait(0)
        local Coords = GetEntityCoords(PlayerPedId())
        local DailyDistances = #( Coords - vector3(Config.Daily_NPC.coords.x, Config.Daily_NPC.coords.y, Config.Daily_NPC.coords.z))
        local HourlyDistances = #( Coords - vector3(Config.Hourly_NPC.coords.x, Config.Hourly_NPC.coords.y, Config.Hourly_NPC.coords.z))

        if DailyDistances < 2 then 
            InDailyZone = true 
            exports['qb-core']:DrawText("[E] - TALK", "left")
            if IsControlJustReleased(0, 38) then 
                TriggerEvent("mst-mission:client:DailyMissionMenu")
            end 
        else 
            if InDailyZone then 
                exports['qb-core']:HideText()
            end 
            InDailyZone = false 
        end 

        if HourlyDistances < 2 then 
            InHourlyZone = true 
            exports['qb-core']:DrawText("[E] - TALK", "left")
            if IsControlJustReleased(0, 38) then 
                TriggerEvent("mst-mission:client:HourlyMissionMenu")
            end 
        else 
            if InHourlyZone then 
                exports['qb-core']:HideText()
            end 
            InHourlyZone = false 
        end

    end 
end)