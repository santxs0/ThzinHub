local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Ícone cinza para abrir o painel
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 70, 0, 70)
icon.Position = UDim2.new(0, 50, 0, 50)
icon.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
icon.Text = ""
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 15)
iconCorner.Parent = icon

-- Painel cinza (inicialmente invisível)
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 300, 0, 200)
panel.Position = UDim2.new(0.5, -150, 0.5, -100) -- centralizado
panel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = panel

-- Função para animar abertura e fechamento
local TweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function openPanel()
    panel.Position = UDim2.new(0.5, -150, 0.5, -100)
    panel.Size = UDim2.new(0, 0, 0, 0)
    panel.Visible = true
    TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 300, 0, 200)}):Play()
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

-- Variáveis para arrastar o painel
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
