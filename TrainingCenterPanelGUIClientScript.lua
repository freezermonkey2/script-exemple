local TweenService = game:GetService("TweenService")
local viewAllButton = script.Parent.viewAllButton
local SceneTime = 10
local tweenInfo = TweenInfo.new(SceneTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0)
local camera = game.Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local kickButton = script.Parent.kickbutton
local lockSeatButton = script.Parent.lockseat

local function typeWrite(dialogLabel, text, speed)
	for i = 1, #text do
		dialogLabel.Text = string.sub(text, 1, i)
		wait(speed)
	end
end

local function showDialogsWhileTweening(dialogs, speed)
	local screenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui")
	local boxFrame = screenGui:WaitForChild("boxframe")
	local dialogLabel = boxFrame:WaitForChild("DialogLabel")
	local profileImage = boxFrame:WaitForChild("ProfileImage")

	profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. game.Players.LocalPlayer.UserId .. "&w=420&h=420"

	boxFrame.Visible = true
	for _, dialogText in ipairs(dialogs) do
		typeWrite(dialogLabel, dialogText, speed)
		wait(SceneTime / #dialogs - (speed * #dialogText)) -- Adjust the wait time to match the camera movement
	end
end

local function hideDialog()
	local screenGui = game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui")
	local boxFrame = screenGui:WaitForChild("boxframe")
	boxFrame.Visible = false
end

viewAllButton.MouseButton1Down:Connect(function()
	ReplicatedStorage.StartCameraTween:FireServer()
end)

kickButton.MouseButton1Down:Connect(function()
	ReplicatedStorage.KickAllPlayers:FireServer("Completed training")
end)

lockSeatButton.MouseButton1Down:Connect(function()
	ReplicatedStorage.ToggleSeatLock:FireServer()
end)

ReplicatedStorage.UpdateLockButton.OnClientEvent:Connect(function(isLocked)
	lockSeatButton.Text = isLocked and "Lock" or "UnLock"
end)

ReplicatedStorage.ShowCameraTween.OnClientEvent:Connect(function()
	local CameraPart1 = game.Workspace:WaitForChild("CameraPart1")
	local CameraPart2 = game.Workspace:WaitForChild("CameraPart2")

	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CameraPart1.CFrame

	local dialogs = {
		"Hello wellcom to trining...",
		"training instruction...",
		"ready to start."
	}

	local tween = TweenService:Create(camera, tweenInfo, {CFrame = CameraPart2.CFrame})

	tween:Play()
	coroutine.wrap(function()
		showDialogsWhileTweening(dialogs, 0.05)
	end)()

	tween.Completed:Wait()

	hideDialog()
	camera.CameraType = Enum.CameraType.Custom
end)
