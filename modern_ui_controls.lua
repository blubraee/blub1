-- LOCAL SCRIPT — put inside StarterPlayerScripts
-- Modern Rounded Control Panel (Fly, Walkspeed, ESP, Noclip)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local HRP = char:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

----------------------------------------------------------------
--  MODERN UI CREATION
----------------------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ModernControlUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Size = UDim2.new(0, 260, 0, 320)
frame.Position = UDim2.new(0.05, 0, 0.25, 0)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.15

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 18)

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -10, 0, 40)
title.Text = "Control Panel"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 25

----------------------------------------------------------------
--  BUTTON MAKER
----------------------------------------------------------------
local function NewButton(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 36)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Text = text
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 20

    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 12)

    b.Parent = frame
    return b
end

local function NewSlider(text)
    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(0.9, 0, 0, 60)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(255,255,255)

    local bar = Instance.new("Frame", container)
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0,8)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(0.3, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,8)

    return container, bar, fill
end

----------------------------------------------------------------
--  BUTTONS
----------------------------------------------------------------
local FlyBtn = NewButton("Fly: OFF")
local NoclipBtn = NewButton("Noclip: OFF")
local ESPBtn = NewButton("ESP: OFF")

----------------------------------------------------------------
--  WALKSPEED SLIDER
----------------------------------------------------------------
local sliderFrame, sliderBar, sliderFill = NewSlider("Walkspeed")
local dragging = false
local walkspeed = 16

sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

RS.RenderStepped:Connect(function()
    if dragging then
        local barPos = sliderBar.AbsolutePosition.X
        local barSize = sliderBar.AbsoluteSize.X
        local mousePos = UIS:GetMouseLocation().X

        local pct = math.clamp((mousePos - barPos) / barSize, 0, 1)
        sliderFill.Size = UDim2.new(pct, 0, 1, 0)

        walkspeed = 16 + math.floor(pct * 50)
        hum.WalkSpeed = walkspeed
    end
end)

----------------------------------------------------------------
--  FLY SYSTEM
----------------------------------------------------------------
local flying = false

local function flyLoop()
    RS.RenderStepped:Connect(function()
        if not flying then return end

        local move = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += HRP.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= HRP.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= HRP.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += HRP.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

        HRP.Velocity = move * 50
    end)
end

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
    if flying then flyLoop() else HRP.Velocity = Vector3.zero end
end)

----------------------------------------------------------------
--  NOCLIP
----------------------------------------------------------------
local noclip = false

RS.Stepped:Connect(function()
    if noclip and char then
        for _,part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

----------------------------------------------------------------
--  ESP
----------------------------------------------------------------
local espEnabled = false

local function enableESP(plr)
    if not plr.Character then return end
    local h = Instance.new("Highlight")
    h.Name = "ESP_Highlight"
    h.FillColor = Color3.fromRGB(0,255,180)
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.Adornee = plr.Character
    h.Parent = plr.Character
end

local function disableESP(plr)
    if plr.Character then
        for _,obj in pairs(plr.Character:GetChildren()) do
            if obj.Name == "ESP_Highlight" then obj:Destroy() end
        end
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"

    for _,plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            if espEnabled then enableESP(plr) else disableESP(plr) end
        end
    end
end)

game.Players.PlayerAdded:Connect(function(plr)
    if espEnabled then
        plr.CharacterAdded:Connect(function()
            enableESP(plr)
        end)
    end
end)
