local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "*Kenscript* +1 Escapa del teclado",
   LoadingTitle = "Cargando...",
   LoadingSubtitle = "by xxkenxr",
   ConfigurationSaving = { Enabled = false },
})

-- ==================== KEY SYSTEM ====================
local MainTab = Window:CreateTab("Key System", 4483362458)

MainTab:CreateInput({
   Name = "Key",
   PlaceholderText = "Ingresa la clave...",
   Callback = function(Value)
      if Value == "XKR" then
         Rayfield:Notify({
            Title = "✅ Key Correcta",
            Content = "Acceso concedido",
            Duration = 4,
         })
         loadTeleportsTab()
      else
         Rayfield:Notify({
            Title = "❌ Key Incorrecta",
            Content = "Key Invalid",
            Duration = 3,
         })
      end
   end,
})

MainTab:CreateParagraph({
   Title = "Nota",
   Content = "El mejor script",
})

-- ==================== TELEPORTS TAB ====================
local TeleportsTab = nil

function loadTeleportsTab()
   TeleportsTab = Window:CreateTab("Teleports", 4483362458)

   local recordedPath = {}

   TeleportsTab:CreateButton({
      Name = "Etapa 16 TP",
      Callback = function()
         local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if root then
            root.CFrame = CFrame.new(7961, 720, 5144)
         end
      end,
   })

   -- Grabar Ruta
   TeleportsTab:CreateToggle({
      Name = "Grabar Ruta",
      CurrentValue = false,
      Callback = function(Value)
         if Value then
            recordedPath = {}
            Rayfield:Notify({Title = "Grabando Ruta", Content = "Camina ahora...", Duration = 3})
            spawn(function()
               while Value do
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

   -- Ejercer Ruta
   TeleportsTab:CreateToggle({
      Name = "Ejercer Ruta",
      CurrentValue = false,
      Callback = function(Value)
         if Value then
            if #recordedPath < 5 then
               Rayfield:Notify({Title = "Error", Content = "Graba una ruta primero", Duration = 3})
               return
            end
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

local function TeleportTo(x, y, z)
    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(x, y + HEIGHT_OFFSET, z)
    end
end

print("🔒 Kenscript cargado")