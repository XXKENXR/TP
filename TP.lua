local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "*Kenscript* 🍫+1 Escapa del teclado🍩",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "by xxkenxr🇵🇷",
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

-- ==================== MENÚ PRINCIPAL ====================
function loadMainMenu()
   local MainTab = Window:CreateTab("Teleports", 4483362458)

   -- Temporizador
   local TimerParagraph = MainTab:CreateParagraph({
      Title = "Temporizador",
      Content = "Temporizador: 45s",
   })

   local function startTimer()
      local t = 45
      spawn(function()
         while t > 0 do
            TimerParagraph:Set("Temporizador: " .. t .. "s")
            wait(1)
            t -= 1
         end
         TimerParagraph:Set("Temporizador: 0s")
      end)
   end

   MainTab:CreateButton({
      Name = "Etapa 16 TP",
      Callback = function()
         local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = CFrame.new(7961, 720, 5144)
            startTimer()   -- Solo se activa aquí
         end
      end,
   })
end

print("🔒 Kenscript cargado - Usa la clave XKR")