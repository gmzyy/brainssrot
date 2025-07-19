local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI protegida
local parentGui = game:GetService("CoreGui")
if RunService:IsStudio() then
    parentGui = LocalPlayer:WaitForChild("PlayerGui")
end

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
frame.Size = UDim2.new(0, 240, 0, 110)
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

-- Etiqueta de estado
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 80)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.Text = "Status: Idle"

-- Función de robo optimizada
local function stealBrainrots()
    statusLabel.Text = "Status: Stealing brainrots..."
    local activeTweens = {}

    for _, ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer then
            local theirBase = workspace:FindFirstChild("Base_" .. ply.Name)
            local myBase = workspace:FindFirstChild("Base_" .. LocalPlayer.Name)

            if theirBase and myBase then
                if not theirBase.PrimaryPart then
                    local part = theirBase:FindFirstChildWhichIsA("BasePart")
                    if part then theirBase.PrimaryPart = part end
                end
                if not myBase.PrimaryPart then
                    local part = myBase:FindFirstChildWhichIsA("BasePart")
                    if part then myBase.PrimaryPart = part end
                end

                for _, br in ipairs(theirBase:GetChildren()) do
                    if br:IsA("Model") and br:FindFirstChild("HumanoidRootPart") then
                        local hrp = br.HumanoidRootPart
                        hrp.Anchored = true
                        local tween = TweenService:Create(hrp, TweenInfo.new(1), {
                            CFrame = myBase.PrimaryPart.CFrame * CFrame.new(0, 5, 0)
                        })
                        table.insert(activeTweens, tween)
                        tween:Play()
                    end
                end
            end
        end
    end

    task.delay(1.5, function()
        for _, tween in ipairs(activeTweens) do
            tween:Cancel()
        end
        statusLabel.Text = "Status: Done!"
    end)
end

-- Botón
local function addButton(text, fn, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gover
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        coroutine.wrap(fn)()
    end)
end

addButton("🧠 Steal Brainrots", stealBrainrots, 40)

-- Anti-kick
pcall(function()
    if hookmetamethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() == "Kick" then
                return
            end
            return oldNamecall(self, ...)
        end)
    end
end)