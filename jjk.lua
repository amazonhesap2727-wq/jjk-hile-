--[[
    YUJI Divergent Fist Auto Blackflash (100%)
    (also can work on mahitos 3rd ability)
]]

-- // SUPER SETTINGS // --
-- Tweak these slightly if you have high ping (e.g., set to 0.31 or 0.32)
local Timing_1 = 0.29  -- The "Golden" delay for the first hit
local Timing_2 = 0.30  -- Slightly longer for the follow-up momentum

local TriggerKey = Enum.KeyCode.V       -- Key to Activate
local MoveKey    = Enum.KeyCode.Three   -- The Move Key (3)

-- // SERVICES // --
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local active = false

-- // THE FUNCTION // --
local function TriggerMove(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait() -- Micro-wait to ensure server registration
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == TriggerKey then
        if active then return end -- Prevent spam breaking the timing
        active = true
        
        -- // HIT 1: INITIAL STRIKE // --
        TriggerMove(MoveKey)
        
        -- Wait for the perfect impact frame
        task.wait(Timing_1)
        
        -- // HIT 2: BLACK FLASH TRIGGER // --
        TriggerMove(MoveKey)
        
        -- Wait for the chain window
        task.wait(Timing_2)
        
        -- // HIT 3: CHAIN EXTENSION // --
        TriggerMove(MoveKey)
        
        -- Reset
        task.wait(0.5)
        active = false
    end
end)

print("Jujustu Shenanigans Auto Blackflash Loaded")
