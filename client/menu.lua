RegisterNetEvent("mst-mission:client:DailyMissionMenu", function()
    local DailyMissionMenu = {
        {
            header = "📒 Daily Missions",
            isMenuHeader = true
        },
    }
     
    DailyMissionMenu[#DailyMissionMenu+1] = {
        header = "🗞 Get Daily Quests",
        txt = "Daily quests will reset when a new day passes",
        params = { 
            event = "mst-mission:client:TakeDailyMission", 
        }
        
    }

    DailyMissionMenu[#DailyMissionMenu+1] = {
        header = '🛎 Checking process',
        txt = "Check your current task progress",
        params = { 
            event = "mst-mission:client:CheckProgress",
            args = "dailymission", 
        }
        
    }
    
    DailyMissionMenu[#DailyMissionMenu+1] = {
        header = "⬅ Exit",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu",
        }
    }
    exports['qb-menu']:openMenu(DailyMissionMenu)
end)

RegisterNetEvent("mst-mission:client:HourlyMissionMenu", function()
    local HourlyMissionMenu = {
        {
            header = "📘 Hourly Quests",
            isMenuHeader = true
        },
    }
     
    HourlyMissionMenu[#HourlyMissionMenu+1] = {
        header = "🗞 Get Hourly Quests",
        txt = "Daily quests will be reset every hour",
        params = { 
            event = "mst-mission:client:TakeHourlyMission", 
        }
        
    }

    HourlyMissionMenu[#HourlyMissionMenu+1] = {
        header = '🛎 Checking process',
        txt = "Check your current task progress",
        params = { 
            event = "mst-mission:client:CheckProgress",
            args = "hourlymission", 
        }
        
    }
    
    HourlyMissionMenu[#HourlyMissionMenu+1] = {
        header = "⬅ Exit",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu",
        }
    }
    exports['qb-menu']:openMenu(HourlyMissionMenu)
end)


RegisterNetEvent("mst-mission:client:HiddenMissionMenu", function(data)
    if GetClockHours() >= Config.Hidden_Mission[data.key].min_time and GetClockHours() <= Config.Hidden_Mission[data.key].max_time then
        local HiddenMissionMenu = {
            {
                header = "📙 Hidden Quests",
                isMenuHeader = true
            },
        }
        
        HiddenMissionMenu[#HiddenMissionMenu+1] = {
            header = '🗞 Taking mission "'..Config.Hidden_Mission[data.key].name..'"',
            txt = "This is a hidden quest that can only be done once",
            params = { 
                event = "mst-mission:client:TakeHiddenMission",
                args = data.key, 
            }
            
        }

        HiddenMissionMenu[#HiddenMissionMenu+1] = {
            header = '🛎 Checking process',
            txt = "Check your current task progress",
            params = { 
                event = "mst-mission:client:CheckHiddenProgress",
                args = data.key, 
            }
            
        }
        
        HiddenMissionMenu[#HiddenMissionMenu+1] = {
            header = "⬅ Exit",
            txt = "",
            params = {
                event = "qb-menu:client:closeMenu",
            }
        }
        exports['qb-menu']:openMenu(HiddenMissionMenu)
    else 
        QBCore.Functions.Notify("I'm busy right now, please come later", "error")
    end 
end)

