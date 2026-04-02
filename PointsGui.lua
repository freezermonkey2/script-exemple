local Player = game:GetService("Players")
local player = Player.LocalPlayer
local pointsLable = script.Parent.points

local function UpdatePoints()
	local leaderstats = player:WaitForChild("leaderstats")
	local points = leaderstats:WaitForChild("Points")
		
	  local function onPointsChange()
		pointsLable.Text = tostring(points.Value)
	  end
	  
	points:GetPropertyChangedSignal("Value"):Connect(onPointsChange)
	onPointsChange()
   end

player.CharacterAdded:Connect(UpdatePoints)
UpdatePoints()
