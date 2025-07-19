local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI seguro para Delta
local parentGui = RunService:IsStudio() and LocalPlayer:WaitForChild("PlayerGui") or gethui and gethui() or game:GetService("CoreGui")

-- Eliminar si ya existe
pcall(function()
    if parentGui:FindFirstChild("GmzyyMenu") then
        parentGui.GmzyyMenu:Destroy()
    end
end)

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GmzyyMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
if syn and syn.protect_gui then syn.protect_gui(gui) end
gui.Parent = parentGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 100)
frame.Position = UDim2.new(0, 20, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
frame.Active = true
frame.Draggable = true
frame.Selectable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Text = "gmzyy BRAINROT MENU"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Botón para cerrar la interfaz
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

-- Función principal
local function stealBrainrots()
    task.wait(0.5)

    for _, ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer then
            local theirBase = workspace:FindFirstChild("Base_" .. ply.Name)
            local myBase = workspace:FindFirstChild("Base_" .. LocalPlayer.Name)

            if theirBase and myBase then
                -- Asegurar PrimaryPart
                if not theirBase.PrimaryPart then
                    local basePart = theirBase:FindFirstChild("HumanoidRootPart") or theirBase:FindFirstChildWhichIsA("BasePart")
                    if basePart then theirBase.PrimaryPart = basePart end
                end
                if not myBase.PrimaryPart then
                    local basePart = myBase:FindFirstChild("HumanoidRootPart") or myBase:FindFirstChildWhichIsA("BasePart")
                    if basePart then myBase.PrimaryPart = basePart end
                end

                if theirBase.PrimaryPart and myBase.PrimaryPart then
                    for _, br in ipairs(theirBase:GetDescendants()) do
                        if br:IsA("Model") and br:FindFirstChild("HumanoidRootPart") then
                            local hrp = br.HumanoidRootPart
                            hrp.Anchored = true
                            local tween = TweenService:Create(
                                hrp,
                                TweenInfo.new(2, Enum.EasingStyle.Linear),
                                {CFrame = myBase.PrimaryPart.CFrame * CFrame.new(0,5,0)}
                            )
                            tween:Play()
                            task.wait(0.5)
                        end
                    end
                end
            end
        end
    end
end

-- Agregar botón
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

-- Anti-kick básico
pcall(function()
    if hookmetamethod then
        hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" and tostring(self) == "Kick" then
                return nil
            end
            return self(...)
        end))
    end
end)
