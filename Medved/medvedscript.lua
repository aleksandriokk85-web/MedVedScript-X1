
-- MEDVED-inspired Settings UI
-- Roblox Studio LocalScript
-- Place in StarterPlayer > StarterPlayerScripts
-- UI demonstration only; does not manipulate MEDVED.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("MedvedSettingsUI")
if oldGui then
	oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "MedvedSettingsUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local settings = {
	["Disable Antihacks"] = false,
	["Kill"] = false,
	["ESP"] = false,
	["Loot"] = false,
	["Infinite Ammo"] = false
}

local COLORS = {
	Background = Color3.fromRGB(22, 23, 29),
	Panel = Color3.fromRGB(31, 33, 42),
	Row = Color3.fromRGB(41, 43, 54),
	Accent = Color3.fromRGB(105, 105, 255),
	Enabled = Color3.fromRGB(70, 190, 115),
	Disabled = Color3.fromRGB(95, 97, 110),
	Text = Color3.fromRGB(245, 245, 250),
	Muted = Color3.fromRGB(155, 158, 175)
}

local function create(class, properties, parent)
	local object = Instance.new(class)

	for property, value in pairs(properties) do
		object[property] = value
	end

	object.Parent = parent
	return object
end

local function round(object, radius)
	create("UICorner", {
		CornerRadius = UDim.new(0, radius)
	}, object)
end

-- Bottom-left settings button

local openButton = create("TextButton", {
	Name = "SettingsButton",
	Size = UDim2.fromOffset(125, 43),
	Position = UDim2.new(0, 16, 1, -18),
	AnchorPoint = Vector2.new(0, 1),
	BackgroundColor3 = COLORS.Accent,
	Text = "⚙ SETTINGS",
	TextColor3 = COLORS.Text,
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = true
}, gui)

round(openButton, 10)

-- Main window

local panel = create("Frame", {
	Name = "SettingsPanel",
	Size = UDim2.fromOffset(285, 330),
	Position = UDim2.new(0, 16, 1, -72),
	AnchorPoint = Vector2.new(0, 1),
	BackgroundColor3 = COLORS.Background,
	BorderSizePixel = 0,
	Visible = false
}, gui)

round(panel, 12)

create("UIStroke", {
	Color = COLORS.Accent,
	Thickness = 1.5,
	Transparency = 0.25
}, panel)

-- Header / drag handle

local header = create("Frame", {
	Name = "Header",
	Size = UDim2.new(1, 0, 0, 46),
	BackgroundColor3 = COLORS.Panel,
	BorderSizePixel = 0,
	Active = true
}, panel)

round(header, 12)

local title = create("TextLabel", {
	Size = UDim2.new(1, -55, 1, 0),
	Position = UDim2.fromOffset(14, 0),
	BackgroundTransparency = 1,
	Text = "MEDVED SETTINGS",
	TextColor3 = COLORS.Text,
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left
}, header)

local closeButton = create("TextButton", {
	Size = UDim2.fromOffset(32, 30),
	Position = UDim2.new(1, -39, 0, 8),
	BackgroundColor3 = COLORS.Row,
	Text = "×",
	TextColor3 = COLORS.Text,
	TextSize = 22,
	Font = Enum.Font.GothamBold
}, header)

round(closeButton, 8)

-- Settings list

local list = create("Frame", {
	Name = "SettingsList",
	Size = UDim2.new(1, -20, 1, -99),
	Position = UDim2.fromOffset(10, 55),
	BackgroundTransparency = 1
}, panel)

create("UIListLayout", {
	Padding = UDim.new(0, 7),
	SortOrder = Enum.SortOrder.LayoutOrder
}, list)

local function addSetting(name, order)
	local row = create("Frame", {
		Name = name:gsub("%s+", "") .. "Row",
		Size = UDim2.new(1, 0, 0, 43),
		BackgroundColor3 = COLORS.Row,
		BorderSizePixel = 0,
		LayoutOrder = order
	}, list)

	round(row, 8)

	local label = create("TextLabel", {
		Size = UDim2.new(1, -88, 1, 0),
		Position = UDim2.fromOffset(11, 0),
		BackgroundTransparency = 1,
		Text = name,
		TextColor3 = COLORS.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left
	}, row)

	local toggle = create("TextButton", {
		Name = "Toggle",
		Size = UDim2.fromOffset(65, 27),
		Position = UDim2.new(1, -74, 0.5, -13),
		BackgroundColor3 = COLORS.Disabled,
		Text = "OFF",
		TextColor3 = COLORS.Text,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false
	}, row)

	round(toggle, 7)

	local function update()
		local enabled = settings[name]

		toggle.BackgroundColor3 = enabled
			and COLORS.Enabled
			or COLORS.Disabled

		toggle.Text = enabled and "ON" or "OFF"
	end

	toggle.Activated:Connect(function()
		settings[name] = not settings[name]
		update()

		print("[Settings UI]", name, settings[name] and "ON" or "OFF")
	end)

	update()
end

local names = {
	"Disable Antihacks",
	"Kill",
	"ESP",
	"Loot",
	"Infinite Ammo"
}

for index, name in ipairs(names) do
	addSetting(name, index)
end

-- Footer

local footer = create("TextLabel", {
	Size = UDim2.new(1, -16, 0, 25),
	Position = UDim2.new(0, 8, 1, -30),
	BackgroundTransparency = 1,
	Text = "UI DEMO • No game modifications",
	TextColor3 = COLORS.Muted,
	TextSize = 10,
	Font = Enum.Font.Gotham
}, panel)

-- Expand / collapse

local expanded = false

local function setPanelVisible(state)
	expanded = state

	if state then
		panel.Visible = true
		panel.Size = UDim2.fromOffset(285, 0)

		TweenService:Create(
			panel,
			TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.fromOffset(285, 330)}
		):Play()
	else
		local tween = TweenService:Create(
			panel,
			TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{Size = UDim2.fromOffset(285, 0)}
		)

		tween:Play()
		tween.Completed:Once(function()
			if not expanded then
				panel.Visible = false
			end
		end)
	end
end

openButton.Activated:Connect(function()
	setPanelVisible(not expanded)
end)

closeButton.Activated:Connect(function()
	setPanelVisible(false)
end)

-- Drag functionality (mouse and touchscreen)

local dragging = false
local dragInput
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = panel.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart

		panel.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

print("[MEDVED UI] Settings interface loaded!")
