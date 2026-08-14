-- TP.lua — Autofarm modified: Autofarm toggle teleports to specified coords and holds position
print("TP.lua loaded: Autofarm now teleports to target and holds position when enabled")

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local Window = WindUI:CreateWindow({ Title = "Kenscript", Icon = "star", Theme = "Dark", Folder = "MyHub" })
local Tab = Window:Tab({ Title = "Main", Icon = "home" })

-- Waypoints list (kept for reference)
local waypoints = {
    Vector3.new(-1455, -158, -948), Vector3.new(-1433, -157, -839), Vector3.new(-1431, -122, -728),
    Vector3.new(-1428, -67, -531), Vector3.new(-1449, -68, -486), Vector3.new(-1447, -57, -399),
    Vector3.new(-1448, -55, -319), Vector3.new(-1440, -55, -194), Vector3.new(-1446, -55, -65),
    Vector3.new(-1454, -55, -2), Vector3.new(-1454, -55, 84), Vector3.new(-1454, -25, 84),
    Vector3.new(-1454, 4, 84), Vector3.new(-1454, 52, 84), Vector3.new(-1454, 92, 91),
    Vector3.new(-1433, 96, 95), Vector3.new(-1433, 143, 95), Vector3.new(-1433, 188, 95),
    Vector3.new(-1434, 217, 111), Vector3.new(-1437, 223, 170), Vector3.new(-1439, 225, 230),
    Vector3.new(-1438, 217, 347), Vector3.new(-1455, 217, 452), Vector3.new(-1446, 217, 533),
    Vector3.new(-1451, 217, 575), Vector3.new(-1451, 276, 627), Vector3.new(-1451, 366, 627),
    Vector3.new(-1453, 363, 604), Vector3.new(-1454, 362, 496), Vector3.new(-1356, 362, 495),
    Vector3.new(-1255, 335, 494), Vector3.new(-1235, 324, 595), Vector3.new(-1232, 331, 657),
    Vector3.new(-1225, 337, 751), Vector3.new(-1219, 347, 829), Vector3.new(-1289, 356, 837),
    Vector3.new(-1369, 367, 846), Vector3.new(-1397, 367, 787), Vector3.new(-1408, 381, 725),
    Vector3.new(-1408, 429, 725), Vector3.new(-1408, 484, 725), Vector3.new(-1408, 558, 725),
    Vector3.new(-1406, 535, 755), Vector3.new(-1403, 535, 833), Vector3.new(-1405, 535, 1079),
    Vector3.new(-1405, 535, 1143), Vector3.new(-1404, 535, 1335), Vector3.new(-1412, 535, 1425),
    Vector3.new(-1487, 511, 1445), Vector3.new(-1575, 511, 1447), Vector3.new(-1656, 511, 1447),
    Vector3.new(-1662, 511, 1446), Vector3.new(-1733, 511, 1447), Vector3.new(-1802, 511, 1446),
    Vector3.new(-1878, 511, 1447), Vector3.new(-1959, 511, 1446), Vector3.new(-2064, 445, 1485),
    Vector3.new(-2134, 445, 1482), Vector3.new(-2274, 441, 1489), Vector3.new(-2409, 443, 1491),
    Vector3.new(-2498, 449, 1492), Vector3.new(-2668, 445, 1494), Vector3.new(-2884, 476, 1489),
    Vector3.new(-2952, 554, 1489), Vector3.new(-3024, 638, 1488), Vector3.new(-3175, 675, 1488),
    Vector3.new(-3328, 663, 1488), Vector3.new(-3450, 645, 1499), Vector3.new(-3615, 622, 1483),
    Vector3.new(-3677, 619, 1486), Vector3.new(-3831, 619, 1488), Vector3.new(-4082, 619, 1506),
    Vector3.new(-4140, 619, 1488), Vector3.new(-4175, 618, 1488), Vector3.new(-4626, 619, 1441),
    Vector3.new(-4840, 619, 1554), Vector3.new(-4980, 619, 1476),
}

-- State
local runAutofarm = false
local DESIRED_SPEED = 200
local SPEED_CAP = 300

-- Target position to hold
local HOLD_POS = Vector3.new(-1332, 26, 7561)

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local humanoidRef = nil
local originalWalkSpeed = nil

local function updateHumanoid()
    local char = localPlayer and localPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        humanoidRef = hum
        if not originalWalkSpeed then originalWalkSpeed = humanoidRef.WalkSpeed end
    end
end

local function teleportTo(pos)
    local char = localPlayer and (localPlayer.Character or localPlayer.CharacterAdded:Wait())
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
    if not hrp then return false end
    for i = 1, 6 do
        pcall(function()
            hrp.Velocity = Vector3.new(0,0,0)
            pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0,0,0) end)
            hrp.CFrame = CFrame.new(pos)
        end)
        task.wait(0.03)
        if (hrp.Position - pos).Magnitude <= 2 then return true end
    end
    pcall(function() hrp.CFrame = CFrame.new(pos) end)
    return (hrp.Position - pos).Magnitude <= 5
end

-- Hold position enforcer
local holdRunning = false
local function startHoldPosition(pos)
    if holdRunning then return end
    holdRunning = true
    task.spawn(function()
        local char = localPlayer and localPlayer.Character
        if not char then holdRunning = false; return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        while holdRunning and hrp and hrp.Parent do
            pcall(function()
                hrp.Velocity = Vector3.new(0,0,0)
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0,0,0) end)
                hrp.CFrame = CFrame.new(pos)
            end)
            task.wait(0.08)
            hrp = hrp.Parent and hrp.Parent:FindFirstChild("HumanoidRootPart") or nil
        end
        holdRunning = false
    end)
end
local function stopHoldPosition()
    holdRunning = false
end

-- Attach humanoid
if localPlayer then
    if localPlayer.Character then updateHumanoid() end
    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.05)
        updateHumanoid()
    end)
end

-- Create Autofarm toggle that teleports to HOLD_POS and stays there
pcall(function()
    Tab:Toggle({
        Title = "Autofarm",
        Value = runAutofarm,
        Callback = function(state)
            runAutofarm = state
            print("Autofarm:", state)
            if runAutofarm then
                updateHumanoid()
                -- store original speed
                if humanoidRef and not originalWalkSpeed then originalWalkSpeed = humanoidRef.WalkSpeed end
                -- attempt teleport to HOLD_POS
                local ok = teleportTo(HOLD_POS)
                if not ok then warn("Teleport may have failed; still attempting to hold position") end
                -- set walkspeed to 0 to avoid movement
                if humanoidRef then pcall(function() humanoidRef.WalkSpeed = 0 end) end
                -- start holding position
                startHoldPosition(HOLD_POS)
            else
                -- stop holding and restore speed
                stopHoldPosition()
                if humanoidRef and originalWalkSpeed then pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end) end
            end
        end,
    })
end)

Tab:Space()

-- Keybind K to toggle UI
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.K then
        pcall(function()
            if type(Window.Toggle) == "function" then Window:Toggle() return end
            if type(Window.ToggleVisibility) == "function" then Window:ToggleVisibility() return end
            if type(Window.SetVisible) == "function" then local vis = Window.Visible if type(vis) == "boolean" then Window:SetVisible(not vis) end end
        end)
    end
end)
