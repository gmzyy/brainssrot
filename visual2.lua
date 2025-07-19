-- gmzyy MENU PÚBLICO (sin spawneo)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 180)
frame.Position = UDim2.new(0, 20, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(24,24,24)
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Text = "gmzyy BRAINROT MENU"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Funciones del menú
local function stealBrainrots()
    for _, ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer then
            local theirBase = workspace:FindFirstChild("Base_".. ply.Name)
            local myBase = workspace:FindFirstChild("Base_".. LocalPlayer.Name)
            if theirBase and myBase and theirBase.PrimaryPart and myBase.PrimaryPart then
                for _, br in ipairs(theirBase:GetDescendants()) do
                    if br:IsA("Model") and br:FindFirstChild("HumanoidRootPart") then
                        TweenService:Create(
                            br.HumanoidRootPart,
                            TweenInfo.new(4, Enum.EasingStyle.Linear),
                            {CFrame = myBase.PrimaryPart.CFrame * CFrame.new(0,5,0)}
                        ):Play()
                        wait(4.5)
                    end
                end
            end
        end
    end
end

local function autoBubblegum()
    local machine = workspace:FindFirstChild("BubbleGumMachine")
    local countVal = LocalPlayer:FindFirstChild("BrainrotCount")
    if machine and countVal and countVal.Value >= 10 then
        local prompt = machine:FindFirstChildWhichIsA("ProximityPrompt")
        if prompt then fireproximityprompt(prompt) end
    end
end

local function autoScan()
    for _, ply in ipairs(Players:GetPlayers()) do
        if ply ~= LocalPlayer then
            local base = workspace:FindFirstChild("Base_".. ply.Name)
            if base then
                for _, br in ipairs(base:GetDescendants()) do
                    if br:IsA("Model") and br.Name:match("God") then
                        print("[SCAN] ".. ply.Name .. " tiene un Brainrot GOD!")
                    end
                    if br:IsA("Model") and br.Name:match("Candy") then
                        print("[SCAN] ".. ply.Name .. " tiene un Brainrot CANDY!")
                    end
                end
            end
        end
    end
end

-- UI Helpers
local function addButton(text, fn, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(fn)
end

addButton("🧠 Steal Brainrots", stealBrainrots, 40)
addButton("🍬 Auto Bubblegum", autoBubblegum, 80)
addButton("🔍 Auto Scan Rare", autoScan, 120)

-- Anti-kick básico
if hookmetamethod then
    hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then
            return nil
        end
        return self(...)
    end))
end
