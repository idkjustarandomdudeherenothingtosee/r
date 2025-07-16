local rep = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local plr = game:GetService("Players").LocalPlayer

local rem = rep:WaitForChild("Events"):WaitForChild("Block")

local holding = false

-- make mobile button only if touch enabled
if uis.TouchEnabled then
	local ui = Instance.new("ScreenGui")
	ui.Name = "blockgui"
	ui.ResetOnSpawn = false
	ui.Parent = plr:WaitForChild("PlayerGui")

	local b = Instance.new("ImageButton")
	b.Size = UDim2.new(0, 80, 0, 80)
	b.Position = UDim2.new(0, 30, 1, -110)
	b.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	b.AutoButtonColor = false
	b.Image = "rbxassetid://0"
	b.Parent = ui

	local cor = Instance.new("UICorner")
	cor.CornerRadius = UDim.new(0, 18)
	cor.Parent = b

	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(150, 20, 20)
	stroke.Parent = b

	local shadow = Instance.new("ImageLabel")
	shadow.Size = UDim2.new(1, 12, 1, 12)
	shadow.Position = UDim2.new(0, -6, 0, -6)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://13160452165"
	shadow.ImageTransparency = 0.5
	shadow.ZIndex = 0
	shadow.Parent = b

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 40, 0, 40)
	icon.Position = UDim2.new(0.5, -20, 0, 10)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://6031094678"
	icon.ZIndex = 2
	icon.Parent = b

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 20)
	lbl.Position = UDim2.new(0, 0, 1, -25)
	lbl.BackgroundTransparency = 1
	lbl.Text = "BLOCK"
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.ZIndex = 2
	lbl.Parent = b

	b.MouseButton1Down:Connect(function()
		holding = true
		rem:FireServer(true)
	end)

	b.MouseButton1Up:Connect(function()
		holding = false
		rem:FireServer(false)
	end)

	uis.InputEnded:Connect(function(i, p)
		if p then return end
		if i.UserInputType == Enum.UserInputType.Touch then
			if holding then
				holding = false
				rem:FireServer(false)
			end
		end
	end)
end

-- PC block with F key
uis.InputBegan:Connect(function(i, p)
	if p then return end
	if i.KeyCode == Enum.KeyCode.F then
		holding = true
		rem:FireServer(true)
	end
end)

uis.InputEnded:Connect(function(i, p)
	if p then return end
	if i.KeyCode == Enum.KeyCode.F then
		holding = false
		rem:FireServer(false)
	end
end)
