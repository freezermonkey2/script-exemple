local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VerifyUsernameEvent = ReplicatedStorage:WaitForChild("VerifyUsername")
local OrderBoardEvent = ReplicatedStorage:WaitForChild("OrderBoardEvent")
local OrderSubmitted = ReplicatedStorage:WaitForChild("OrderSubmitted")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local gui = script.Parent
local usernameInput = gui.NameFrame.ImageLable:WaitForChild("playername")
local submitButton = gui.NameFrame.ImageLable:WaitForChild("enter")
local nextFrame = gui:WaitForChild("OrderFrame")
local cookieButton = gui.OrderFrame.ImageLabel:WaitForChild("cookiebutton")
local donutButton = gui.OrderFrame.ImageLabel:WaitForChild("donutbutton")
local chocolatechipcookie = gui.OrderFrame.ImageLabel.cookies:WaitForChild("chocolatechipcookie")
local redvelvet = gui.OrderFrame.ImageLabel.cookies:WaitForChild("redvelvetcookie")
local vanilla = gui.OrderFrame.ImageLabel.cookies:WaitForChild("vanillacookie")
local sugarsprinkle = gui.OrderFrame.ImageLabel.cookies:WaitForChild("sugarsprinkle")
local PeanutButterCookie = gui.OrderFrame.ImageLabel.cookies:WaitForChild("PeanutButterCookie")
local orderSubmitButton = gui.OrderFrame.ImageLabel:WaitForChild("submit")
local cupcakebutton = gui.OrderFrame.ImageLabel:WaitForChild("cupcakebutton")
local cupcakes = gui.OrderFrame.ImageLabel:WaitForChild("cupcakes")
local labelCount = 0
local baseClicked = nil
local OrderCompleteEvent = ReplicatedStorage:WaitForChild("OrderCompleteEvent")
local Macaronsbutton = gui.OrderFrame.ImageLabel:WaitForChild("Macaronsbutton")
local muffinbutton = gui.OrderFrame.ImageLabel:WaitForChild("muffinbutton")
local muffins = gui.OrderFrame.ImageLabel:WaitForChild("muffins")
local cookies = gui.OrderFrame.ImageLabel:WaitForChild("cookies")
local cakepopbutton = gui.OrderFrame.ImageLabel:WaitForChild("Cakepopsbutton")
local cakepops = gui.OrderFrame.ImageLabel:WaitForChild("Cakepops")
local Macarons = gui.OrderFrame.ImageLabel:WaitForChild("Macarons")
local OrderTemplate = script.Parent.OrderTemplate
local chefframe = script.Parent:WaitForChild("ChefFrame")
local chefraamebutton = chefframe.ImageLabel.ImageLabel.ScrollingFrame.template:WaitForChild("TextButton")
local cheftextlable = chefframe.ImageLabel.ImageLabel.ScrollingFrame.template:WaitForChild("num")
local chefclosebutton = script.Parent.ChefFrame.ImageLabel:WaitForChild("close")
local giveToolsButton = OrderTemplate:WaitForChild("TextButton")
local donuts = gui.OrderFrame.ImageLabel:WaitForChild("donuts")
local CloseGuiEvent = ReplicatedStorage:WaitForChild("OrderEvent")
local CloseTemplateEvent = ReplicatedStorage:WaitForChild("CloseTemplateGui")
local claimEvent = ReplicatedStorage:WaitForChild("ClaimOrderEvent")
local CloseOrderTemplateEvent = ReplicatedStorage:WaitForChild("CloseTemplateGui")
local DisplayOrderFrame = ReplicatedStorage:WaitForChild("DisplayOrderFrame")
local order = {}
submitButton.MouseButton1Click:Connect(function()
	local username = usernameInput.Text
	VerifyUsernameEvent:FireServer(username)
end)
local function createFoodLabel(baseName, specificName)
	if labelCount >= 3 then
		print("Maximum number of labels reached!")
		return
	end
	local textLabel = Instance.new("TextLabel")
	if specificName then
		textLabel.Text = baseName .. " " .. specificName 
	else
		textLabel.Text = baseName
	end
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(0, 147, 0, 34)
	textLabel.Parent = gui.OrderFrame
	local positions = {
		UDim2.new(6.12, 0, 1.33, 0),  -- Slot 1
		UDim2.new(7.69, 0, 1.34, 0),  -- Slot 2
		UDim2.new(9.233, 0, 1.34, 0)   -- Slot 3
	}
	textLabel.Position = positions[labelCount + 1]
	labelCount = labelCount + 1
	table.insert(order, textLabel.Text)
end
cookieButton.MouseButton1Click:Connect(function()
	baseClicked = "Cookie"
	if labelCount < 3 then
		chocolatechipcookie.Visible = true
		redvelvet.title.Text = "Oatmeal"
		redvelvet.Visible = true
		vanilla.title.Text = "Sugar"
		vanilla.Visible = true
		PeanutButterCookie.title.Text = "PeanutButter"
		PeanutButterCookie.Visible = true
		cookies.Visible = true
		cupcakes.chocolatecupcake.Visible = false
		cupcakes.vanillacupcake.Visible = false
		cupcakes.redvelvetcupcake.Visible = false
		cupcakes.Visible = false
		donuts.chocolatedonut.Visible = false
		donuts.vanilladonut.Visible = false
		donuts.Visible = false
		Macarons.Visible = true
		Macarons.CaramelMacaron.Visible = false
		Macarons.LemonMacaron.Visible = false
		Macarons.MintMacaron.Visible = false
		Macarons.MochaMacaron.Visible = false
		Macarons.StrawberryMacaron.Visible = false
		muffins.Visible = false
		muffins.blueberrymuffin.Visible = false
		muffins.Chocolatemuffin.Visible = false
		muffins.cranberrymuffin.Visible = false
		muffins.Vanillamuffin.Visible = false
		cakepops.Visible = false
		cakepops.chocolatecakepop.Visible = false
		cakepops.vanillacakepop.Visible = false
	else
		print("You can only add up to 3 items.")
	end
end)
cupcakebutton.MouseButton1Click:Connect(function()
	baseClicked = "Cupcake"
	chocolatechipcookie.Visible = false
	redvelvet.Visible = false
	vanilla.Visible = false
	PeanutButterCookie.Visible = false
	cupcakes.chocolatecupcake.Visible = true
	cupcakes.vanillacupcake.Visible = true
	cupcakes.redvelvetcupcake.title.Text = "Strawberry"
	cupcakes.redvelvetcupcake.Visible = true
	cupcakes.Visible = true
	cookies.Visible = false
	donuts.chocolatedonut.Visible = false
	donuts.vanilladonut.Visible = false
	donuts.Visible = false
	Macarons.Visible = false
	Macarons.CaramelMacaron.Visible = false
	Macarons.LemonMacaron.Visible = false
	Macarons.MintMacaron.Visible = false
	Macarons.MochaMacaron.Visible = false
	Macarons.StrawberryMacaron.Visible = false
	muffins.Visible = false
	muffins.blueberrymuffin.Visible = false
	muffins.Chocolatemuffin.Visible = false
	muffins.cranberrymuffin.Visible = false
	muffins.Vanillamuffin.Visible = false
	cakepops.Visible = false
	cakepops.chocolatecakepop.Visible = false
	cakepops.vanillacakepop.Visible = false
end)
cakepopbutton.MouseButton1Click:Connect(function()
	baseClicked = "Cakepop"
	chocolatechipcookie.Visible = false
	redvelvet.Visible = false
	vanilla.Visible = false
	PeanutButterCookie.Visible = false
	cupcakes.chocolatecupcake.Visible = false
	cupcakes.vanillacupcake.Visible = false
	cupcakes.redvelvetcupcake.Visible = false
	cupcakes.Visible = false
	cookies.Visible = false
	donuts.chocolatedonut.Visible = false
	donuts.vanilladonut.Visible = false
	donuts.Visible = false
	Macarons.Visible = false
	Macarons.CaramelMacaron.Visible = false
	Macarons.LemonMacaron.Visible = false
	Macarons.MintMacaron.Visible = false
	Macarons.MochaMacaron.Visible = false
	Macarons.StrawberryMacaron.Visible = false
	muffins.Visible = false
	muffins.blueberrymuffin.Visible = false
	muffins.Chocolatemuffin.Visible = false
	muffins.cranberrymuffin.Visible = false
	muffins.Vanillamuffin.Visible = false
	cakepops.Visible = true
	cakepops.chocolatecakepop.Visible = true
	cakepops.redvelvetcakepop.title.Text = "Strawberry"
	cakepops.vanillacakepop.Visible = true
end)
cupcakes.chocolatecupcake.MouseButton1Click:Connect(function()
	if not baseClicked then
		print("Please click the cookie or donut button first.")
		return
	end
	if labelCount < 3 then
		createFoodLabel("Chocolate", baseClicked)
	else
		print("You can only add up to 3 items.")
	end
end)
cakepops.chocolatecakepop.MouseButton1Click:Connect(function()
	if not baseClicked then
		print("Please click the cookie or donut button first.")
		return
	end
	if labelCount < 3 then
		createFoodLabel("Chocolate", baseClicked)
	else
		print("You can only add up to 3 items.")
	end
end)
cakepops.redvelvetcakepop.MouseButton1Click:Connect(function()
	if not baseClicked then
		print("Please click the cookie or donut button first.")
		return
	end
	if labelCount < 3 then
		createFoodLabel("Strawberry", baseClicked)
	else
		print("You can only add up to 3 items.")
	end
end)
muffins.blueberrymuffin.MouseButton1Click:Connect(function()
