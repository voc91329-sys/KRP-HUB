local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityService = game:GetService("ProximityPromptService")

local Player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "KRP HUB", LoadingTitle = "LOADING...", LoadingSubtitle = "DOWNLOAD COMPLETED ✅️"})

local Tab = Window:CreateTab("SYSTEM", "settings")

local isNoHoldEnabled = false
Tab:CreateToggle({
    Name = "SKIP THE HOLD TIME",
    CurrentValue = false,
    Callback = function(Value) 
        isNoHoldEnabled = Value 
    end,
})

ProximityService.PromptButtonHoldBegan:Connect(function(prompt)
    if isNoHoldEnabled then 
        prompt.HoldDuration = 0 
    end
end)

local isJumpBoostEnabled = false
local jumpConnection
Tab:CreateToggle({
    Name = "THRUST", 
    CurrentValue = false,
    Callback = function(Value) 
        isJumpBoostEnabled = Value 
        if isJumpBoostEnabled then
            if not jumpConnection then
                jumpConnection = RunService.Heartbeat:Connect(function()
                    local char = Player.Character
                    if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if hrp and hum and hum:GetState() == Enum.HumanoidStateType.Jumping then
                        local look = hrp.CFrame.LookVector
                        hrp.AssemblyLinearVelocity = Vector3.new(look.X * 120, hrp.AssemblyLinearVelocity.Y, look.Z * 120)
                        task.wait(0.2)
                    end
                end)
            end
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end
})

local isSpeedBoostEnabled = false
local speedConnection
Tab:CreateToggle({
    Name = "RUN FAST", 
    CurrentValue = false, 
    Flag = "SpeedBoostToggle", 
    Callback = function(Value) 
        isSpeedBoostEnabled = Value 
        if isSpeedBoostEnabled then
            if not speedConnection then
                speedConnection = RunService.RenderStepped:Connect(function()
                    local char = Player.Character
                    if not char then return end
                    local hum = char:FindFirstChild("Humanoid")
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.MoveDirection.Magnitude > 0 then
                        local moveDir = hum.MoveDirection
                        hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * 80, hrp.AssemblyLinearVelocity.Y, moveDir.Z * 80)
                    end
                end)
            end
        else
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
        end
    end
})

local InfiniteJumpEnabled = false
local jumpReqConnection
Tab:CreateToggle({
    Name = "INFINITE DANCE",
    CurrentValue = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
        if InfiniteJumpEnabled then
            if not jumpReqConnection then
                jumpReqConnection = UserInputService.JumpRequest:Connect(function()
                    local char = Player.Character
                    if char then
                        local hum = char:FindFirstChild("Humanoid")
                        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                    end
                end)
            end
        else
            if jumpReqConnection then
                jumpReqConnection:Disconnect()
                jumpReqConnection = nil
            end
        end
    end
})

local NoclipEnabled = false
local noclipConnection
Tab:CreateToggle({
    Name = "NOCLIP",
    CurrentValue = false,
    Callback = function(Value)
        NoclipEnabled = Value
        if NoclipEnabled then
            if not noclipConnection then
                noclipConnection = RunService.Stepped:Connect(function()
                    local char = Player.Character
                    if char then
                        for _, v in pairs(char:GetChildren()) do
                            if v:IsA("BasePart") then 
                                v.CanCollide = false 
                            end
                        end
                    end
                end)
            end
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local char = Player.Character
            if char then
                for _, v in pairs(char:GetChildren()) do
                    if v:IsA("BasePart") then 
                        v.CanCollide = true 
                    end
                end
            end
        end
    end
})

local Flying = false
local FlySpeed = 50
local BodyVelocity, BodyGyro
local flyConnection

Tab:CreateToggle({
    Name = "FLY",
    CurrentValue = false,
    Callback = function(Value)
        Flying = Value
        local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        
        if Flying and hrp then
            if not BodyVelocity then
                BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                BodyVelocity.Parent = hrp
            end
            
            if not BodyGyro then
                BodyGyro = Instance.new("BodyGyro")
                BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                BodyGyro.CFrame = hrp.CFrame
                BodyGyro.Parent = hrp
            end
            
            if not flyConnection then
                flyConnection = RunService.RenderStepped:Connect(function()
                    local cam = workspace.CurrentCamera
                    if BodyGyro and BodyVelocity then
                        BodyGyro.CFrame = cam.CFrame
                        BodyVelocity.Velocity = cam.CFrame.LookVector * FlySpeed
                    end
                end)
            end
        else
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            if BodyVelocity then 
                BodyVelocity:Destroy() 
                BodyVelocity = nil 
            end
            if BodyGyro then 
                BodyGyro:Destroy() 
                BodyGyro = nil 
            end
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESP_Active = false
local ScanCounter = 0

local function CreateESP(Player)
    if Player == LocalPlayer or not Player.Character then return end
    local Head = Player.Character:FindFirstChild("Head")
    if not Head or Head:FindFirstChild("ESPTag") then return end
    
    local Bbg = Instance.new("BillboardGui", Head)
    Bbg.Name = "ESPTag"
    Bbg.AlwaysOnTop = true
    Bbg.Size = UDim2.new(0, 150, 0, 30)
    Bbg.StudsOffset = Vector3.new(0, 2, 0)
    
    local Txt = Instance.new("TextLabel", Bbg)
    Txt.Size = UDim2.new(1, 0, 1, 0)
    Txt.BackgroundTransparency = 1
    Txt.TextColor3 = Color3.fromRGB(0, 255, 140)
    Txt.TextStrokeTransparency = 0
    Txt.Font = Enum.Font.SourceSansBold
    Txt.TextSize = 13
end

local function Cleanup()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player.Character and Player.Character:FindFirstChild("Head") then
            local ESP = Player.Character.Head:FindFirstChild("ESPTag")
            if ESP then ESP:Destroy() end
        end
    end
end

local ToggleESP = Tab:CreateToggle({
    Name = "SEE ALL THE PLAYERS",
    CurrentValue = false,
    Flag = "SmartESP",
    Callback = function(Value)
        ESP_Active = Value
        if not Value then Cleanup() return end

        task.spawn(function()
            while ESP_Active do
                local MyHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local AllPlayers = Players:GetPlayers()
                
                if #AllPlayers > 1 then
                    ScanCounter = ScanCounter + 1
                    
                    for _, Player in pairs(AllPlayers) do
                        if Player ~= LocalPlayer then
                            if Player.Character and Player.Character:FindFirstChild("Head") then
                                local Head = Player.Character.Head
                                local Hrp = Player.Character:FindFirstChild("HumanoidRootPart")
                                
                                if not Head:FindFirstChild("ESPTag") then
                                    CreateESP(Player)
                                end
                                
                                local ESP = Head:FindFirstChild("ESPTag")
                                if ESP and Hrp and MyHrp then
                                    local Dist = math.floor((MyHrp.Position - Hrp.Position).Magnitude)
                                    ESP.TextLabel.Text = Player.DisplayName .. " [" .. Dist .. "m]"
                                end
                            end
                        end
                    end
                    
                    if ScanCounter >= 50 then 
                        for _, Player in pairs(AllPlayers) do
                            if Player.Character and Player.Character:FindFirstChild("Head") then
                                local ESP = Player.Character.Head:FindFirstChild("ESPTag")
                                if ESP and not Player.Character:FindFirstChild("HumanoidRootPart") then
                                    ESP:Destroy()
                                end
                            end
                        end
                        ScanCounter = 0
                    end
                end
                task.wait(10)
            end
        end)
    end,
})local SavedPosition = nil
local IsLocked = false
local CurrentGui = nil
local ButtonStage = 1

local TpButton
TpButton = Tab:CreateButton({
    Name = "OPEN GUI",
    Callback = function()
        if ButtonStage == 1 then
            -- GIAI ĐOẠN 1: Bấm để LƯU TỌA ĐỘ
            local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                SavedPosition = hrp.CFrame
                ButtonStage = 2
                
                -- Đổi tên nút thành "GUI TP" (Dùng pcall để tránh lỗi tùy phiên bản Rayfield)
                pcall(function() TpButton:Set({Name = "GUI TP"}) end) 
                Rayfield:Notify({Title = "THÀNH CÔNG", Content = "Đã lưu tọa độ! Bấm nút này 1 lần nữa để mở GUI.", Duration = 3})
            end
            
        elseif ButtonStage == 2 then
            -- GIAI ĐOẠN 2: Bấm để MỞ GUI
            if CurrentGui then return end
            
            local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
            local GuiBox = Instance.new("TextButton", ScreenGui) -- Dùng TextButton để bắt Click TP cực nhạy
            GuiBox.Size = UDim2.new(0, 45, 0, 45)
            GuiBox.Position = UDim2.new(0.5, 0, 0.5, 0)
            GuiBox.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            GuiBox.Text = "TP"
            GuiBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            GuiBox.Font = Enum.Font.SourceSansBold
            GuiBox.TextSize = 16
            
            local Corner = Instance.new("UICorner", GuiBox)
            Corner.CornerRadius = UDim.new(0, 10)
            CurrentGui = GuiBox

            -- LOGIC KÉO & CLICK CHUẨN
            local dragging = false
            local isMoving = false
            local dragStart, startPos

            -- Khi chạm vào / click vào
            GuiBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if not IsLocked then
                        dragging = true
                        isMoving = false
                        dragStart = input.Position
                        startPos = GuiBox.Position
                    end
                end
            end)

            -- Khi di chuyển (kéo)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    if delta.Magnitude > 5 then -- Nhích qua 5 pixel thì xác định là Đang Kéo
                        isMoving = true
                        GuiBox.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end
                end
            end)

            -- Khi thả tay / thả chuột
            UserInputService.InputEnded:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    dragging = false
                    
                    if isMoving then
                        -- Nếu vừa kéo xong, hiện 2 nút
                        if not GuiBox:FindFirstChild("YesBtn") then
                            local YesBtn = Instance.new("TextButton", GuiBox)
                            YesBtn.Name = "YesBtn"; YesBtn.Text = "Đồng ý"; YesBtn.Size = UDim2.new(0, 50, 0, 20); YesBtn.Position = UDim2.new(0, -10, 1, 5)
                            YesBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50); YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                            Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 5)
                            
                            local NoBtn = Instance.new("TextButton", GuiBox)
                            NoBtn.Name = "NoBtn"; NoBtn.Text = "Không"; NoBtn.Size = UDim2.new(0, 50, 0, 20); NoBtn.Position = UDim2.new(0, 45, 1, 5)
                            NoBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                            Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 5)
                            
                            YesBtn.MouseButton1Click:Connect(function()
                                IsLocked = true -- Khóa vĩnh viễn không cho kéo
                                YesBtn:Destroy()
                                NoBtn:Destroy()
                            end)
                            NoBtn.MouseButton1Click:Connect(function()
                                YesBtn:Destroy()
                                NoBtn:Destroy()
                            end)
                        end
                    end
                    
                    -- Trì hoãn 0.1s trước khi reset trạng thái isMoving để không bị nhầm với Click
                    task.delay(0.1, function() isMoving = false end)
                end
            end)

            -- SỰ KIỆN CLICK ĐỂ TP (Hoạt động kể cả khi đã khóa)
            GuiBox.MouseButton1Click:Connect(function()
                if not isMoving then
                    local currentHrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    if currentHrp and SavedPosition then
                        currentHrp.CFrame = SavedPosition
                    end
                end
            end)
        end
    end,
})

local VersionTab = Window:CreateTab("VERSION", "info")

VersionTab:CreateLabel("VERSION: 1")
VersionTab:CreateLabel("FIX LEVEL: 23")
VersionTab:CreateLabel("ERROR: 0")
VersionTab:CreateLabel("LEVEL: MEDIUM")
VersionTab:CreateLabel("SUPPORT: 32BIT+64BIT")
VersionTab:CreateLabel("PROGRESS: 20%")
VersionTab:CreateLabel("Awaiting Advanced Bug Fixes...")
VersionTab:CreateLabel("UPGRADE: DO NOT HAVE")
VersionTab:CreateLabel("Fix lag: ✅️")
VersionTab:CreateLabel("UPDATE: 1.1")
VersionTab:CreateLabel("GAME BOOSTER")
VersionTab:CreateButton({
    Name = "BOOST",
    Callback = function()
        Rayfield:Notify({Title = "MAX POWER", Content = "ACTIVATED AT 100% POWER", Duration = 5})
        
        task.delay(5, function()
            local l = game:GetService("Lighting")
            local w = game:GetService("Workspace")
            local m = game:GetService("MaterialService")
            local t = w:FindFirstChildOfClass("Terrain")
            
            pcall(function()
                l.GlobalShadows = false
                l.Technology = Enum.Technology.Compatibility
                l.FogEnd = 9e9
                l.FogStart = 9e9
                l.Brightness = 0
                l.ClockTime = 12
                m.Use2022Materials = false
            end)
            
            if t then
                pcall(function()
                    t.WaterWaveSize = 0
                    t.WaterReflectivity = 0
                    t.WaterTransparency = 1
                    t.Decoration = false
                end)
            end
            
            local r = {
                ["Trail"]=true, ["Fire"]=true, ["Smoke"]=true, ["Sparkles"]=true, ["Beam"]=true, 
                ["Explosion"]=true, ["PointLight"]=true, ["SpotLight"]=true, ["SurfaceLight"]=true, 
                ["Decal"]=true, ["Texture"]=true, ["BloomEffect"]=true, ["BlurEffect"]=true, 
                ["ColorCorrectionEffect"]=true, ["DepthOfFieldEffect"]=true, ["SunRaysEffect"]=true, 
                ["Highlight"]=true, ["Atmosphere"]=true, ["Sky"]=true, ["Clouds"]=true, ["ForceField"]=true,
                ["ParticleEmitter"]=true, ["SurfaceAppearance"]=true, ["WrapLayer"]=true, ["WrapTarget"]=true
            }
            
            local d = game:GetDescendants()
            for i = 1, #d do
                local o = d[i]
                if r[o.ClassName] == true then
                    pcall(function() o:Destroy() end)
                elseif o:IsA("BasePart") and not o:IsA("Terrain") then
                    pcall(function()
                        o.Material = Enum.Material.SmoothPlastic
                        o.Reflectance = 0
                        o.CastShadow = false
                    end)
                elseif o:IsA("MeshPart") then
                    pcall(function()
                        o.TextureID = ""
                        o.Material = Enum.Material.SmoothPlastic
                        o.Reflectance = 0
                        o.CastShadow = false
                    end)
                end
                
                if i % 200 == 0 then task.wait() end
            end
            
            Rayfield:Notify({Title = "SUCCESSFUL", Content = "ACTIVATED AT 100% POWER", Duration = 3})
        end)
    end
})
-- ==========================================
-- TAB SOUND - HỆ THỐNG ÂM THANH (ĐÃ NÂNG CẤP)
-- ==========================================
local SoundTab = Window:CreateTab("SOUND", "music")

local currentSound = nil
local originalVolumes = {} -- Bảng lưu âm lượng gốc
local isMusicActive = false

-- Hàm lưu và tắt âm thanh game
local function MuteGameSounds()
    originalVolumes = {} -- Reset danh sách
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Sound") and obj ~= currentSound then
            -- Chỉ lưu nếu nó đang có âm lượng > 0
            if obj.Volume > 0 then
                originalVolumes[obj] = obj.Volume
                obj.Volume = 0
            end
        end
    end
end

-- Hàm khôi phục âm thanh game
local function RestoreGameSounds()
    for sound, vol in pairs(originalVolumes) do
        if sound then
            sound.Volume = vol
        end
    end
    originalVolumes = {} -- Xóa dữ liệu sau khi khôi phục
end

-- Theo dõi âm thanh mới xuất hiện khi nhạc đang phát
local soundConnection
soundConnection = game.DescendantAdded:Connect(function(obj)
    if isMusicActive and obj:IsA("Sound") and obj ~= currentSound then
        task.wait(0.1) -- Đợi load thuộc tính
        originalVolumes[obj] = obj.Volume
        obj.Volume = 0
    end
end)

-- Hàm xử lý phát nhạc
local function PlayMusic(audioId)
    -- Nếu đang có nhạc phát thì tắt
    if currentSound then
        currentSound:Stop()
        currentSound:Destroy()
    end
    
    -- Tạo nhạc mới
    currentSound = Instance.new("Sound")
    currentSound.SoundId = "rbxassetid://" .. tostring(audioId)
    currentSound.Looped = true
    currentSound.Volume = 1
    currentSound.Parent = game:GetService("CoreGui")
    currentSound:Play()
    
    -- Bật chế độ im lặng game
    isMusicActive = true
    MuteGameSounds()
    
    Rayfield:Notify({Title = "KRP HUB", Content = "Đã tắt tiếng game, chỉ phát nhạc!", Duration = 2})
end

-- Nút phát nhạc
SoundTab:CreateButton({ Name = "Khô gà", Callback = function() PlayMusic(110919391228823) end })
SoundTab:CreateButton({ Name = "Ai đưa em về", Callback = function() PlayMusic(99152674992699) end })
SoundTab:CreateButton({ Name = "Nam mô a di phật", Callback = function() PlayMusic(87611934554080) end })
SoundTab:CreateButton({ Name = "Tinh vệ", Callback = function() PlayMusic(124384558101360) end })

-- Nút Xóa nhạc và khôi phục âm thanh
SoundTab:CreateButton({
    Name = "❌ XÓA NHẠC & BẬT TIẾNG GAME",
    Callback = function()
        if currentSound then
            currentSound:Stop()
            currentSound:Destroy()
            currentSound = nil
        end
        
        isMusicActive = false
        RestoreGameSounds() -- Khôi phục lại âm thanh game
        
        Rayfield:Notify({Title = "KRP HUB", Content = "Đã tắt nhạc, khôi phục âm thanh game!", Duration = 2})
    end,
})
