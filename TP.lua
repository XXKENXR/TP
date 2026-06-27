local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Kenscript 🍫+1 Escapa del teclado🍩",
   LoadingTitle = "Kenscript 🍫+1 Escapa del teclado🍩",
   LoadingSubtitle = "by xxkenxr 🇵🇷",
   ConfigurationSaving = { Enabled = false },
})

-- ==================== KEY SYSTEM ====================
local KeyTab = Window:CreateTab("Key System", 4483362458)

KeyTab:CreateInput({
   Name = "Key",
   PlaceholderText = "Ingresa la clave aquí...",
   Callback = function(Value)
      if Value == "XKR" then
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

-- ==================== TEMPORIZADOR EN PANTALLA ====================
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0, 220, 0, 45)
TimerLabel.Position = UDim2.new(0.5, -110, 0.12, 0)
TimerLabel.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
TimerLabel.TextColor3 = Color3.new(1,1,1)
TimerLabel.TextScaled = true
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.Text = "Temporizador: 45s"
TimerLabel.Visible = false
TimerLabel.Active = true
TimerLabel.Draggable = true
TimerLabel.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local function startTimer()
   TimerLabel.Visible = true
   local t = 45
   spawn(function()
      while t > 0 do
         TimerLabel.Text = "Temporizador: " .. t .. "s"
         wait(1)
         t = t - 1
      end
      TimerLabel.Text = "Temporizador: 0s"
   end)
end

-- ==================== MENÚ TELEPORTS ====================
function loadMainMenu()
   local MainTab = Window:CreateTab("Teleports", 4483362458)

   MainTab:CreateButton({
      Name = "Etapa 16 TP",
      Callback = function()
         local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = CFrame.new(-1469, -67 + 5, -521)  -- Nuevas coordenadas
            startTimer()
         end
      end,
   })
end

print("🔒 Kenscript cargado - Usa la clave XKR")