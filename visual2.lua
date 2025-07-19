local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI protegido sin bloquear Delta
local parentGui = RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or gethui and gethui() or game:GetService("CoreGui")

-- Eliminar GUI anterior si existe
pcall(function()
    if parentGui:FindFirstChild("GmzyyMenu") then
        parentGui.GmzyyMenu:Destroy()
    end
end)

-- Crear GUI sin capturar todo el input
local gui = Instance.new("ScreenGui")
gui.Name = "GmzyyMenu"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn and syn.protect_gui then syn.protect_gui(gui) end
gui.Parent = parentGui

-- Cuadro flotante pequeño
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
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
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

-- Función de robo (solo visual/test)
local function stealBrainrots()
    task.wait(0.5)

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

                for _, br in ipairs(theirBase:GetDescendants()) do
                    if br:IsA("Model") and br:FindFirstChild("HumanoidRootPart") then
                        local hrp = br.HumanoidRootPart
                        hrp.Anchored = true
                        TweenService:Create(hrp, TweenInfo.new(2), {
                            CFrame = myBase.PrimaryPart.CFrame * CFrame.new(0,5,0)
                        }):Play()
                        task.wait(0.5)
                    end
                end
            end
        end
    end
end

-- Botón
local function addButton(text, fn, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(fn)
end

addButton("🧠 Steal Brainrots", stealBrainrots, 40)

-- Anti-kick simple
pcall(function()
    if hookmetamethod then
        hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" and tostring(self) == "Kick" then
                return nil
            end
            return self(...);
        end))
    end
end)
