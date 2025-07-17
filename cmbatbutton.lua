local uis = game:GetService('UserInputService')
local player = game.Players.LocalPlayer
local playergui = player:WaitForChild('PlayerGui')

local blocking = false

if uis.TouchEnabled then
    local gui = playergui:WaitForChild('ScreenGui')

    -- main combat top right half
    local combat_top = Instance.new('TextButton')
    combat_top.Size = UDim2.new(0.5, 0, 0.8, 0) -- right half, top 80%
    combat_top.Position = UDim2.new(0.5, 0, 0, 0)
    combat_top.BackgroundTransparency = 1
    combat_top.Text = ''
    combat_top.Parent = gui

    -- combat bottom right strip under jump/block gap
    local combat_bottom = Instance.new('TextButton')
    combat_bottom.Size = UDim2.new(0.5, 0, 0.2, 0) -- right half, bottom 20%
    combat_bottom.Position = UDim2.new(0.5, 0, 0.8, 0)
    combat_bottom.BackgroundTransparency = 1
    combat_bottom.Text = ''
    combat_bottom.Parent = gui

    local function do_combat()
        if not blocking then
            CombatInput()
        end
    end

    combat_top.MouseButton1Click:Connect(do_combat)
    combat_bottom.MouseButton1Click:Connect(do_combat)

    -- block button: bottom left above jump
    local block_btn = Instance.new('TextButton')
    block_btn.Size = UDim2.new(0, 120, 0, 120) -- your size
    block_btn.Position = UDim2.new(0, 30, 1, -220) -- offset from bottom
    block_btn.BackgroundTransparency = 0.3
    block_btn.Text = 'Block'
    block_btn.Parent = gui

    block_btn.MouseButton1Down:Connect(function()
        blocking = true
        BlockInput(true)
    end)

    block_btn.MouseButton1Up:Connect(function()
        blocking = false
        BlockInput(false)
    end)

    -- jump button: bottom left corner
    local jump_btn = Instance.new('TextButton')
    jump_btn.Size = UDim2.new(0, 80, 0, 80) -- standard jump size
    jump_btn.Position = UDim2.new(0, 30, 1, -110) -- bottom left corner
    jump_btn.BackgroundTransparency = 0.3
    jump_btn.Text = 'Jump'
    jump_btn.Parent = gui

    jump_btn.MouseButton1Click:Connect(function()
        JumpInput()
    end)
end
