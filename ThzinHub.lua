local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Ícone cinza maior
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 70, 0, 70) -- maior que antes
icon.Position = UDim2.new(0, 50, 0, 50)
icon.BackgroundColor3 = Color3.fromRGB(120, 120, 120) -- cinza
icon.Text = ""
icon.Parent = screenGui

-- Arredondar cantos do ícone
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 15) -- cantos mais arredondados
iconCorner.Parent = icon

-- Painel maior
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 300, 0, 200)
panel.Position = UDim2.new(0, 150, 0, 100)
panel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = panel

-- Abrir/fechar painel ao clicar no ícone
icon.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- Variáveis para arrastar
local dragging = false
local dragInput, dragStart, startPos

icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = icon.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

icon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        icon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
