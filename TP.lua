local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "*Kenscript* 🍫+1 Escapa del teclado🍩",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "by xxkenxr",
   ConfigurationSaving = { Enabled = false },
})

-- ==================== KEY SYSTEM ====================
local KeyTab = Window:CreateTab("Key System", 4483362458)

KeyTab:CreateInput({
   Name = "Key",
   PlaceholderText = "Ingresa la clave...",
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

-- ==================== MENÚ PRINCIPAL ====================
function loadMainMenu()
   local MainTab = Window:CreateTab("Teleports", 4483362458)

   MainTab:CreateButton({
      Name = "Etapa 16 TP",
      Callback = function()
         local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = CFrame.new(7961, 720, 5144)
            startTimer()
         end
      end,
   })

   -- ==================== TEMPORIZADOR CIRCULAR ====================
   local TimerBall = Instance.new("Frame")
   TimerBall.Size = UDim2.new(0, 75, 0, 75)
   TimerBall.Position = UDim2.new(0.82, 0, 0.12, 0)
   TimerBall.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
   TimerBall.Active = true
   TimerBall.Draggable = true
   TimerBall.Visible = false
   TimerBall.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

   local BallCorner = Instance.new("UICorner")
   BallCorner.CornerRadius = UDim.new(1, 0)
   BallCorner.Parent = TimerBall

   local TimerText = Instance.new("TextLabel")
   TimerText.Size = UDim2.new(1,0,1,0)
   TimerText.BackgroundTransparency = 1
   TimerText.Text = "45"
   TimerText.TextColor3 = Color3.new(1,1,1)
   TimerText.TextScaled = true
   TimerText.Font = Enum.Font.GothamBold
   TimerText.Parent = TimerBall

   local function startTimer()
      TimerBall.Visible = true
      local t = 45
      spawn(function()
         while t > 0 do
            TimerText.Text = t
            wait(1)
            t -= 1
         end
         TimerText.Text = "0"
      end)
   end
end

print("🔒 Kenscript cargado - Usa la clave XKR")