local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "JJS Modie Ultra Panel V2.7",
   LoadingTitle = "Filtreleme Sistemi Aktif...",
   LoadingSubtitle = "by Modie",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Ana Menu", 4483362458)

-- // AYARLAR // --
local AutoBF = false
local ESP_Active = false
local ItemESP_Active = false

-- // HASSAS ITEM FILTRESI // --
local function CreateItemESP(item)
    if not ItemESP_Active then return end
    
    -- Harita binalarini engellemek icin cok siki filtre
    local isTarget = item:IsA("Tool") or 
                    (item:IsA("Model") and (
                        item.Name:lower():find("finger") or 
                        item.Name:lower():find("cursed") or 
                        item.Name:lower():find("object")
                    ) and not item.Name:lower():find("map") and not item.Name:lower():find("build"))

    if isTarget and not item:FindFirstChild("ItemHighlight") then
        local hl = Instance.new("Highlight", item)
        hl.Name = "ItemHighlight"
        hl.FillColor = Color3.fromRGB(0, 255, 0) -- Sadece esyalar YESIL
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

MainTab:CreateSection("Görsel Ayarlar (ESP)")

-- OYUNCU ESP (DINAMIK)
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

-- ESYA ESP (FILTRELI)
MainTab:CreateToggle({
   Name = "Sadece Eşya/Parmak ESP",
   CurrentValue = false,
   Callback = function(Value)
       ItemESP_Active = Value
       if Value then
           for _, v in pairs(game.Workspace:GetDescendants()) do CreateItemESP(v) end
       else
           for _, v in pairs(game.Workspace:GetDescendants()) do
               if v.Name == "ItemHighlight" then v:Destroy() end
           end
       end
   end,
})

MainTab:CreateSection("Dövüş Ayarları")

-- AUTO BLACK FLASH (V)
MainTab:CreateToggle({
   Name = "Auto Black Flash (V)",
   CurrentValue = false,
   Callback = function(Value) AutoBF = Value end,
})

-- TAKIP VE KONTROLLER
game.Workspace.ChildAdded:Connect(CreateItemESP)

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

Rayfield:Notify({ Title = "Fix Yuklendi", Content = "Bina parlamalari engellendi!", Duration = 5 })
