local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "JJS Modie Ultra Panel",
   LoadingTitle = "ESP ve Esya Takibi Yukleniyor...",
   LoadingSubtitle = "by Modie",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Ana Menu", 4483362458)

-- // AYARLAR // --
local AutoBF = false
local ESP_Active = false
local ItemESP_Active = false

-- // ITEM ESP FONKSIYONU // --
local function CreateItemESP(item)
    if ItemESP_Active and (item:IsA("Tool") or item:IsA("Model")) then
        task.wait(0.2)
        if not item:FindFirstChild("ItemHighlight") then
            local hl = Instance.new("Highlight", item)
            hl.Name = "ItemHighlight"
            hl.FillColor = Color3.fromRGB(0, 255, 0) -- Esyalar Yesil
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end

-- // TAB SECTIONS // --
MainTab:CreateSection("Gorsel Ayarlar (ESP)")

-- OYUNCU ESP TOGGLE
MainTab:CreateToggle({
   Name = "Dinamik Oyuncu ESP",
   CurrentValue = false,
   Callback = function(Value)
       ESP_Active = Value
       if not Value then
           for _, p in pairs(game.Players:GetPlayers()) do
               if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
           end
       end
   end,
})

-- ESYA ESP TOGGLE
MainTab:CreateToggle({
   Name = "Esya ESP (Parmak/Item)",
   CurrentValue = false,
   Callback = function(Value)
       ItemESP_Active = Value
       if Value then
           for _, v in pairs(game.Workspace:GetChildren()) do CreateItemESP(v) end
       else
           for _, v in pairs(game.Workspace:GetChildren()) do
               if v:FindFirstChild("ItemHighlight") then v.ItemHighlight:Destroy() end
           end
       end
   end,
})

-- // OTOMATIK TAKIP (YENI GELENLER ICIN) // --
game.Workspace.ChildAdded:Connect(function(child)
    if ItemESP_Active then CreateItemESP(child) end
end)

MainTab:CreateSection("Dovus Ayarlari")

-- AUTO BLACK FLASH (V)
MainTab:CreateToggle({
   Name = "Auto Black Flash (V)",
   CurrentValue = false,
   Callback = function(Value) AutoBF = Value end,
})

-- KLAVYE TETIKLEYICI
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.V and AutoBF then
        local vIM = game:GetService("VirtualInputManager")
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        vIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
        task.wait(0.29)
        vIM:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
        vIM:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
    end
end)

Rayfield:Notify({ Title = "Basarili", Content = "Esya ESP ve Dinamik Takip eklendi!", Duration = 5 })
