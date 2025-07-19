local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Configuración
local CONFIG = {
    TWEEN_DURATION = 1.5, -- Duración del tween para simular movimiento natural
    MAX_DISTANCE = 50, -- Distancia máxima para considerar un brainrot "en tus manos"
    CHECK_INTERVAL = 0.5, -- Intervalo para verificar brainrots
    RANDOM_DELAY_MIN = 0.1, -- Retraso aleatorio mínimo para simular comportamiento humano
    RANDOM_DELAY_MAX = 0.3, -- Retraso aleatorio máximo
}

-- GUI protegida
local parentGui = RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui")

-- Eliminar GUI anterior
local existingGui = parentGui:FindFirstChild("GmzyyMenu")
if existingGui then
    existingGui:Destroy()
end

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GmzyyMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parentGui

-- Cuadro flotante
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 130)
frame.Position = UDim2.new(0, 50, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
frame.Active = true
frame.Draggable = true
frame.Selectable = false
frame.Parent = gui
Instance.new("UICorner", frame)

-- Título
local title = Instance.new("TextLabel", frame)
title.Text = "gmzyy BRAINROT MENU"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Etiqueta de estado
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 100)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Text = "Status: Idle"

-- Botón cerrar
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
Instance.new("UICorner", closeBtn)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Función para añadir botones
local function addButton(text, fn, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        coroutine.wrap(fn)()
    end)
end

-- Función para obtener la base del jugador
local function getPlayerBase()
    local base = Workspace:FindFirstChild("Base_" .. LocalPlayer.Name)
    if base and not base:FindFirstChild("PrimaryPart") then
        local part = base:FindFirstChildWhichIsA("BasePart")
        if part then base.PrimaryPart = part end
    end
    return base
end

-- Función para verificar si el brainrot está cerca del jugador
local function isBrainrotInHands(brainrot)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    local hrp = character.HumanoidRootPart
    local brainrotHrp = brainrot:FindFirstChild("HumanoidRootPart")
    if not brainrotHrp then
        return false
    end
    return (hrp.Position - brainrotHrp.Position).Magnitude <= CONFIG.MAX_DISTANCE
end

-- Función para mover brainrot a la base
local function moveBrainrotToBase(brainrot)
    local myBase = getPlayerBase()
    if not myBase or not myBase.PrimaryPart then
        statusLabel.Text = "Status: Base no encontrada"
        return
    end

    local brainrotHrp = brainrot:FindFirstChild("HumanoidRootPart")
    if not brainrotHrp then
        statusLabel.Text = "Status: Brainrot inválido"
        return
    end

    -- Verificar si la base está bloqueada
    local laserGate = myBase:FindFirstChild("Gate") -- Ajusta según el nombre real del objeto de la puerta
    if laserGate and laserGate:IsA("BasePart") and laserGate.Transparency == 0 then
        statusLabel.Text = "Status: Base bloqueada, esperando..."
        task.wait(5) -- Esperar un tiempo razonable antes de reintentar
        return
    end

    -- Anclar el brainrot para evitar que se mueva mientras se tweanea
    brainrotHrp.Anchored = true

    -- Simular movimiento natural a la base
    local targetCFrame = myBase.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
    local tweenInfo = TweenInfo.new(CONFIG.TWEEN_DURATION, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(brainrotHrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()

    -- Actualizar estado
    statusLabel.Text = "Status: Moviendo brainrot a base..."

    -- Limpiar después del tween
    tween.Completed:Connect(function()
        brainrotHrp.Anchored = false
        statusLabel.Text = "Status: Brainrot movido!"
    end)
end

-- Función principal de robo
local function stealBrainrots()
    statusLabel.Text = "Status: Buscando brainrots..."

    while true do
        -- Añadir retraso aleatorio para simular comportamiento humano
        task.wait(math.random(CONFIG.RANDOM_DELAY_MIN, CONFIG.RANDOM_DELAY_MAX))

        -- Buscar bases de otros jugadores
        for _, ply in ipairs(Players:GetPlayers()) do
            if ply ~= LocalPlayer then
                local theirBase = Workspace:FindFirstChild("Base_" .. ply.Name)
                if theirBase then
                    -- Buscar brainrots en la base del otro jugador
                    for _, br in ipairs(theirBase:GetChildren()) do
                        if br:IsA("Model") and br:FindFirstChild("HumanoidRootPart") then
                            -- Verificar si el brainrot está cerca del jugador (simulando que lo "tienes en las manos")
                            if isBrainrotInHands(br) then
                                statusLabel.Text = "Status: Brainrot encontrado, moviendo..."
                                moveBrainrotToBase(br)
                                task.wait(CONFIG.TWEEN_DURATION + 0.5) -- Esperar antes de buscar el próximo
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Añadir botón para activar el robo
addButton("🧠 Steal Brainrots", stealBrainrots, 40)

-- Anti-kick pasivo (evitar hooks agresivos)
game.Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        statusLabel.Text = "Status: Teleport fallido, posible kick detectado"
    end
end)

-- Bucle para mantener el script activo
RunService.Heartbeat:Connect(function()
    pcall(function()
        -- Verificar si el jugador sigue en el juego
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
            statusLabel.Text = "Status: Personaje no encontrado"
        end
    end)
end)