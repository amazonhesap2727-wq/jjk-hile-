local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "JJS Modie Ultra Panel Fixed",
   LoadingTitle = "Filtreli ESP Yukleniyor...",
   LoadingSubtitle = "by Modie",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Ana Menu", 4483362458)

-- // AYARLAR // --
local AutoBF = false
local ESP_Active = false
local ItemESP_Active = false

-- // HASSAS ITEM ESP FONKSIYONU // --
local function CreateItemESP(item)
    if not ItemESP_Active then return end
    
    -- Sadece gercek esyalari (Parmak, Gorev esyasi vb.) filtrele
    local isTargetItem = item:IsA("Tool") or 
                        (item:IsA("Model") and (item.Name:lower():find("finger") or item.Name:lower():find("object")))

    if isTargetItem and not item:FindFirstChild("ItemHighlight") then
        local hl = Instance.new("Highlight", item)
        hl.Name = "ItemHighlight"
        hl.FillColor = Color3.fromRGB(0, 255, 0) -- Sadece esyalar yesil
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

MainTab:CreateSection("Gorsel Ayarlar (ESP)")

-- OYUNCU ESP
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

-- ESYA ESP (FIXED)
MainTab:CreateToggle({
   Name = "Esya ESP (Sadece Parmak/Item)",
   CurrentValue = false,
   Callback = function(Value)
       ItemESP_Active = Value
       if Value then
           -- Tum haritayi degil, sadece Workspace'teki esya olabilecek seyleri tara
           for _, v in pairs(game.Workspace:GetChildren()) do CreateItemESP(v) end
       else
           for _, v in pairs(game.Workspace:GetDescendants()) do
               if v.Name == "ItemHighlight" then v:Destroy() end
           end
       end
   end,
})

-- // OTOMATIK TAKIP // --
game.Workspace.ChildAdded:Connect(CreateItemESP)

MainTab:CreateSection("Dovus Ayarlari")

MainTab:CreateToggle({
   Name = "Auto Black Flash (V)",
   CurrentValue = false,
   Callback = function(Value) AutoBF = Value end,
})

-- V TUSU TETIKLEYICI
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
