local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7Lib/UI-Libraries/main/Venyx/Source.lua"))()
local Window = Library.new("JJS Ultra Panel", 5013109572)

-- // SERVICES // --
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local vIM = game:GetService("VirtualInputManager")

-- // SETTINGS // --
local ESP_Enabled = false
local ItemESP_Enabled = false
local AutoBF_Enabled = false
local BF_Key = Enum.KeyCode.V
local MenuKey = Enum.KeyCode.Insert

-- // TABS // --
local MainTab = Window.add_page("Ana Menü")
local CombatSection = MainTab.add_section("Dövüş")
local VisualSection = MainTab.add_section("Görsel (ESP)")

-- // AUTO BLACK FLASH LOGIC // --
CombatSection.add_toggle("Auto Black Flash (V)", false, function(state)
    AutoBF_Enabled = state
end)

userInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == BF_Key and AutoBF_Enabled then
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        vIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
        task.wait(0.29)
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        vIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
        task.wait(0.30)
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        vIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
    end
end)

-- // PLAYER ESP // --
VisualSection.add_toggle("Oyuncu ESP", false, function(state)
    ESP_Enabled = state
    if not state then
        for _, v in pairs(players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("Highlight") then
                v.Character.Highlight:Destroy()
            end
        end
    end
end)

runService.RenderStepped:Connect(function()
    if ESP_Enabled then
        for _, v in pairs(players:GetPlayers()) do
            if v ~= players.LocalPlayer and v.Character then
                if not v.Character:FindFirstChild("Highlight") then
                    local hl = Instance.new("Highlight", v.Character)
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end)

-- // ITEM ESP // --
VisualSection.add_toggle("Eşya ESP", false, function(state)
    ItemESP_Enabled = state
end)

-- // MENU TOGGLE // --
local toggled = true
userInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == MenuKey then
        toggled = not toggled
        Window.toggle()
    end
end)

print("JJS Ultra Panel Yuklendi! INSERT ile ac/kapat.")
