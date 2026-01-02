-- // BY DOGU - PRO-LEGIT V38.0 // --
repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "JJS Dogu Ultra | V38.0",
   LoadingTitle = "Gecikmesiz V-Combo & Tam Legit Mod!",
   ConfigurationSaving = { Enabled = false }
})

local CombatTab = Window:CreateTab("Savaş/Makro", 4483362458)
local MoveTab = Window:CreateTab("Hareket", 4483362458)
local VisualTab = Window:CreateTab("Görsel", 4483362458)

local lp = game.Players.LocalPlayer
local ESP_Active, ESP_Color = false, Color3.fromRGB(255, 0, 0)
local SelectedChar = "Yuji"
local AutoBF_Active = false
local isComboing = false
local WalkSpeed = 16

-- // 1. GERÇEK ZAMANLI STUN KONTROLÜ // --
local function IsStunned()
    local char = lp.Character
    if not char then return true end
    -- JJS'de dayak yerken bu objeler karakterin içine gelir
    return char:FindFirstChild("Stun") or char:FindFirstChild("RagdollConfig") or char:FindFirstChild("Knockdown")
end

local function IsAttacking()
    local char = lp.Character
    if not char then return true end
    -- Skill kullanırken hareket etmeyi engeller
    return char:FindFirstChild("Action") or char:FindFirstChild("Attacking")
end

-- // 2. HAREKET MOTORU (Geliştirilmiş) // --
task.spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        local char = lp.Character
        if char and char:FindFirstChild("Humanoid") then
            if IsStunned() or IsAttacking() then
                -- EĞER COMBO YİYORSAN VEYA SKİLL ATIYORSAN HIZI SIFIRLA (TAM LEGIT)
                char.Humanoid.WalkSpeed = 0
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0) -- Kaymayı durdurur
            else
                -- SADECE SERBESTKEN HIZ HİLESİ ÇALIŞIR
                char.Humanoid.WalkSpeed = WalkSpeed
            end
        end
    end)
end)

-- // 3. INSTANT 3-CHAIN BLACK FLASH // --
local ComboSettings = {
    ["Yuji"] = {t1 = 0.28, t2 = 0.30}, -- Gecikme düşürüldü
    ["Mahito"] = {t1 = 0.31, t2 = 0.32}
}

local function DoTripleChain()
    if isComboing or IsStunned() then return end
    isComboing = true
    
    local vIM = game:GetService("VirtualInputManager")
    local settings = ComboSettings[SelectedChar]
    local key = Enum.KeyCode.Three
    
    -- VURUM 1 (Anında)
    vIM:SendKeyEvent(true, key, false, game)
    task.wait(0.01)
    vIM:SendKeyEvent(false, key, false, game)
    
    task.wait(settings.t1)
    
    -- VURUM 2
    vIM:SendKeyEvent(true, key, false, game)
    task.wait(0.01)
    vIM:SendKeyEvent(false, key, false, game)
    
    task.wait(settings.t2)
    
    -- VURUM 3
    vIM:SendKeyEvent(true, key, false, game)
    task.wait(0.01)
    vIM:SendKeyEvent(false, key, false, game)
    
    task.wait(0.3)
    isComboing = false
end

-- // PANEL // --
CombatTab:CreateDropdown({
    Name = "Karakter Seç", 
    Options = {"Yuji", "Mahito"}, 
    CurrentOption = {"Yuji"}, 
    Callback = function(v) SelectedChar = v[1] end
})

CombatTab:CreateToggle({
    Name = "Instant Black Flash (V)", 
    CurrentValue = false, 
    Callback = function(v) AutoBF_Active = v end
})

MoveTab:CreateSlider({
    Name = "Hız (Legit Limit)", 
    Range = {16, 45}, 
    Increment = 1, 
    CurrentValue = 16, 
    Callback = function(v) WalkSpeed = v end
})

VisualTab:CreateToggle({
    Name = "Player ESP", 
    CurrentValue = false, 
    Callback = function(v) ESP_Active = v end
})

VisualTab:CreateColorPicker({
    Name = "ESP Rengi", 
    Color = Color3.fromRGB(255, 0, 0), 
    Callback = function(v) ESP_Color = v end
})

-- TUŞ DİNLEYİCİ
game:GetService("UserInputService").InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.V and AutoBF_Active then
        DoTripleChain()
    end
end)

-- ESP DÖNGÜSÜ
task.spawn(function()
    while task.wait(1) do
        if ESP_Active then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    local hl = p.Character:FindFirstChild("DoguHL") or Instance.new("Highlight", p.Character)
                    hl.Name = "DoguHL"; hl.FillColor = ESP_Color; hl.DepthMode = "AlwaysOnTop"
                end
            end
        end
    end
end)
