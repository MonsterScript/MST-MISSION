local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('mst-mission:server:CheckMission', function(source, cb, type)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local DailyMission = Player.PlayerData.metadata["dailymission"] or false 
    local HourlyMission = Player.PlayerData.metadata["hourlymission"] or false
    local HiddenMission = Player.PlayerData.metadata[type]

    if not DailyMission then 
        DailyMission = 0 
    end 

    if not HourlyMission then 
        HourlyMission = 0 
    end

    if not HiddenMission then 
        HiddenMission = false 
    end 

    if type == "dailymission" then 
        cb(DailyMission)
    elseif type == "hourlymission" then 
        cb(HourlyMission)
    else 
        cb(HiddenMission)
    end

end)





RegisterNetEvent("mst-mission:server:TakeDailyMission", function(mission)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local time_table = os.date ("*t")
    if tonumber(Player.PlayerData.metadata["dailymission_timestamp"]) ~= tonumber(time_table.day) then 
        TriggerClientEvent('QBCore:Notify', src, "You have received the hourly quest called "..Config.Daily_Mission[mission].name.." This mission requires you "..Config.Daily_Mission[mission].label.."", "success") 
        Player.Functions.SetMetaData("dailymission_timestamp", time_table.day)
        Player.Functions.SetMetaData("dailymission", mission)
    else 
        TriggerClientEvent('QBCore:Notify', src, "Bạn đã nhận nhiệm vụ ngày rồi, vui lòng đợi qua ngày mới", "error") 
    end
end)

RegisterNetEvent("mst-mission:server:TakeHourlyMission", function(mission)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local time_table = os.date ("*t")
    
    if Player.PlayerData.metadata["hourlymission_timestamp"] ~= time_table.hour then
        TriggerClientEvent('QBCore:Notify', src, "You have received the hourly quest called "..Config.Hourly_Mission[mission].name.." This mission requires you "..Config.Hourly_Mission[mission].label.."", "success") 
        Player.Functions.SetMetaData("hourlymission_timestamp", time_table.hour)
        Player.Functions.SetMetaData("hourlymission", mission)
    else 
        TriggerClientEvent('QBCore:Notify', src, "You have accepted the quest now, please wait a little longer", "error") 
    end
end)

RegisterNetEvent("mst-mission:server:TakeHiddenMission", function(mission)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player.PlayerData.metadata[mission] then 
        Player.Functions.SetMetaData(mission.."_done", false)
        Player.Functions.SetMetaData(mission, true)
    end
    
end)


RegisterNetEvent("mst-mission:server:CheckProgress", function(type, requiredTable, RewardItems, RewardMoney)
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local text = ""
    local reward_item_text = ""
    local reward_money_text = ""
    local progress = {}
    local progress_text = ""

    if hasMissionItems(src, requiredTable) then 
        completeMission(src, type, RewardItems, RewardMoney)
    else 
        for k, v in pairs (requiredTable) do
            if Player.Functions.GetItemByName(k) then
                progress[k] = Player.Functions.GetItemByName(k).amount 
            else 
                progress[k] = 0
            end
            
            if progress[k] < v then 
                progress_text = "["..(progress[k]).."/" .. v .. "]"
            else 
                progress_text = "Finish"
            end 
            
            text = text.." - ".. QBCore.Shared.Items[k]["label"] .. " "..progress_text.."<br>"
        end

        for k, v in pairs (RewardItems) do
            
            reward_item_text = reward_item_text.." - "..v.." ".. QBCore.Shared.Items[k]["label"] .. " "..reward_item_text.."<br>"
        end

        for k, v in pairs(RewardMoney) do 
            if k == "cash" then 
                money_label = "CASH"
            else 
                money_label = "BANK"
            end 
            reward_money_text = reward_money_text.. " - "  ..money_label..": $"..v
        end 


        TriggerClientEvent('QBCore:Notify', source, "You have now collected:<br>"..text.."<br>Reward:<br>"..reward_item_text..""..reward_money_text, "error")
    end
end)


function hasMissionItems(source, CostItems)
	local Player = QBCore.Functions.GetPlayer(source)
	for k, v in pairs(CostItems) do
		if Player.Functions.GetItemByName(k) ~= nil then
			if Player.Functions.GetItemByName(k).amount < (v) then
				return false
			end
		else
			return false
		end
	end
	for k, v in pairs(CostItems) do  
		Player.Functions.RemoveItem(k, v)
		--TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[k], "remove")
	end
	return true
end

function completeMission(source, type, RewardItems, RewardMoney)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	
    if type == "dailymission" then 
        Player.Functions.SetMetaData("dailymission", 0)
    elseif type == "hourlymission" then 
        Player.Functions.SetMetaData("hourlymission", 0)
    else 
        Player.Functions.SetMetaData(type.."_done", true)
    end


	if RewardItems ~= nil then
		for k, v in pairs(RewardItems) do
			Player.Functions.AddItem(k, v)
			--TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[k], "add")
		end
	end 
	
	if RewardMoney ~= nil then
        for k, v in pairs(RewardMoney) do 
		    Player.Functions.AddMoney(k, v)
        end
	end
	
	TriggerClientEvent('QBCore:Notify', source, "Congratulations on completing the quest and getting the reward.", "success")
	
end


QBCore.Commands.Add("resetmission", "Reset player's date/time quest", {{name = "id", help = "Player ID"}}, false, function(source, args)
	local src = source
	if args[1] then
		local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
		if Player then
			TriggerClientEvent('hospital:client:Revive', Player.PlayerData.source)
            Player.Functions.SetMetaData("dailymission", 0)
            Player.Functions.SetMetaData("hourlymission", 0)
            Player.Functions.SetMetaData("dailymission_timestamp", 0)
            Player.Functions.SetMetaData("hourlymission_timestamp", 0)
            TriggerClientEvent('QBCore:Notify', src, "Has reset the mission of "..Player.PlayerData.source, "success")
		else
			TriggerClientEvent('QBCore:Notify', src, "Players not online", "error")
		end
	else
        local Player = QBCore.Functions.GetPlayer(src)
		TriggerClientEvent('QBCore:Notify', src, "Reset your own quest", "success")
        Player.Functions.SetMetaData("dailymission", 0)
        Player.Functions.SetMetaData("hourlymission", 0)
        Player.Functions.SetMetaData("dailymission_timestamp", 0)
        Player.Functions.SetMetaData("hourlymission_timestamp", 0)
	end
end, "admin")

