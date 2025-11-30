
-- UI Setup
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 350)
Frame.Position = UDim2.new(0, 15, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BackgroundTransparency = 0.15
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 2
UIStroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Control Panel"
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame


--====================================================
-- UI Toggle
--====================================================
local UIS = game:GetService("UserInputService")
local uiOpen = true

UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        uiOpen = not uiOpen
        Frame.Visible = uiOpen
    end
end)


--====================================================
-- WalkSpeed Slider
--====================================================
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -20, 0, 30)
SpeedLabel.Position = UDim2.new(0, 10, 0, 50)
SpeedLabel.Text = "WalkSpeed: 16"
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.TextSize = 18
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = Frame

local Slider = Instance.new("TextButton")
Slider.Size = UDim2.new(1, -20, 0, 40)
Slider.Position = UDim2.new(0, 10, 0, 80)
Slider.BackgroundColor3 = Color3.fromRGB(45,45,45)
Slider.Text = "Click to Increase Speed"
Slider.TextColor3 = Color3.new(1,1,1)
Slider.TextSize = 16
Slider.Parent = Frame

local speed = 16
Slider.MouseButton1Click:Connect(function()
    speed += 4
    if speed > 100 then speed = 16 end
    humanoid.WalkSpeed = speed
    SpeedLabel.Text = "WalkSpeed: " .. speed
end)


--====================================================
-- Fly System
--====================================================
local flying = false
local flySpeed = 50
local bodyGyro, bodyVel

local function startFly()
    flying = true
    
    bodyGyro = Instance.new("BodyGyro")
    bodyVel = Instance.new("BodyVelocity")

    bodyGyro.Parent = character:WaitForChild("HumanoidRootPart")
    bodyVel.Parent = character:WaitForChild("HumanoidRootPart")

    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 10000
    bodyGyro.CFrame = character.HumanoidRoot
