local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Ícone cinza menor (móvel)
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 40, 0, 40)
icon.Position = UDim2.new(0, 50, 0, 50)
icon.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
icon.Text = ""
icon.Parent = screenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 10)
iconCorner.Parent = icon

-- Painel maior
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 500, 0, 400)
panel.Position = UDim2.new(0.5, -250, 0.5, -200)
panel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = panel

-- Gradiente moderno
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220,220,220))
}
gradient.Rotation = 90
gradient.Parent = panel

-- Título ThzinHub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 35, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ThzinHub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 23
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

-- Linha horizontal abaixo do título
local line = Instance.new("Frame")
line.Size = UDim2.new(1, 0, 0, 2)
line.Position = UDim2.new(0, 0, 0, 40)
line.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
line.Parent = panel

-- Animação do painel
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function openPanel()
    panel.Size = UDim2.new(0, 0, 0, 0)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Visible = true
    TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 500, 0, 400), Position = UDim2.new(0.5, -250, 0.5, -200)}):Play()
end

local function closePanel()
    local tween = TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        panel.Visible = false
    end)
end

icon.MouseButton1Click:Connect(function()
    if panel.Visible then
        closePanel()
    else
        openPanel()
    end
end)

-- Função para arrastar qualquer frame
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

makeDraggable(icon)
makeDraggable(panel)

-- Função para criar toggles
local function createToggle(nameText, parent, positionY)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 50)
    container.Position = UDim2.new(0, 20, 0, positionY)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 50, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nameText
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 30, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, 10)
    toggle.BackgroundColor3 = Color3.fromRGB(120,120,120)
    toggle.Text = ""
    toggle.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = toggle

    local activated = false
    local flying = false
    local bodyVelocity

    toggle.MouseButton1Click:Connect(function()
        activated = not activated
        if activated then
            toggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
            if nameText == "Super Velocidade" then
                humanoid.WalkSpeed = 100
            elseif nameText == "Super Jump" then
                humanoid.JumpPower = 150
                humanoid.Jump = true
            elseif nameText == "Fly" then
                flying = true
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
                bodyVelocity.Velocity = Vector3.new(0,0,0)
                bodyVelocity.Parent = rootPart

                RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Camera.Value, function()
                    if not flying then return end
                    local moveDirection = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0,1,0) end
                    bodyVelocity.Velocity = moveDirection * 50
                end)
            end
        else
            toggle.BackgroundColor3 = Color3.fromRGB(120,120,120)
            if nameText == "Super Velocidade" then
                humanoid.WalkSpeed = 16
            elseif nameText == "Super Jump" then
                humanoid.JumpPower = 50
            elseif nameText == "Fly" then
                flying = false
                if bodyVelocity then bodyVelocity:Destroy() end
                RunService:UnbindFromRenderStep("FlyControl")
            end
        end
    end)
end

-- Criar os toggles
createToggle("Super Velocidade", panel, 60)
createToggle("Super Jump", panel, 120)
createToggle("Fly", panel, 180)-- Gradiente moderno
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220,220,220))
}
gradient.Rotation = 90
gradient.Parent = panel

-- Título ThzinHub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 35, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ThzinHub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 23
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

-- Linha horizontal abaixo do título
local line = Instance.new("Frame")
line.Size = UDim2.new(1, 0, 0, 2)
line.Position = UDim2.new(0, 0, 0, 40)
line.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
line.Parent = panel

-- Animação do painel
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function openPanel()
    panel.Size = UDim2.new(0, 0, 0, 0)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Visible = true
    TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 500, 0, 400), Position = UDim2.new(0.5, -250, 0.5, -200)}):Play()
end

local function closePanel()
    local tween = TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        panel.Visible = false
    end)
end

icon.MouseButton1Click:Connect(function()
    if panel.Visible then
        closePanel()
    else
        openPanel()
    end
end)

-- Função para arrastar qualquer frame
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

makeDraggable(icon)
makeDraggable(panel)

-- Função para criar toggles
local function createToggle(nameText, parent, positionY)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 50)
    container.Position = UDim2.new(0, 20, 0, positionY)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 50, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nameText
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 30, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, 10)
    toggle.BackgroundColor3 = Color3.fromRGB(120,120,120)
    toggle.Text = ""
    toggle.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = toggle

    local activated = false
    local flying = false
    local bodyVelocity

    toggle.MouseButton1Click:Connect(function()
        activated = not activated
        if activated then
            toggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
            if nameText == "Super Velocidade" then
                humanoid.WalkSpeed = 100
            elseif nameText == "Super Jump" then
                humanoid.JumpPower = 150
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping) -- força o pulo imediato
            elseif nameText == "Fly" then
                flying = true
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
                bodyVelocity.Velocity = Vector3.new(0,0,0)
                bodyVelocity.Parent = rootPart

                RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Camera.Value, function()
                    if not flying then return end
                    local moveDirection = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0,1,0) end
                    bodyVelocity.Velocity = moveDirection * 50
                end)
            end
        else
            toggle.BackgroundColor3 = Color3.fromRGB(120,120,120)
            if nameText == "Super Velocidade" then
                humanoid.WalkSpeed = 16
            elseif nameText == "Super Jump" then
                humanoid.JumpPower = 50
            elseif nameText == "Fly" then
                flying = false
                if bodyVelocity then bodyVelocity:Destroy() end
                RunService:UnbindFromRenderStep("FlyControl")
            end
        end
    end)
end

-- Criar os toggles
createToggle("Super Velocidade", panel, 60)
createToggle("Super Jump", panel, 120)
createToggle("Fly", panel, 180)-- Gradiente moderno
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220,220,220))
}
gradient.Rotation = 90
gradient.Parent = panel

-- Título ThzinHub
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 35, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ThzinHub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 23
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

-- Linha horizontal abaixo do título
local line = Instance.new("Frame")
line.Size = UDim2.new(1, 0, 0, 2)
line.Position = UDim2.new(0, 0, 0, 40)
line.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
line.Parent = panel

-- Animação do painel
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function openPanel()
    panel.Size = UDim2.new(0, 0, 0, 0)
    panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    panel.Visible = true
    TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 500, 0, 400), Position = UDim2.new(0.5, -250, 0.5, -200)}):Play()
end

local function closePanel()
    local tween = TweenService:Create(panel, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        panel.Visible = false
    end)
end

icon.MouseButton1Click:Connect(function()
    if panel.Visible then
        closePanel()
    else
        openPanel()
    end
end)

-- Função para arrastar qualquer frame
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

makeDraggable(icon)
makeDraggable(panel)

-- Função para criar toggles
local function createToggle(nameText, parent, positionY)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -40, 0, 50)
    container.Position = UDim2.new(0, 20, 0, positionY)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 50, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = nameText
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 30, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, 10)
    toggle.BackgroundColor3 = Color3.fromRGB(120,120,120)
    toggle.Text = ""
    toggle.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = toggle

    local activated = false
    local flying = false
    local bodyVelocity

    toggle.MouseButton1Click:Connect(function()
        activated = not activated
        if activated then
            toggle.BackgroundColor3 = Color3.fromRGB(0,255,0)
            if nameText == "Super Velocidade" then
                humanoid.WalkSpeed = 100
            elseif nameText == "Super Jump" then
                humanoid.JumpPower = 150
            elseif nameText == "Fly" then
                flying = true
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
                bodyVelocity.Velocity = Vector3.new(0,0,0)
                bodyVelocity.Parent = rootPart

                RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Camera.Value, function()
                    if not flying then return end
                    local moveDirection = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector end
                    bodyVelocity.Velocity = moveDirection * 50
                end)
            end
        else
            toggle.BackgroundColor3 = Color3.fromRGB(120,120,120)
            if nameText == "Super Velocidade" then
                humanoid.WalkSpeed = 16
            elseif nameText == "Super Jump" then
                humanoid.JumpPower = 50
            elseif nameText == "Fly" then
                flying = false
                if bodyVelocity then bodyVelocity:Destroy() end
                RunService:UnbindFromRenderStep("FlyControl")
            end
        end
    end)
end

-- Criar os toggles logo abaixo da linha
createToggle("Super Velocidade", panel, 60)
createToggle("Super Jump", panel, 120)
createToggle("Fly", panel, 180)
