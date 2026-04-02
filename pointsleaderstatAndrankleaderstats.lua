local Player = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local PointsDataStore = DataStoreService:GetDataStore("PointsDataStore")
local groupid = 0 -- group id here

local function onPlayerAdded(player)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local points = Instance.new("IntValue")
	points.Name = "Points"
	points.Value = 0 
	points.Parent = leaderstats
	
	local rank = Instance.new("StringValue")
	rank.Name = "Rank"
	rank.Parent = leaderstats

	local playerRank  = player:GetRankInGroup(groupid)
	rank.Value = player:GetRoleInGroup(groupid)

	player:GetPropertyChangedSignal("MembershipType"):Connect(function()
		rank.Value = player:GetRankInGroup(groupid)
	end)
	
	local success, SavedPoints = pcall(function()
		return PointsDataStore:GetAsync(player.UserId)
	end)
	
	if success then
		points.Value = SavedPoints or 0
	else
		warn("Failed to load points for player " .. player.Name)
		points.Value = 0
		
	end
  end



local function onPlayerRemoving(player)
	local points  = player.leaderstats and player.leaderstats:FindFirstChild("Points")
	if points then
		
		local success, errorMessage = pcall(function()
			PointsDataStore:SetAsync(player.UserId, points.Value)
		end)
		
		if not success then
			warn("Failed to save points for player " .. player.Name .. ": " .. errorMessage)
		end
	end
end
Player.PlayerAdded:Connect(onPlayerAdded)
Player.PlayerRemoving:Connect(onPlayerRemoving)
