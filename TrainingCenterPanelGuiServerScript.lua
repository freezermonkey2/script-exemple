local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local seatsLocked = false


ReplicatedStorage.StartCameraTween.OnServerEvent:Connect(function()

	ReplicatedStorage.ShowCameraTween:FireAllClients()
end)

ReplicatedStorage.KickAllPlayers.OnServerEvent:Connect(function(player, reason)
	for _, plr in pairs(Players:GetPlayers()) do
		plr:Kick(reason)
	end
end)

ReplicatedStorage.ToggleSeatLock.OnServerEvent:Connect(function()
	seatsLocked = not seatsLocked

	ReplicatedStorage.UpdateLockButton:FireAllClients(seatsLocked)

	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			local seat = player.Character:FindFirstChildWhichIsA("Seat")
			if seatsLocked then
				if seat then
					humanoid.Sit = true
					humanoid.WalkSpeed = 0
					humanoid.JumpPower = 0
				end
			else
				humanoid.WalkSpeed = 16
				humanoid.JumpPower = 50
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid:GetPropertyChangedSignal("SeatPart"):Connect(function()
			local seat = humanoid.SeatPart
			if seat and seatsLocked then
				humanoid.Sit = true
				humanoid.WalkSpeed = 0
				humanoid.JumpPower = 0
			elseif not seat then
				humanoid.WalkSpeed = 16
				humanoid.JumpPower = 50
			end
		end)
	end)
end)
