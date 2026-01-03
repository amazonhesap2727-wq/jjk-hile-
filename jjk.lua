-- // JJS DOGU ULTRA | V102 FIXED // --
if not game:IsLoaded() then game.Loaded:Wait() end

-- Basit ve Hatasız Loading Bildirimi
local sg = Instance.new("ScreenGui", game.CoreGui)
local txt = Instance.new("TextLabel", sg)
txt.Size = UDim2.new(1, 0, 1, 0)
txt.BackgroundTransparency = 0.5
txt.BackgroundColor3 = Color3.new(0,0,0)
txt.TextColor3 = Color3.new(0, 0.7, 1)
txt.TextSize = 30
txt.Font = Enum.Font.GothamBold
txt.Text = "JJS DOGU ULTRA YÜKLENİYOR... %0"

-- Adım Adım Yükleme (Xeno Dostu)
local function setLoad(p, t)
    txt.Text = "JJS DOGU ULTRA: " .. t .. " [" .. p .. "%]"
    task.wait(0.4)
end

setLoad(20, "Makrolar Hazırlanıyor")
setLoad(50, "Uçuş Motoru Bağlanıyor")
setLoad(80, "ESP Verileri Alınıyor")
setLoad(100, "Sistem Aktif!")
sg:Destroy()

-- // ANA PANEL // --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "JJS Dogu Ultra | XENO",
   LoadingTitle = "Dogu Ultra V102",
   ConfigurationSaving = { Enabled = false }
})

local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

_G.MacroActive = false
_G.SelectedChar = "Yuji"
_G.FlySpeed = 150
_G.Flying = false
_G.ESP_Enabled = false

-- ⚡ BF MAKRO (V TUŞU)
local function DoBF()
    local delay = (_G.SelectedChar == "Yuji" and 0.28 or 0.32)
    for i = 1, 3 do
        VIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
        task.wait(delay)
    end
end

-- 👁️ ESP
task.spawn(function()
    while task.wait(0.5) do
        if _G.ESP_Enabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
                    local tag = p.Character:FindFirstChild("DoguESP") or Instance.new("BillboardGui", p.Character)
                    tag.Name = "DoguESP"
                    tag.Size = UDim2.new(0, 100, 0, 40)
                    tag.AlwaysOnTop = true
                    tag.ExtentsOffset = Vector3.new(0, 3, 0)
                    local tl = tag:FindFirstChild("TextLabel") or Instance.new("TextLabel", tag)
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.TextColor3 = Color3.new(1, 1, 1)
                    tl.Text = p.Name .. " [" .. math.floor(p.Character.Humanoid.Health) .. "]"
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("DoguESP") then p.Character.DoguESP:Destroy() end
            end
        end
    end
end)

-- 🛠️ TABS
local Tab1 = Window:CreateTab("Savaş")
local Tab2 = Window:CreateTab("Görsel")
local Tab3 = Window:CreateTab("Hareket")

Tab1:CreateToggle({Name = "Black Flash Makro (V)", CurrentValue = false, Callback = function(v) _G.MacroActive = v end})
Tab1:CreateDropdown({Name = "Karakter", Options = {"Yuji", "Mahito"}, CurrentOption = {"Yuji"}, Callback = function(v) _G.SelectedChar = v[1] end})
Tab2:CreateToggle({Name = "ESP & Can Görme", CurrentValue = false, Callback = function(v) _G.ESP_Enabled = v end})
Tab3:CreateSlider({Name = "Fly Hızı", Range = {50, 500}, Increment = 10, CurrentValue = 150, Callback = function(v) _G.FlySpeed = v end})

-- ✈️ WASD FLY SİSTEMİ
local function GetMove()
    local v = Vector3.new(0,0,0)
    local c = workspace.CurrentCamera.CFrame
    if UIS:IsKeyDown("W") then v = v + c.LookVector end
    if UIS:IsKeyDown("S") then v = v - c.LookVector end
    if UIS:IsKeyDown("A") then v = v - c.RightVector end
    if UIS:IsKeyDown("D") then v = v + c.RightVector end
    if UIS:IsKeyDown("Space") then v = v + Vector3.new(0,1,0) end
    if UIS:IsKeyDown("LeftShift") then v = v - Vector3.new(0,1,0) end
    return v.Unit
end

UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.V and _G.MacroActive then DoBF() end
    if i.KeyCode == Enum.KeyCode.H then
        _G.Flying = not _G.Flying
        local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
        if _G.Flying and hrp then
            local bv = Instance.new("BodyVelocity", hrp)
            local bg = Instance.new("BodyGyro", hrp)
            bv.MaxForce = Vector3.new(1,1,1)*1e6
            bg.MaxTorque = Vector3.new(1,1,1)*1e6
            task.spawn(function()
                while _G.Flying and hrp.Parent do
                    local m = GetMove()
                    bv.Velocity = (m.Magnitude > 0 and m or Vector3.new(0,0,0)) * _G.FlySpeed
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    task.wait()
                end
                bv:Destroy() bg:Destroy()
            end)
        end
    end
end)
