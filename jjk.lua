local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "JJS Modie Panel",
   LoadingTitle = "Baslatiliyor...",
   LoadingSubtitle = "by Modie",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Ana Menu", 4483362458)

-- // AYARLAR // --
local AutoBF = false
local BF_Key = Enum.KeyCode.V

-- // AUTO BLACK FLASH // --
MainTab:CreateToggle({
   Name = "Auto Black Flash (V)",
   CurrentValue = false,
   Callback = function(Value) AutoBF = Value end,
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == BF_Key and AutoBF then
        local vIM = game:GetService("VirtualInputManager")
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        vIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
        task.wait(0.29)
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        vIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
    end
end)

-- // ESP SISTEMI // --
MainTab:CreateButton({
   Name = "Oyuncu ESP (Highlight)",
   Callback = function()
       for _, v in pairs(game.Players:GetPlayers()) do
           if v ~= game.Players.LocalPlayer and v.Character then
               local hl = Instance.new("Highlight", v.Character)
               hl.FillColor = Color3.fromRGB(255, 0, 0)
           end
       end
   end,
})

Rayfield:Notify({ Title = "Yuklendi", Content = "Menuyu acmak icin INSERT tusunu kullan.", Duration = 5 })
