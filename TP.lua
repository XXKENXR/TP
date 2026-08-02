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

Tab:Toggle({
    Title = "Autofarm",
    Value = false,
    Callback = function(state)
        -- Teleport al hacer click en el toggle (cuando se activa)
        print("Autofarm enabled:", state)
        if state then
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(1, 61, -9030)
            end
        end
    end,
})

Tab:Space()

Tab:Button({
    Title = "Run Autofarm",
    Icon = "play",
    Callback = function()
        print("Run Autofarm clicked")
    end,
})
