-- Criar GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Ícone pequeno
local icon = Instance.new("Frame")
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0, 50, 0, 50)
icon.BackgroundColor3 = Color3.fromRGB(51, 153, 255)
icon.Parent = screenGui

-- Arredondar cantos do ícone
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 10)
iconCorner.Parent = icon

-- Retângulo maior (inicialmente invisível)
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 300, 0, 200)
panel.Position = UDim2.new(0, 150, 0, 100)
panel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
panel.Visible = false
panel.Parent = screenGui

-- Arredondar cantos do painel
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = panel

-- Abrir/fechar painel ao clicar no ícone
icon.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

-- Transformar o ícone em botão clicável
local iconButton = Instance.new("TextButton")
iconButton.Size = UDim2.new(1,0,1,0)
iconButton.BackgroundTransparency = 1
iconButton.Text = ""
iconButton.Parent = icon

iconButton.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)
