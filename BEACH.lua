-- BEACH.lua — Autofarm named BEACH: teleports to HOLD_POS (-3254,53,7653) and holds position while enabled
print("BEACH.lua loaded: Autofarm (BEACH) teleports to target and holds position when enabled")

-- Try to use WindUI when available; fallback UI created in PlayerGui as BEACH_FallbackUI
local WindUI_OK, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)

local Window, Tab
if WindUI_OK and WindUI and type(WindUI.CreateWindow) == "function" then
    pcall(function()
        Window = WindUI:CreateWindow({ Title = "Kenscript", Icon = "star", Theme = "Dark", Folder = "MyHub" })
        Tab = Window:Tab({ Title = "BEACH", Icon = "beach" })
    end)
end

-- State and settings
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local runAutofarm = false
local DESIRED_SPEED = 200
local SPEED_CAP = 300

-- New HOLD_POS for BEACH
local HOLD_POS = Vector3.new(-3254, 53, 7653)

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

-- Attach humanoid listener
if localPlayer then
    if localPlayer.Character then updateHumanoid() end
    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.05)
        updateHumanoid()
    end)
end

-- Build WindUI controls if available, otherwise fallback will be created
local builtWithWind = false
if Tab then
    local ok, err = pcall(function()
        Tab:Toggle({
            Title = "Autofarm",
            Value = runAutofarm,
            Callback = function(state)
                runAutofarm = state
                print("Autofarm (BEACH):", state)
                if runAutofarm then
                    updateHumanoid()
                    if humanoidRef and not originalWalkSpeed then originalWalkSpeed = humanoidRef.WalkSpeed end
                    local okTeleport = teleportTo(HOLD_POS)
                    if not okTeleport then warn("BEACH: teleport may have failed; attempting to hold position anyway") end
                    if humanoidRef then pcall(function() humanoidRef.WalkSpeed = 0 end) end
                    startHoldPosition(HOLD_POS)
                else
                    stopHoldPosition()
                    if humanoidRef and originalWalkSpeed then pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end) end
                end
            end,
        })
    end)
    if ok then builtWithWind = true else warn("BEACH WindUI build failed:", err) end
end

-- Fallback ScreenGui so controls are always visible
local function createFallbackUI()
    if not localPlayer then return end
    local playerGui = localPlayer:FindFirstChild("PlayerGui") or Instance.new("PlayerGui", localPlayer)
    for _,c in ipairs(playerGui:GetChildren()) do
        if c.Name == "BEACH_FallbackUI" then pcall(function() c:Destroy() end) end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BEACH_FallbackUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 260, 0, 140)
    frame.Position = UDim2.new(0, 20, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -12, 0, 30)
    title.Position = UDim2.new(0,6,0,6)
    title.BackgroundTransparency = 1
    title.Text = "BEACH - Autofarm"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local autofarmBtn = Instance.new("TextButton")
    autofarmBtn.Name = "AutofarmBtn"
    autofarmBtn.Size = UDim2.new(1, -12, 0, 30)
    autofarmBtn.Position = UDim2.new(0,6,0,42)
    autofarmBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    autofarmBtn.TextColor3 = Color3.fromRGB(255,255,255)
    autofarmBtn.Font = Enum.Font.SourceSans
    autofarmBtn.TextSize = 16
    autofarmBtn.Text = "Autofarm: OFF"
    autofarmBtn.Parent = frame

    local velLabel = Instance.new("TextLabel")
    velLabel.Name = "VelLabel"
    velLabel.Size = UDim2.new(0.4, -8, 0, 24)
    velLabel.Position = UDim2.new(0,6,0,82)
    velLabel.BackgroundTransparency = 1
    velLabel.Text = "Velocidad"
    velLabel.TextColor3 = Color3.fromRGB(220,220,220)
    velLabel.Font = Enum.Font.SourceSans
    velLabel.TextSize = 14
    velLabel.TextXAlignment = Enum.TextXAlignment.Left
    velLabel.Parent = frame

    local velBox = Instance.new("TextBox")
    velBox.Name = "VelBox"
    velBox.Size = UDim2.new(0.6, -10, 0, 24)
    velBox.Position = UDim2.new(0.4, 2, 0, 78)
    velBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
    velBox.TextColor3 = Color3.fromRGB(255,255,255)
    velBox.Font = Enum.Font.SourceSans
    velBox.TextSize = 14
    velBox.Text = tostring(DESIRED_SPEED)
    velBox.ClearTextOnFocus = false
    velBox.Parent = frame

    local applyBtn = Instance.new("TextButton")
    applyBtn.Name = "ApplyBtn"
    applyBtn.Size = UDim2.new(1, -12, 0, 20)
    applyBtn.Position = UDim2.new(0,6,0,108)
    applyBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    applyBtn.TextColor3 = Color3.fromRGB(255,255,255)
    applyBtn.Font = Enum.Font.SourceSans
    applyBtn.TextSize = 14
    applyBtn.Text = "Apply velocidad"
    applyBtn.Parent = frame

    autofarmBtn.MouseButton1Click:Connect(function()
        if not runAutofarm then
            runAutofarm = true
            autofarmBtn.Text = "Autofarm: ON"
            updateHumanoid()
            if humanoidRef and not originalWalkSpeed then originalWalkSpeed = humanoidRef.WalkSpeed end
            teleportTo(HOLD_POS)
            if humanoidRef then pcall(function() humanoidRef.WalkSpeed = 0 end) end
            startHoldPosition(HOLD_POS)
        else
            runAutofarm = false
            autofarmBtn.Text = "Autofarm: OFF"
            stopHoldPosition()
            if humanoidRef and originalWalkSpeed then pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end) end
        end
    end)

    velBox.FocusLost:Connect(function()
        local n = tonumber(velBox.Text)
        if n then
            DESIRED_SPEED = math.max(1, math.min(300, math.floor(n)))
            velBox.Text = tostring(DESIRED_SPEED)
            print("BEACH: velocidad ajustada:", DESIRED_SPEED)
        else
            velBox.Text = tostring(DESIRED_SPEED)
        end
    end)

    applyBtn.MouseButton1Click:Connect(function()
        local n = tonumber(velBox.Text)
        if n then
            DESIRED_SPEED = math.max(1, math.min(300, math.floor(n)))
            velBox.Text = tostring(DESIRED_SPEED)
            print("BEACH: velocidad aplicada:", DESIRED_SPEED)
        end
    end)

    return screenGui
end

-- Create fallback UI
createFallbackUI()

print("BEACH.lua: UI setup finished (WindUI used if available; fallback created)")
