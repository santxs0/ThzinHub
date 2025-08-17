local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Ícone cinza menor (móvel)
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 40, 0, 40) -- menor
icon.Position = UDim2.new(0, 50, 0, 50)
icon.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
icon.Text = ""
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 10)
iconCorner.Parent = icon

-- Painel maior
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 500, 0, 300) -- maior
panel.Position = UDim2.new(0.5, -250, 0.5, -150) -- centralizado
panel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = panel

-- Animação do painel
local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function openPanel()
    panel.Position = UDim2.new(0.5, -250, 0.5, -150)
    panel.Size = UDim2.new(0, 0, 0, 0)
    panel.Visible = true
    TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 500, 0, 300)}):Play()
end

local function closePanel()
    local tween = TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        panel.Visible = false
    end)
end

-- Abrir/fechar painel ao clicar no ícone
icon.MouseButton1Click:Connect(function()
    if panel.Visible then
        closePanel()
    else
        openPanel()
    end
end)

-- Tornar painel arrastável
local dragging = false
local dragInput, dragStart, startPos

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

panel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Tornar ícone arrastável também
local iconDragging = false
local iconDragInput, iconDragStart, iconStartPos

icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconDragStart = input.Position
        iconStartPos = icon.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                iconDragging = false
            end
        end)
    end
end)

icon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        iconDragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if iconDragging and input == iconDragInput then
        local delta = input.Position - iconDragStart
        icon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X,
                                  iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
    end
end)
