return function()
    -- Wrap the entire script in a function for loadstring
return function()
    --=========================
    -- Modern Tabbed UI with Smooth Fly & Animations
    -- Safe, fully functional for your own Roblox game
    --=========================

    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local HRP = char:WaitForChild("HumanoidRootPart")
    local UIS = game:GetService("UserInputService")
    local RS = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    --=========================
    -- GUI SETUP
    --=========================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TabbedUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 350, 0, 450)
    Frame.Position = UDim2.new(0.05, 0, 0.25, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(80,80,80)
    UIStroke.Thickness = 2
    UIStroke.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,50)
    Title.Position = UDim2.new(0,0,0,0)
    Title.BackgroundTransparency = 1
    Title.Text = "Modern Control Panel"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 28
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Parent = Frame

    -- Animate panel fade-in
    Frame.BackgroundTransparency = 1
    TweenService:Create(Frame, TweenInfo.new(0.5), {BackgroundTransparency = 0.15}):Play()

    --=========================
    -- Tab Buttons
    --=========================
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1,0,0,40)
    TabContainer.Position = UDim2.new(0,0,0,50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Frame

    local function NewTabButton(text, xPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 1, 0)
        btn.Position = UDim2.new(0, xPos, 0, 0)
        btn.Text = text
        btn.TextSize = 18
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.AutoButtonColor = true
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0,12)
        btn.Parent = TabContainer
        -- hover animation
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
        end)
        return btn
    end

    local MovementTabBtn = NewTabButton("Movement", 10)
    local ESPTabBtn = NewTabButton("ESP", 120)
    local SettingsTabBtn = NewTabButton("Settings", 230)

    --=========================
    -- Pages
    --=========================
    local function NewPage()
        local page = Instance.new("Frame")
        page.Size = UDim2.new(1,0,1,-100)
        page.Position = UDim2.new(0,0,0,100)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = Frame
        return page
    end

    local MovementPage = NewPage()
    local ESPPage = NewPage()
    local SettingsPage = NewPage()

    local Pages = {["Movement"]=MovementPage, ["ESP"]=ESPPage, ["Settings"]=SettingsPage}

    local function switchPage(name)
        for k,v in pairs(Pages) do
            v.Visible = (k==name)
            -- smooth fade in
            if v.Visible then
                v.BackgroundTransparency = 1
                TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            end
        end
    end

    switchPage("Movement")
    MovementTabBtn.MouseButton1Click:Connect(function() switchPage("Movement") end)
    ESPTabBtn.MouseButton1Click:Connect(function() switchPage("ESP") end)
    SettingsTabBtn.MouseButton1Click:Connect(function() switchPage("Settings") end)

    --=========================
    -- Helper Functions
    --=========================
    local function NewButton(parent,text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9,0,0,40)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        btn.Text = text
        btn.TextSize = 18
        btn.Font = Enum.Font.Gotham
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0,12)
        btn.Parent = parent
        -- hover animation
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
        end)
        return btn
    end

    local function NewSlider(parent,labelText,defaultValue,maxValue)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0.9,0,0,60)
        container.BackgroundTransparency = 1
        container.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,0,25)
        label.BackgroundTransparency = 1
        label.Text = labelText..": "..defaultValue
        label.Font = Enum.Font.Gotham
        label.TextSize = 18
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Parent = container

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1,0,0,10)
        bar.Position = UDim2.new(0,0,0,30)
        bar.BackgroundColor3 = Color3.fromRGB(70,70,70)
        local corner = Instance.new("UICorner", bar)
        corner.CornerRadius = UDim.new(0,8)
        bar.Parent = container

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(defaultValue/maxValue,0,1,0)
        fill.BackgroundColor3 = Color3.fromRGB(0,255,200)
        local fillCorner = Instance.new("UICorner", fill)
        fillCorner.CornerRadius = UDim.new(0,8)
        fill.Parent = bar

        return container, bar, fill, label
    end

    --=========================
    -- Movement Page: WalkSpeed Slider
    --=========================
    local speed = 16
    local maxSpeed = 100
    local sliderContainer, sliderBar, sliderFill, sliderLabel = NewSlider(MovementPage,"WalkSpeed",speed,maxSpeed)
    local dragging = false

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    RS.RenderStepped:Connect(function()
        if dragging then
            local mouseX = UIS:GetMouseLocation().X
            local barPos = sliderBar.AbsolutePosition.X
            local barSize = sliderBar.AbsoluteSize.X
            local pct = math.clamp((mouseX-barPos)/barSize,0,1)
            speed = 16 + math.floor(pct*(maxSpeed-16))
            sliderFill.Size = UDim2.new(pct,0,1,0)
            sliderLabel.Text = "WalkSpeed: "..speed
            humanoid.WalkSpeed = speed
        end
    end)

    --=========================
    -- Smooth Fly System
    --=========================
    local flying = false
    local flySpeed = 50
    local bodyGyro, bodyVel

    local function startFly()
        flying = true
        bodyGyro = Instance.new("BodyGyro", HRP)
        bodyVel = Instance.new("BodyVelocity", HRP)
        bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bodyGyro.P = 10000
        bodyGyro.CFrame = HRP.CFrame
        bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)

        RS.RenderStepped:Connect(function()
            if flying then
                local moveDir = Vector3.new()
                local cam = workspace.CurrentCamera
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
                moveDir = Vector3.new(moveDir.X,0,moveDir.Z)
                bodyVel.Velocity = moveDir*flySpeed
                bodyGyro.CFrame = cam.CFrame
            end
        end)
    end

    local function stopFly()
        flying=false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVel then bodyVel:Destroy() end
    end

    local FlyBtn = NewButton(MovementPage,"Toggle Fly")
    FlyBtn.MouseButton1Click:Connect(function()
        if flying then stopFly() FlyBtn.Text="Toggle Fly"
        else startFly() FlyBtn.Text="Stop Fly" end
    end)

    --=========================
    -- ESP Page
    --=========================
    local espEnabled=false
    local function toggleESP()
        espEnabled=not espEnabled
        for _,plr in pairs(game.Players:GetPlayers()) do
            if plr.Character and plr~=player then
                local highlight=plr.Character:FindFirstChild("ESP_Highlight")
                if espEnabled then
                    if not highlight then
                        highlight=Instance.new("Highlight")
                        highlight.Name="ESP_Highlight"
                        highlight.FillColor=Color3.fromRGB(0,255,0)
                        highlight.OutlineColor=Color3.fromRGB(255,255,255)
                        highlight.Parent=plr.Character
                    end
                else
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end

    local ESPBtn = NewButton(ESPPage,"Toggle ESP")
    ESPBtn.MouseButton1Click:Connect(toggleESP)

    --=========================
    -- Settings Page
    --=========================
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1,0,0,40)
    InfoLabel.Position = UDim2.new(0,0,0,20)
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Text = "Press RightShift to toggle UI"
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 18
    InfoLabel.TextColor3 = Color3.fromRGB(255,255,255)
    InfoLabel.Parent = SettingsPage

    --=========================
    -- UI Toggle
    --=========================
    local uiOpen = true
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode==Enum.KeyCode.RightShift then
            uiOpen=not uiOpen
            if uiOpen then
                Frame.Visible=true
                TweenService:Create(Frame,TweenInfo.new(0.3),{Position=UDim2.new(0.05,0,0.25,0)}):Play()
            else
                TweenService:Create(Frame,TweenInfo.new(0.3),{Position=UDim2.new(-0.5,0,0.25,0)}):Play()
                task.delay(0.3,function() Frame.Visible=false end)
            end
        end
    end)
    end
end
