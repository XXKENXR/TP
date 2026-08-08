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

-- Simple Autofarm toggle
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
