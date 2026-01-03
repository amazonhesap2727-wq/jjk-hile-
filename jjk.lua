-- // JJS DOGU ULTRA | V103 | XENO OPTIMIZED // --
repeat task.wait() until game:IsLoaded()

-- Rayfield Kütüphanesini Çekiyoruz
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // 🛠️ ANA PENCERE VE LOADING // --
local Window = Rayfield:CreateWindow({
   Name = "JJS DOGU ULTRA | XENO",
   LoadingTitle = "Sistemler Hazırlanıyor...",
   LoadingSubtitle = "by amazonhesap2727-wq",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false -- Key istemiyorsan false kalsın
})

-- // ⚙️ AYARLAR VE DEĞİŞKENLER // --
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

_G.MacroActive = false
_G.SelectedChar = "Yuji"
_G.FlySpeed = 150
_G.Flying = false
_G.ESP_Enabled = false

-- // ⚡ BLACK FLASH MAKROSU // --
local function ExecuteMacro()
    -- Yuji 0.28, Mahito 0.32 (Senin sevdiğin orijinal hızlar)
    local delay = (_G.SelectedChar == "Yuji" and 0.28 or 0.32)
    for i = 1, 3 do
        VIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
        task.wait(delay)
    end
end

-- // 👁️ ESP SİSTEMİ // --
local function UpdateESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local tag = p.Character:FindFirstChild("DoguESP")
            if _G.ESP_Enabled and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not tag then
                    tag = Instance.new("BillboardGui", p.Character)
                    tag.Name = "DoguESP"
                    tag.Size = UDim2.new(0, 100, 0, 40)
                    tag.AlwaysOnTop = true
                    tag.ExtentsOffset = Vector3.new(0, 3, 0)
                    local tl = Instance.new("TextLabel", tag)
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.TextColor3 = Color3.fromRGB(0, 255, 127) -- Yeşilimsi can rengi
                    tl.TextStrokeTransparency = 0
                    tl.TextSize = 14
                    tl.Font = Enum.Font.SourceSansBold
                end
                tag.TextLabel.Text = p.Name .. " [" .. math.floor(p.Character.Humanoid.Health) .. "]"
            elseif tag then
                tag:Destroy()
            end
        end
    end
end

-- // 🛠️ TABLAR (SEKMELER) // --
local Tab1 = Window:CreateTab("Savaş", 4483362458) -- Kılıç ikonu
local Tab2 = Window:CreateTab("Görsel", 4483345998) -- Göz ikonu
local Tab3 = Window:CreateTab("Hareket", 4483362748) -- Koşu ikonu

-- SAVAŞ SEKİMESİ
Tab1:CreateToggle({
    Name = "Black Flash Makro (V Tuşu)",
    CurrentValue = false,
    Callback = function(v) _G.MacroActive = v end
})

Tab1:CreateDropdown({
    Name = "Karakter Seçimi",
    Options = {"Yuji", "Mahito"},
    CurrentOption = {"Yuji"},
    Callback = function(v) _G.SelectedChar = v[1] end
})

-- GÖRSEL SEKİMESİ
Tab2:CreateToggle({
    Name = "Oyuncu ESP & Can Gösterimi",
    CurrentValue = false,
    Callback = function(v) _G.ESP_Enabled = v end
})

-- HAREKET SEKİMESİ
Tab3:CreateSlider({
    Name = "Fly (Uçuş) Hızı",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(v) _G.FlySpeed = v end
})

Tab3:CreateLabel("'H' Tuşu: Uçmayı Aç/Kapat")
Tab3:CreateLabel("WASD: Hareket | Space: Yukarı | Shift: Aşağı")

-- // ✈️ WASD FLY MOTORU // --
local function GetFlyVec()
    local v = Vector3.new(0,0,0)
    local cam = workspace.CurrentCamera.CFrame
    if UIS:IsKeyDown(Enum.KeyCode.W) then v = v + cam.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then v = v - cam.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then v = v - cam.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then v = v + cam.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then v = v + Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then v = v - Vector3.new(0,1,0) end
    return v.Unit
end

-- // 🔄 INPUT VE DÖNGÜ BAĞLANTILARI // --
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    -- V Tuşu Makro
    if input.KeyCode == Enum.KeyCode.V and _G.MacroActive then
        ExecuteMacro()
    end
    
    -- H Tuşu Fly
    if input.KeyCode == Enum.KeyCode.H then
        _G.Flying = not _G.Flying
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if _G.Flying and hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "DoguBV"
            bv.MaxForce = Vector3.new(1,1,1)*1e6
            
            local bg = Instance.new("BodyGyro", hrp)
            bg.Name = "DoguBG"
            bg.MaxTorque = Vector3.new(1,1,1)*1e6
            bg.P = 10000
            
            task.spawn(function()
                while _G.Flying and hrp and hrp.Parent do
                    local moveDir = GetFlyVec()
                    bv.Velocity = (moveDir.Magnitude > 0 and moveDir or Vector3.new(0,0,0)) * _G.FlySpeed
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    task.wait()
                end
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end)
        end
    end
end)

-- ESP Döngüsü
RS.RenderStepped:Connect(UpdateESP)

-- Bildirim Gönder (Açıldığını anlamak için)
Rayfield:Notify({
   Title = "BAŞARILI!",
   Content = "Dogu Ultra V103 Xeno Edition Yüklendi.",
   Duration = 5,
   Image = 4483362458,
})
