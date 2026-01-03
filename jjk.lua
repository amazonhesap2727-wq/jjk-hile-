-- // JJS DOGU ULTRA V97.0 | FULL STABLE // --
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "JJS Dogu Ultra | V97.0",
   LoadingTitle = "Görsel ve Savaş Sistemleri Yükleniyor...",
   ConfigurationSaving = { Enabled = false }
})

local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- // AYARLAR // --
_G.MacroActive = false
_G.SelectedChar = "Yuji"
_G.FlySpeed = 150
_G.Flying = false
_G.ESP_Enabled = false

-- // 👁️ SADE ESP SİSTEMİ // --
local function UpdateESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local hum = p.Character:FindFirstChild("Humanoid")
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            
            local tag = p.Character:FindFirstChild("DoguESP")
            if _G.ESP_Enabled and hum and hrp and hum.Health > 0 then
                if not tag then
                    tag = Instance.new("BillboardGui", p.Character)
                    tag.Name = "DoguESP"
                    tag.Size = UDim2.new(0, 150, 0, 50)
                    tag.AlwaysOnTop = true
                    tag.ExtentsOffset = Vector3.new(0, 3, 0)
                    
                    local tl = Instance.new("TextLabel", tag)
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    tl.TextStrokeTransparency = 0
                    tl.TextSize = 14
                    tl.Font = Enum.Font.SourceSansBold
                end
                tag.TextLabel.Text = string.format("%s\n[HP: %d]", p.Name, math.floor(hum.Health))
            else
                if tag then tag:Destroy() end
            end
        end
    end
end

-- // ⚡ BF MAKROSU // --
local function DoBF()
    local delayTime = (_G.SelectedChar == "Yuji" and 0.28 or 0.32)
    for i = 1, 3 do
        VIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
        task.wait(delayTime)
    end
end

-- // 🛠️ PANEL // --
local Main = Window:CreateTab("Savaş")
local Vis = Window:CreateTab("Görsel")
local Move = Window:CreateTab("Hareket")

Main:CreateToggle({Name = "Black Flash Makrosu (V)", CurrentValue = false, Callback = function(v) _G.MacroActive = v end})
Main:CreateDropdown({Name = "Karakter", Options = {"Yuji", "Mahito"}, CurrentOption = {"Yuji"}, Callback = function(v) _G.SelectedChar = v[1] end})

Vis:CreateToggle({Name = "Oyuncu ESP & Can", CurrentValue = false, Callback = function(v) _G.ESP_Enabled = v end})

Move:CreateSlider({Name = "Uçma Hızı", Range = {50, 500}, Increment = 10, CurrentValue = 150, Callback = function(v) _G.FlySpeed = v end})

-- // ✈️ WASD UÇUŞ MOTORU // --
local function GetMoveVec()
    local vec = Vector3.new(0,0,0)
    local cam = workspace.CurrentCamera
    if UIS:IsKeyDown(Enum.KeyCode.W) then vec = vec + cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then vec = vec - cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then vec = vec - cam.CFrame.LookVector:Cross(Vector3.new(0,1,0)) end
    if UIS:IsKeyDown(Enum.KeyCode.D) then vec = vec + cam.CFrame.LookVector:Cross(Vector3.new(0,1,0)) end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then vec = vec + Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vec = vec - Vector3.new(0,1,0) end
    return vec.Magnitude > 0 and vec.Unit or Vector3.new(0,0,0)
end

-- Input İşlemleri
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.V and _G.MacroActive then DoBF() end
    if input.KeyCode == Enum.KeyCode.H then
        _G.Flying = not _G.Flying
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if _G.Flying and hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(1,1,1) * 1e6
            local bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(1,1,1) * 1e6
            task.spawn(function()
                while _G.Flying and hrp and hrp.Parent do
                    bv.Velocity = GetMoveVec() * _G.FlySpeed
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    task.wait()
                end
                bv:Destroy() bg:Destroy()
            end)
