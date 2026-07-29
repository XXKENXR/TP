local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Kenscript",
    Icon = "star",
    Theme = "Dark",
    Folder = "MyHub",
})

local Tab = Window:Tab({
    Title = "Main",
    Icon = "home",
})

Tab:Toggle({
    Title = "Enable Feature",
    Value = false,
    Callback = function(state)
        print("Feature enabled:", state)
    end,
})

Tab:Space()

Tab:Button({
    Title = "Run Action",
    Icon = "play",
    Callback = function()
        print("Button clicked")
    end,
})