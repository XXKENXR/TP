-- Backflip Farm
print("Backflip Farm cargado")

local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end

local Window = WindUI:CreateWindow({
    Title = "Backflip Farm",
    Icon = "home",
    Theme = "Dark",
    Folder = "BackflipHub",
    ToggleKey = Enum.KeyCode.K
})

local Tab = Window:Tab({ Title = "Farm", Icon = "zap" })

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local humanoidRef = nil
local originalWalkSpeed = nil
local holdRunning = false
local currentHoldPos = nil

local FARM_POS = Vector3.new(-6510, 272, -15756)

local function updateHumanoid()
    local char = localPlayer and localPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        humanoidRef = hum
        if not originalWalkSpeed then
            originalWalkSpeed = humanoidRef.WalkSpeed
        end
    end
end

local function teleportTo(pos)
    local char = localPlayer and (localPlayer.Character or localPlayer.CharacterAdded:Wait())
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return false end

    for i = 1, 6 do
        pcall(function()
            hrp.Velocity = Vector3.new(0, 0, 0)
            pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
            hrp.CFrame = CFrame.new(pos)
        end)
        task.wait(0.03)
        if (hrp.Position - pos).Magnitude <= 3 then return true end
    end
    return true
end

local function startHoldPosition(pos)
    if holdRunning and currentHoldPos == pos then return end
    holdRunning = false
    task.wait(0.03)
    holdRunning = true
    currentHoldPos = pos

    task.spawn(function()
        while holdRunning do
            local char = localPlayer and localPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    pcall(function()
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
                        hrp.CFrame = CFrame.new(pos)
                    end)
                end
            end
            task.wait(0.07)
        end
    end)
end

local function stopHoldPosition()
    holdRunning = false
    currentHoldPos = nil
end

if localPlayer then
    if localPlayer.Character then updateHumanoid() end
    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.1)
        updateHumanoid()
        if holdRunning and currentHoldPos then
            task.wait(0.1)
            startHoldPosition(currentHoldPos)
        end
    end)
end

Tab:Toggle({
    Title = "Mundo 1 Farm",
    Value = false,
    Callback = function(state)
        if state then
            updateHumanoid()
            teleportTo(FARM_POS)
            if humanoidRef then
                pcall(function() humanoidRef.WalkSpeed = 0 end)
            end
            startHoldPosition(FARM_POS)
            print("Mundo 1 Farm ON")
        else
            stopHoldPosition()
            if humanoidRef and originalWalkSpeed then
                pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end)
            end
            print("Mundo 1 Farm OFF")
        end
    end,
})

print("Backflip Farm listo - Tecla K para minimizar")