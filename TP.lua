-- Kenscript Hub
print("Kenscript Hub cargado")

local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end

local Window = WindUI:CreateWindow({
    Title = "Kenscript Hub",
    Icon = "star",
    Theme = "Dark",
    Folder = "MyHub",
    ToggleKey = Enum.KeyCode.K
})

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local humanoidRef = nil
local originalWalkSpeed = nil
local holdRunning = false
local currentHoldPos = nil

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

local function createMundoToggle(tab, mundoNum, title, positions)
    tab:Toggle({
        Title = title,
        Value = false,
        Callback = function(state)
            if state then
                updateHumanoid()
                local pos = positions[mundoNum]
                teleportTo(pos)
                if humanoidRef then pcall(function() humanoidRef.WalkSpeed = 0 end) end
                startHoldPosition(pos)
            else
                if currentHoldPos == positions[mundoNum] then
                    stopHoldPosition()
                    if humanoidRef and originalWalkSpeed then
                        pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end)
                    end
                end
            end
        end,
    })
end

-- Monkey farm
local TabMain = Window:Tab({ Title = "Monkey farm", Icon = "home" })
local MUNDOS = {
    [1] = Vector3.new(-9461, 389, -256),
    [2] = Vector3.new(-3606, 155, -9378),
    [3] = Vector3.new(-8078, 282, 2741),
    [4] = Vector3.new(-7760, 21, 5741),
    [5] = Vector3.new(-1331, 26, 7561),
    [6] = Vector3.new(-2829, 286, 7824),
}
createMundoToggle(TabMain, 1, "Mundo 1", MUNDOS)
createMundoToggle(TabMain, 2, "Mundo 2", MUNDOS)
createMundoToggle(TabMain, 3, "Mundo 3", MUNDOS)
createMundoToggle(TabMain, 4, "Mundo 4", MUNDOS)
createMundoToggle(TabMain, 5, "Mundo 5", MUNDOS)
createMundoToggle(TabMain, 6, "X2", MUNDOS)

-- Monkey Farm X2
local TabX2 = Window:Tab({ Title = "Monkey Farm X2", Icon = "zap" })
local MUNDOS_X2 = {
    [1] = Vector3.new(-9458, 389, -189),
    [2] = Vector3.new(-3671, 155, -9378),
    [3] = Vector3.new(-8096, 282, 2741),
    [4] = Vector3.new(-7778, 21, 5741),
    [5] = Vector3.new(-1349, 26, 7562),
}
createMundoToggle(TabX2, 1, "Mundo 1 X2 Wins", MUNDOS_X2)
createMundoToggle(TabX2, 2, "Mundo 2 X2 Wins", MUNDOS_X2)
createMundoToggle(TabX2, 3, "Mundo 3 X2 Wins", MUNDOS_X2)
createMundoToggle(TabX2, 4, "Mundo 4 X2 Wins", MUNDOS_X2)
createMundoToggle(TabX2, 5, "Mundo 5 X2 Wins", MUNDOS_X2)

-- Keyboard
local TabKeyboard = Window:Tab({ Title = "Keyboard", Icon = "keyboard" })
local isRecording = false
local isPlaying = false
local recordedPath = {}
local recordConnection = nil

TabKeyboard:Toggle({
    Title = "Grabar Ruta",
    Value = false,
    Callback = function(state)
        isRecording = state
        if state then
            recordedPath = {}
            updateHumanoid()
            if humanoidRef then pcall(function() humanoidRef.WalkSpeed = 200 end) end
            local lastTime = tick()
            recordConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not isRecording then return end
                local char = localPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end
                local now = tick()
                table.insert(recordedPath, { CFrame = hrp.CFrame, Jump = hum.Jump, Delta = now - lastTime })
                lastTime = now
            end)
        else
            if recordConnection then recordConnection:Disconnect() recordConnection = nil end
            if humanoidRef and originalWalkSpeed then pcall(function() humanoidRef.WalkSpeed = originalWalkSpeed end) end
            print("Ruta guardada. Puntos:", #recordedPath)
        end
    end,
})

TabKeyboard:Toggle({
    Title = "Ejecutar Ruta",
    Value = false,
    Callback = function(state)
        isPlaying = state
        if not state then return end
        if #recordedPath < 2 then warn("No hay ruta grabada") return end
        task.spawn(function()
            for i = 1, #recordedPath do
                if not isPlaying then break end
                local data = recordedPath[i]
                local char = localPlayer.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hrp and data.CFrame then pcall(function() hrp.CFrame = data.CFrame end) end
                    if hum and data.Jump then pcall(function() hum.Jump = true end) end
                end
                local waitTime = data.Delta or 0.016
                if waitTime > 0.25 then waitTime = 0.04 end
                task.wait(waitTime)
            end
            isPlaying = false
        end)
    end,
})

print("Kenscript Hub listo")