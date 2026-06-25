local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ==================== KEY SYSTEM (Como Orva) ====================
local CorrectKey = "XKR"

Rayfield:Notify({
    Title = "*Kenscript*",
    Content = "Ingresa la clave para continuar",
    Duration = 6,
})

local KeyInput = Rayfield:CreateWindow({
    Name = "*Kenscript*",
    LoadingTitle = "Verificando Key...",
    LoadingSubtitle = "by xxkenxr",
    ConfigurationSaving = { Enabled = false },
})

local KeyTab = KeyInput:CreateTab("Key System", 4483362458)

KeyTab:CreateInput({
    Name = "Key",
    PlaceholderText = "Escribe la clave aquí...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        if Value == CorrectKey then
            Rayfield:Notify({
                Title = "✅ Key Correcta",
                Content = "Acceso concedido",
                Duration = 4,
            })
            loadMainMenu()
        else
            Rayfield:Notify({
                Title = "❌ Key Incorrecta",
                Content = "Key Invalid",
                Duration = 3,
            })
        end
    end,
})

KeyTab:CreateParagraph({
    Title = "Nota",
    Content = "El mejor script",
})

-- ==================== MENÚ PRINCIPAL ====================
function loadMainMenu()
    local MainTab = KeyInput:CreateTab("Teleports", 4483362458)

    MainTab:CreateButton({
        Name = "Etapa 16 TP",
        Callback = function()
            local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(7961, 720, 5144)
            end
        end,
    })

    local recordedPath = {}
    local isRecording = false

    MainTab:CreateToggle({
        Name = "Grabar Ruta",
        CurrentValue = false,
        Callback = function(Value)
            isRecording = Value
            if Value then
                recordedPath = {}
                Rayfield:Notify({Title = "Grabando", Content = "Camina ahora...", Duration = 3})
                spawn(function()
                    while isRecording do
                        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            table.insert(recordedPath, root.Position)
                        end
                        wait(0.4)
                    end
                end)
            else
                Rayfield:Notify({Title = "Grabación Terminada", Content = #recordedPath .. " puntos guardados", Duration = 4})
            end
        end,
    })

    MainTab:CreateToggle({
        Name = "Ejercer Ruta",
        CurrentValue = false,
        Callback = function(Value)
            if Value and #recordedPath > 5 then
                Rayfield:Notify({Title = "Ejecutando Ruta", Content = "Reproduciendo...", Duration = 3})
                local i = 1
                spawn(function()
                    while Value and i <= #recordedPath do
                        local pos = recordedPath[i]
                        TeleportTo(pos.X, pos.Y, pos.Z)
                        i += 1
                        wait(0.25)
                    end
                end)
            end
        end,
    })
end

print("🔒 Kenscript cargado - Key: XKR")