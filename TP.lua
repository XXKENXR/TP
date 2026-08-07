local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Kenscript",
    Icon = "star",
    Theme = "Dark",
    Folder = "MyHub",
})

local Tab = Window:Tab({
    Title = "Autofarm",
    Icon = "home",
})

-- Simple Autofarm toggle (mantengo por compatibilidad)
Tab:Toggle({
    Title = "Autofarm",
    Value = false,
    Callback = function(state)
        print("Autofarm enabled:", state)
        if state then
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(-9460, 389, -253)
            end
        end
    end,
})

Tab:Space()

-- Run Autofarm toggle: teleports to coords and, when player returns to lobby, teleports again repeatedly
local runAutofarm = false
local targetCFrame = CFrame.new(-9460, 389, -253)
local lobbyPosition = Vector3.new(0, 61, -9028) -- posición estimada del hub/lobby (ajusta si hace falta)
local lobbyThreshold = 20 -- distancia en studs para considerar que está en el lobby

local function teleportToTarget()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function()
            hrp.CFrame = targetCFrame
        end)
        return true
    end
    return false
end

local function isInLobby()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local pos = hrp.Position
    return (pos - lobbyPosition).Magnitude <= lobbyThreshold
end

Tab:Toggle({
    Title = "Run Autofarm",
    Value = false,
    Callback = function(state)
        runAutofarm = state
        print("Run Autofarm toggled:", state)
        if runAutofarm then
            -- start loop in background
            task.spawn(function()
                while runAutofarm do
                    -- Teleport to target start
                    local ok = teleportToTarget()
                    if not ok then
                        task.wait(1)
                        continue
                    end

                    -- Wait until player returns to lobby (or until toggle is turned off)
                    local startWait = tick()
                    local timeout = 120 -- seguridad: timeout máximo de espera en segundos
                    while runAutofarm and not isInLobby() and (tick() - startWait) < timeout do
                        task.wait(0.8)
                    end

                    -- Si aún no está en lobby después del timeout, reintentar teleport
                    if runAutofarm and not isInLobby() then
                        teleportToTarget()
                    end

                    -- pequeña pausa antes de la siguiente iteración
                    local smallDelay = 1.5
                    local waited = 0
                    while runAutofarm and waited < smallDelay do
                        task.wait(0.25)
                        waited = waited + 0.25
                    end
                end
            end)
        end
    end,
})

-- Keybind (K) para abrir/cerrar la UI en PC
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function toggleWindowVisibility()
    local success, err = pcall(function()
        if type(Window.Toggle) == "function" then
            Window:Toggle()
            return
        end
        if type(Window.ToggleVisibility) == "function" then
            Window:ToggleVisibility()
            return
        end
        if type(Window.SetVisible) == "function" then
            local vis = Window.Visible
            if type(vis) == "boolean" then
                Window:SetVisible(not vis)
                return
            end
        end
    end)

    if success then return end

    -- Fallback: buscar ScreenGui en PlayerGui o CoreGui y alternar su Enabled
    local function toggleGuiIn(parent)
        for _, gui in pairs(parent:GetChildren()) do
            if gui:IsA("ScreenGui") then
                local name = string.lower(gui.Name)
                if name:find("wind") or name:find("kenscript") or name:find("myhub") or name:find("autofarm") then
                    gui.Enabled = not gui.Enabled
                    return true
                end
            end
        end
        return false
    end

    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    if playerGui and toggleGuiIn(playerGui) then return end

    local coreGui = game:GetService("CoreGui")
    pcall(function()
        toggleGuiIn(coreGui)
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.K then
        toggleWindowVisibility()
    end
end)
