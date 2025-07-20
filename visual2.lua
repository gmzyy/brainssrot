local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local remote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("StealRemote")

-- Configuración
local CONFIG = {
    TWEEN_DURATION = 2, -- Duración del tween para movimientos naturales
    MAX_DISTANCE = 10, -- Distancia máxima para considerar un brainrot "en tus manos"
    CHECK_INTERVAL = 1, -- Intervalo para verificar brainrots
    RANDOM_DELAY_MIN = 0.2, -- Retraso aleatorio mínimo
    RANDOM_DELAY_MAX = 0.4, -- Retraso aleatorio máximo
    ENEMY_CHECK_DISTANCE = 50, -- Distancia para verificar jugadores enemigos
    ROOF_HEIGHT = 20, -- Altura para teletransportarse al techo
}

-- Lista de brainrots valiosos (basado en la wiki)
local VALUABLE_BRAINROTS = {
    ["Graipuss Medussi"] = {cost = 250000000, income = 1000000},
    ["Los Tralaleritos"] = {cost = 100000000, income = 500000},
    ["La Vacca Saturno"] = {cost = 50000000, income = 250000},
    Mutations = {"Galactic", "Golden", "Diamond", "Rainbow"}
}

-- GUI protegida
local parentGui = RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or game:GetService("CoreGui")

-- Eliminar GUI anterior
local existingGui = parentGui:FindFirstChild("MartinBrainrotGUI")
if existingGui then
    existingGui:Destroy()
end

-- Crear GUI con animación de introducción
local gui = Instance.new("ScreenGui")
gui.Name = "MartinBrainrotGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parentGui

local intro = Instance.new("TextLabel", gui)
intro.Size = UDim2.new(0, 400, 0, 100)
intro.Position = UDim2.new(0.5, -200, 0.4, 0)
intro.BackgroundTransparency = 1
intro.Text = "MADE BY GROK"
intro.TextColor3 = Color3.fromRGB(255, 255, 255)
intro.TextScaled = true
intro.Font = Enum.Font.GothamBold
intro.TextTransparency = 1

local tweenIn = TweenService:Create(intro, TweenInfo.new(1, Enum.EasingStyle.Quad), {TextTransparency = 0})
local tweenOut = TweenService:Create(intro, TweenInfo.new(1, Enum.EasingStyle.Quad), {TextTransparency = 1})
tweenIn:Play()
tweenIn.Completed:Wait()
task.wait(1)
tweenOut:Play()
tweenOut.Completed:Connect(function()
    intro:Destroy()
end)

-- Cuadro principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Brainrot Stealer 😎"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
Instance.new("UICorner", title)

-- Etiqueta de estado
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 140)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Text = "Status: Idle"

-- Lista de brainrots valiosos
local valuableList = Instance.new("TextLabel", frame)
valuableList.Size = UDim2.new(1, -20, 0, 60)
valuableList.Position = UDim2.new(0, 10, 0, 80)
valuableList.BackgroundTransparency = 1
valuableList.TextColor3 = Color3.new(1, 1, 1)
valuableList.Font = Enum.Font.Gotham
valuableList.TextSize = 10
valuableList.Text = "Valuable Brainrots: None"
valuableList.TextWrapped = true
valuableList.TextYAlignment = Enum.TextYAlignment.Top

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
    btn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        coroutine.wrap(fn)()
    end)
end

-- Función para obtener la base del jugador
local function getPlayerBase()
    local baseNames = {
        "Base_" .. LocalPlayer.Name,
        "Plot_" .. LocalPlayer.Name,
        "Base_" .. LocalPlayer.UserId,
        "Plot_" .. LocalPlayer.UserId,
        "Base_" .. LocalPlayer.DisplayName,
        "Plot_" .. LocalPlayer.DisplayName
    }
    local base
    for _, name in ipairs(baseNames) do
        base = Workspace:FindFirstChild(name)
        if base then break end
    end
    if not base then
        for _, folder in ipairs(Workspace:GetChildren()) do
            if folder:IsA("Folder") or folder:IsA("Model") then
                for _, name in ipairs(baseNames) do
                    base = folder:FindFirstChild(name)
                    if base then break end
                end
                if base then break end
            end
        end
    end
    if base and not base:FindFirstChild("PrimaryPart") then
        local part = base:FindFirstChildWhichIsA("BasePart") or
                     base:FindFirstChild("BasePlate") or
                     base:FindFirstChild("Root") or
                     base:FindFirstChild("MainPart")
        if part then
            base.PrimaryPart = part
            statusLabel.Text = "Status: Base encontrada: " .. base.Name
        end
    end
    return base
end

-- Función para verificar si hay jugadores enemigos cerca
local function isEnemyNearby()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    local hrp = character.HumanoidRootPart
    for _, ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (hrp.Position - ply.Character.HumanoidRootPart.Position).Magnitude
            if distance < CONFIG.ENEMY_CHECK_DISTANCE then
                return true
            end
        end
    end
    return false
end

-- Función para verificar si el brainrot está siendo llevado
local function isBrainrotInHands(brainrot)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    local hrp = character.HumanoidRootPart
    local brainrotHrp = brainrot:FindFirstChild("HumanoidRootPart") or
                        brainrot:FindFirstChild("Root") or
                        brainrot:FindFirstChild("MainPart")
    if not brainrotHrp then
        return false
    end
    local distance = (hrp.Position - brainrotHrp.Position).Magnitude
    local isFollowing = (not brainrotHrp.Anchored and distance <= CONFIG.MAX_DISTANCE) or
                       brainrotHrp:FindFirstChildWhichIsA("BodyPosition") or
                       brainrotHrp:FindFirstChildWhichIsA("BodyVelocity") or
                       brainrotHrp:FindFirstChildWhichIsA("WeldConstraint")
    return isFollowing
end

-- Función para mover brainrot a la base
local function moveBrainrotToBase(brainrot)
    if isEnemyNearby() then
        statusLabel.Text = "Status: Jugadores cerca, esperando..."
        return
    end

    local myBase = getPlayerBase()
    if not myBase or not myBase.PrimaryPart then
        statusLabel.Text = "Status: Base no encontrada"
        return
    end

    local brainrotHrp = brainrot:FindFirstChild("HumanoidRootPart") or
                        brainrot:FindFirstChild("Root") or
                        brainrot:FindFirstChild("MainPart")
    if not brainrotHrp then
        statusLabel.Text = "Status: Brainrot inválido"
        return
    end

    local laserGate = myBase:FindFirstChild("Gate") or
                      myBase:FindFirstChild("LaserGate") or
                      myBase:FindFirstChild("Barrier")
    if laserGate and laserGate:IsA("BasePart") and laserGate.Transparency == 0 then
        statusLabel.Text = "Status: Base bloqueada, esperando..."
        task.wait(5)
        return
    end

    brainrotHrp.Anchored = true
    local targetCFrame = myBase.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
    local tweenInfo = TweenInfo.new(CONFIG.TWEEN_DURATION, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(brainrotHrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    statusLabel.Text = "Status: Moviendo brainrot a base..."
    tween.Completed:Connect(function()
        brainrotHrp.Anchored = false
        statusLabel.Text = "Status: Brainrot movido!"
    end)
end
-- Función para teletransportarse al techo y robar
local function smartSteal()
    if isEnemyNearby() then
        statusLabel.Text = "Status: Jugadores cerca, esperando..."
        return
    end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        statusLabel.Text = "Status: Personaje no encontrado"
        return
    end
    local hrp = character.HumanoidRootPart

    local enemyBase
    local function scanBases(container)
        for _, ply in ipairs(Players:GetPlayers()) do
            if ply ~= LocalPlayer then
                local baseNames = {
                    "Base_" .. ply.Name,
                    "Plot_" .. ply.Name,
                    "Base_" .. ply.UserId,
                    "Plot_" .. ply.UserId,
                    "Base_" .. ply.DisplayName,
                    "Plot_" .. ply.DisplayName
                }
                for _, name in ipairs(baseNames) do
                    local base = container:FindFirstChild(name)
                    if base then
                        enemyBase = base
                        return true
                    end
                end
            end
        end
        return false
    end

    if not scanBases(Workspace) then
        local plots = Workspace:FindFirstChild("Plots")
        if plots then scanBases(plots) end
    end

    if not enemyBase then
        statusLabel.Text = "Status: No se encontraron bases enemigas"
        return
    end

    local basePart = enemyBase:FindFirstChildWhichIsA("BasePart") or
                     enemyBase:FindFirstChild("BasePlate") or
                     enemyBase:FindFirstChild("Root") or
                     enemyBase:FindFirstChild("MainPart")
    if not basePart then
        statusLabel.Text = "Status: Base enemiga inválida"
        return
    end

    local rayOrigin = basePart.Position + Vector3.new(0, 100, 0)
    local rayDirection = Vector3.new(0, -200, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    local targetPos = result and result.Position + Vector3.new(0, CONFIG.ROOF_HEIGHT, 0) or
                      basePart.Position + Vector3.new(0, CONFIG.ROOF_HEIGHT, 0)

    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()
    statusLabel.Text = "Status: Teletransportando a techo de " .. enemyBase.Name
    tween.Completed:Connect(function()
        statusLabel.Text = "Status: En techo, robando..."
        pcall(function()
            remote:FireServer("Odin Din Din Dun")
        end)
    end)
end

-- Función para detectar brainrots valiosos
local function listValuableBrainrots()
    statusLabel.Text = "Status: Escaneando brainrots valiosos..."
    local valuableFound = {}

    local function scanBases(container)
        for _, ply in ipairs(Players:GetPlayers()) do
            if ply ~= LocalPlayer then
                local baseNames = {
                    "Base_" .. ply.Name,
                    "Plot_" .. ply.Name,
                    "Base_" .. ply.UserId,
                    "Plot_" .. ply.UserId,
                    "Base_" .. ply.DisplayName,
                    "Plot_" .. ply.DisplayName
                }
                for _, name in ipairs(baseNames) do
                    local theirBase = container:FindFirstChild(name)
                    if theirBase then
                        for _, br in ipairs(theirBase:GetChildren()) do
                            if br:IsA("Model") then
                                local brHrp = br:FindFirstChild("HumanoidRootPart") or
                                              br:FindFirstChild("Root") or
                                              br:FindFirstChild("MainPart")
                                if brHrp then
                                    local brName = br.Name
                                    local isValuable = VALUABLE_BRAINROTS[brName] or false
                                    local hasMutation = false
                                    for _, mutation in ipairs(VALUABLE_BRAINROTS.Mutations) do
                                        if string.find(brName:lower(), mutation:lower()) then
                                            hasMutation = true
                                            break
                                        end
                                    end
                                    local mutationValue = br:FindFirstChild("Mutation") or br:FindFirstChild("Variant")
                                    if mutationValue and mutationValue:IsA("StringValue") then
                                        for _, mutation in ipairs(VALUABLE_BRAINROTS.Mutations) do
                                            if mutationValue.Value:lower() == mutation:lower() then
                                                hasMutation = true
                                                break
                                            end
                                        end
                                    end
                                    if br:GetAttribute("Mutation") then
                                        for _, mutation in ipairs(VALUABLE_BRAINROTS.Mutations) do
                                            if br:GetAttribute("Mutation"):lower() == mutation:lower() then
                                                hasMutation = true
                                                break
                                            end
                                        end
                                    end
                                    if isValuable or hasMutation then
                                        local income = isValuable and VALUABLE_BRAINROTS[brName].income or "Unknown"
                                        local distance = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                                                        (brHrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or "Unknown"
                                        table.insert(valuableFound, string.format("%s (%s/s, %.1f studs) en base de %s", brName, tostring(income), distance, ply.Name))
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    scanBases(Workspace)
    for _, folder in ipairs(Workspace:GetChildren()) do
        if folder:IsA("Folder") or folder:IsA("Model") then
            scanBases(folder)
        end
    end

    local conveyorNames = {"Conveyor", "ConveyorBelt", "BrainrotSpawner", "MainConveyor"}
    local conveyor
    for _, name in ipairs(conveyorNames) do
        conveyor = Workspace:FindFirstChild(name)
        if conveyor then break end
    end
    if conveyor then
        for _, br in ipairs(conveyor:GetChildren()) do
            if br:IsA("Model") then
                local brHrp = br:FindFirstChild("HumanoidRootPart") or
                              br:FindFirstChild("Root") or
                              br:FindFirstChild("MainPart")
                if brHrp then
                    local brName = br.Name
                    local isValuable = VALUABLE_BRAINROTS[brName] or false
                    local hasMutation = false
                    for _, mutation in ipairs(VALUABLE_BRAINROTS.Mutations) do
                        if string.find(brName:lower(), mutation:lower()) then
                            hasMutation = true
                            break
                        end
                    end
                    local mutationValue = br:FindFirstChild("Mutation") or br:FindFirstChild("Variant")
                    if mutationValue and mutationValue:IsA("StringValue") then
                        for _, mutation in ipairs(VALUABLE_BRAINROTS.Mutations) do
                            if mutationValue.Value:lower() == mutation:lower() then
                                hasMutation = true
                                break
                            end
                        end
                    end
                    if br:GetAttribute("Mutation") then
                        for _, mutation in ipairs(VALUABLE_BRAINROTS.Mutations) do
                            if br:GetAttribute("Mutation"):lower() == mutation:lower() then
                                hasMutation = true
                                break
                            end
                        end
                    end
                    if isValuable or hasMutation then
                        local income = isValuable and VALUABLE_BRAINROTS[brName].income or "Unknown"
                        local distance = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                                        (brHrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or "Unknown"
                        table.insert(valuableFound, string.format("%s (%s/s, %.1f studs) en conveyor", brName, tostring(income), distance))
                    end
                end
            end
        end
    else
        statusLabel.Text = "Status: Conveyor no encontrado"
    end

    if #valuableFound > 0 then
        valuableList.Text = "Valuable Brainrots:\n" .. table.concat(valuableFound, "\n")
    else
        valuableList.Text = "Valuable Brainrots: None"
    end
    statusLabel.Text = "Status: Escaneo completado"
end

-- Función principal de robo
local function stealBrainrots()
    statusLabel.Text = "Status: Buscando brainrots robados..."

    while true do
        task.wait(CONFIG.CHECK_INTERVAL)

        if isEnemyNearby() then
            statusLabel.Text = "Status: Jugadores cerca, esperando..."
            task.wait(2)
        else
            pcall(function()
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and isBrainrotInHands(obj) then
                        statusLabel.Text = "Status: Brainrot robado detectado!"
                        moveBrainrotToBase(obj)
                        task.wait(CONFIG.TWEEN_DURATION + 0.5)
                    end
                end
            end)
        end
    end
end

-- Añadir botones
addButton("🧠 Steal Brainrots", stealBrainrots, 40)
addButton("🔍 List Valuable Brainrots", listValuableBrainrots, 70)
addButton("🔝 Smart Steal (Roof TP)", smartSteal, 100)

-- Anti-kick pasivo
game.Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        statusLabel.Text = "Status: Teleport fallido, posible kick detectado"
    end
end)

-- Bucle para mantener el script activo
RunService.Heartbeat:Connect(function()
    pcall(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
            statusLabel.Text = "Status: Personaje no encontrado"
        end
    end)
end)