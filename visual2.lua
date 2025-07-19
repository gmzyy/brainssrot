local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GmzyyMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Intentar proteger GUI (solo si syn disponible)
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
    end
end)

gui.Parent = game:GetService("CoreGui")

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
    print("Ejecutando Steal Brainrots...")

    for _, ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer then
            local theirBase = workspace:FindFirstChild("Base_" .. ply.Name)
            local myBase = workspace:FindFirstChild("Base_" .. LocalPlayer.Name)

            if theirBase and myBase then
                local primary1 = theirBase:FindFirstChild("HumanoidRootPart") or theirBase:FindFirstChildWhichIsA("BasePart")
                local primary2 = myBase:FindFirstChild("HumanoidRootPart") or myBase:FindFirstChildWhichIsA("BasePart")
                if primary1 and primary2 then
                    for _, br in ipairs(theirBase:GetDescendants()) do
                        if br:IsA("Model") and br:FindFirstChild("HumanoidRootPart") then
                            local hrp = br.HumanoidRootPart
                            hrp.Anchored = true
                            TweenService:Create(hrp, TweenInfo.new(1), {
                                CFrame = primary2.CFrame * CFrame.new(0, 5, 0)
                            }):Play()
                        end
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

-- Anti-Kick simple
pcall(function()
    if hookmetamethod then
        hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if getnamecallmethod() == "Kick" then
                print("Intento de Kick bloqueado")
                return
            end
            return self(...)
        end))
    end
end)
