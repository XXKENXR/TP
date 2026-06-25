local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Teleports by xxkenxr",
   LoadingTitle = "Cargando Script...",
   LoadingSubtitle = "by xxkenxr",
   ConfigurationSaving = {
      Enabled = false,
   },
})

local MainTab = Window:CreateTab("Teleports", 4483362458)

-- ==================== KEY SYSTEM ====================
MainTab:CreateSection("Key System")

local KeyInput = MainTab:CreateInput({
   Name = "Ingresa la Key",
   PlaceholderText = "Escribe aquí...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      if Text == "XKR" then
         Rayfield:Notify({
            Title = "✅ Acceso Concedido",
            Content = "Bienvenido al menú",
            Duration = 4,
            Image = 4483362458,
         })
      else
         Rayfield:Notify({
            Title = "❌ Key Incorrecta",
            Content = "Key Invalid",
            Duration = 3,
         })
      end
   end,
})

-- ==================== TELEPORTS ====================
MainTab:CreateSection("Opciones")

MainTab:CreateButton({
   Name = "Etapa 16 TP",
   Callback = function()
      local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if root then
         root.CFrame = CFrame.new(7961, 720, 5144)
      end
   end,
})

-- Grabar Ruta
local recordedPath = {}
local isRecording = false

local RecordToggle = MainTab:CreateToggle({
   Name = "Grabar Ruta",
   CurrentValue = false,
   Callback = function(Value)
      isRecording = Value
      if Value then
         recordedPath = {}
         Rayfield:Notify({Title = "Grabando Ruta", Content = "Camina ahora...", Duration = 3})
         -- Grabar posición cada segundo
         spawn(function()
            while isRecording do
               local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
               if root then
                  table.insert(recordedPath, root.Position)
               end
               wait(0.5)
            end
         end)
      else
         Rayfield:Notify({Title = "Grabación Terminada", Content = "Ruta guardada ("..#recordedPath.." puntos)", Duration = 4})
      end
   end,
})

-- Ejercer Ruta
local PlayToggle = MainTab:CreateToggle({
   Name = "Ejercer Ruta",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
         if #recordedPath < 5 then
            Rayfield:Notify({Title = "Error", Content = "Graba una ruta primero", Duration = 3})
            PlayToggle:Set(false)
            return
         end
         Rayfield:Notify({Title = "Ejecutando Ruta", Content = "Reproduciendo...", Duration = 3})
         
         local i = 1
         spawn(function()
            while Value and i <= #recordedPath do
               TeleportTo(recordedPath[i].X, recordedPath[i].Y, recordedPath[i].Z)
               i += 1
               wait(0.3)
            end
            PlayToggle:Set(false)
         end)
      end
   end,
})

-- Temporizador
local TimerLabel = MainTab:CreateParagraph({
   Title = "Temporizador",
   Content = "Temporizador: 45s",
})

Rayfield:Notify({
   Title = "Script Cargado",
   Content = "Usa la key: XKR",
   Duration = 5,
})