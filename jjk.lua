-- // BY DOGU - PARRY FIX V28.0 // --
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "JJS Dogu Ultra | V28.0",
   LoadingTitle = "Parry Sistemi Güncellendi!",
   ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Savaş/Combat", 4483362458)
local VisualTab = Window:CreateTab("Görsel/ESP", 4483362458)
local MoveTab = Window:CreateTab("Hareket", 4483362458)

local lp = game.Players.LocalPlayer
local AutoParry = false
local AutoBF = false
local Flying = false
local FlySpeed = 50
local WalkSpeed = 16
local DomainBypass = false

-- // 1. YENİ NESİL AUTO PARRY (Remote & Proximity Based) // --
task.spawn(function()
    while task.wait(0.01) do -- Çok hızlı döngü
        if AutoParry and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = p.Character.HumanoidRootPart
                    local dist = (lp.Character.HumanoidRootPart.Position - targetHrp.Position).Magnitude
                    
                    -- Eğer rakip 10 block yakınındaysa ve hareket hızı vuruş pozisyonundaysa
                    if dist < 12 then
                        local vIM = game:GetService("VirtualInputManager")
                        -- F Tuşuna seri bas-çek (Perfect Block yakalamak için)
                        vIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        task.wait(0.05)
                        vIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                    end
                end
            end
        end
    end
end)

-- // 2. ANA HAREKET & SPEED // --
task.spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            if Flying then
                local root = lp.Character.HumanoidRootPart
                local cam = workspace.CurrentCamera
                local dir = Vector3.new(0,0,0)
                local uis = game:GetService("UserInputService")
                if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
                root.Velocity = dir * FlySpeed
                lp.Character.Humanoid.PlatformStand = true
            else
                lp.Character.Humanoid.WalkSpeed = WalkSpeed
                lp.Character.Humanoid.PlatformStand = false
            end
            
            if DomainBypass then
                for _, v in pairs(lp.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end)
end)

-- // 3. PANEL ELEMENTLERİ // --
CombatTab:CreateToggle({Name = "Auto Parry (Agresif)", CurrentValue = false, Callback = function(v) AutoParry = v end})
CombatTab:CreateToggle({Name = "Auto Black Flash (V)", CurrentValue = false, Callback = function(v) AutoBF = v end})

VisualTab:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(v) _G.ESP = v end})
VisualTab:CreateToggle({Name = "Görünmezlik (Ghost)", CurrentValue = false, Callback = function(v) 
    if lp.Character then
        for _, part in pairs(lp.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name ~= "HumanoidRootPart" then part.Transparency = v and 1 or 0 end
            end
        end
    end
end})

MoveTab:CreateToggle({Name = "Domain Bypass", CurrentValue = false, Callback = function(v) DomainBypass = v end})
MoveTab:CreateSlider({Name = "Hız", Range = {16, 200}, Increment = 1, CurrentValue = 16, Callback = function(v) WalkSpeed = v end})
MoveTab:CreateSlider({Name = "Uçuş Hızı (H)", Range = {10, 300}, Increment = 1, CurrentValue = 50, Callback = function(v) FlySpeed = v end})

-- // 4. TUŞLAR VE ESP // --
game:GetService("UserInputService").InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.H then Flying = not Flying
    elseif i.KeyCode == Enum.KeyCode.V and AutoBF then
        local vIM = game:GetService("VirtualInputManager")
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        task.wait(0.29)
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.ESP then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hl = p.Character:FindFirstChild("DoguHL") or Instance.new("Highlight", p.Character)
                    hl.Name = "DoguHL"; hl.FillColor = Color3.fromRGB(255, 0, 0); hl.DepthMode = "AlwaysOnTop"
                end
            end
        end
    end
end)
