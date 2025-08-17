local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Ícone cinza (menor e móvel)
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 40, 0, 40) -- menor que painel
icon.Position = UDim2.new(0, 50, 0, 50)
icon.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
icon.Text = ""
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 10)
iconCorner.Parent = icon

-- Painel cinza (maior, centralizado)
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 500, 0, 300) -- maior que o ícone
panel.Position = UDim2.new(0.5, -250, 0.5, -150) -- centralizado
panel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = panel

-- Funções de animação
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function openPanel()
    panel.Size = UDim2.new(0, 0, 0, 0)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Visible = true
    TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 500, 0, 300), Position = UDim2.new(0.5, -250, 0.5, -150)}):Play()
end

local function closePanel()
    local tween = TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
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

-- Função para arrastar qualquer Frame
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Tornar painel e ícone arrastáveis
makeDraggable(icon)
makeDraggable(panel)
