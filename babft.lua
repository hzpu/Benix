

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")


local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "BenixHub BABFT",
    Footer = "Having Fun: Join Now: https://discord.gg/3nuhm7Tha6",
    Icon = 12940390287,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "rocket"),
    Settings = Window:AddTab("Settings", "sliders"),
    Credits = Window:AddTab("Credits", "heart"),
}

local Toggles, Options = Library.Toggles, Library.Options


local stageCFrames = {
    CFrame.new(-51.5656433, 65.0000458, 1369.09009),
    CFrame.new(-51.5656433, 65.0000458, 2139.09009),
    CFrame.new(-51.5656433, 65.0000458, 2909.09009),
    CFrame.new(-51.5656433, 65.0000458, 3679.09009),
    CFrame.new(-53.5669785, 72.6005325, 4448.14209),
    CFrame.new(-51.5656433, 65.0000458, 5219.08984),
    CFrame.new(-51.5656433, 65.0000458, 5989.08984),
    CFrame.new(-51.5656433, 65.0000458, 6759.08984),
    CFrame.new(-51.5656433, 65.0000458, 7529.08984),
    CFrame.new(-55.7065125, -358.739624, 9492.35645),
}

local function teleportToStage(cf)
    humanoid.PlatformStand = true
    TweenService:Create(hrp, TweenInfo.new(2), {CFrame = cf}):Play()
    task.wait(2.2)
    humanoid.PlatformStand = false
end

local function runFarm()
    character = player.Character or player.CharacterAdded:Wait()
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")

    for i, cf in ipairs(stageCFrames) do
        if humanoid.Health <= 0 then
            character = player.Character or player.CharacterAdded:Wait()
            hrp = character:WaitForChild("HumanoidRootPart")
            humanoid = character:WaitForChild("Humanoid")
        end
        teleportToStage(cf)
        task.wait(0.3)
    end
end


local Group = Tabs.Main:AddLeftGroupbox("Farm")

Group:AddButton({
    Text = "Run Farm Once",
    Func = function()
        runFarm()
    end,
    Tooltip = "Run one complete farm path"
})

Group:AddToggle("AutoFarmToggle", {
    Text = "Auto Farm",
    Default = false,
    Tooltip = "Loop farm automatically"
})

Group:AddSlider("LoopDelay", {
    Text = "Loop Delay (s)",
    Default = 3,
    Min = 1,
    Max = 15,
    Rounding = 1,
})

Toggles.AutoFarmToggle:OnChanged(function()
    task.spawn(function()
        while Toggles.AutoFarmToggle.Value do
            runFarm()
            task.wait(Options.LoopDelay.Value)
        end
    end)
end)

Tabs.Main:AddRightGroupbox("Stage Teleport"):AddDropdown("StageTP", {
    Values = {
        "Start","Stage 2","Stage 3","Stage 4","Stage 5","Stage 6",
        "Stage 7","Stage 8","Stage 9","Chest"
    },
    Default = 1,
    Text = "Teleport To Stage",
    Tooltip = "Instant teleport to a specific stage",
})

Options.StageTP:OnChanged(function(val)
    local index = table.find({"Start","Stage 2","Stage 3","Stage 4","Stage 5","Stage 6","Stage 7","Stage 8","Stage 9","Chest"}, val)
    if index then
        teleportToStage(stageCFrames[index])
    end
end)


Tabs.Settings:AddLeftGroupbox("Performance"):AddToggle("BlackScreen", {
    Text = "Black Screen Mode",
    Default = false,
    Tooltip = "Hides 3D world for low-end devices"
})

Toggles.BlackScreen:OnChanged(function()
    local core = game:GetService("CoreGui")
    if Toggles.BlackScreen.Value then
        if not core:FindFirstChild("BlackScreen") then
            local black = Instance.new("ScreenGui", core)
            black.Name = "BlackScreen"
            black.IgnoreGuiInset = true
            black.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            local frame = Instance.new("Frame", black)
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.new(0, 0, 0)
            frame.BackgroundTransparency = 0
        end
    else
        if core:FindFirstChild("BlackScreen") then
            core.BlackScreen:Destroy()
        end
    end
end)


local CreditLeft = Tabs.Credits:AddLeftGroupbox("Credits Info")

CreditLeft:AddLabel("BENIX AKAA is the dev")
CreditLeft:AddLabel("ChosenTechies.taught.me.(tween)")

CreditLeft:AddButton({
    Text = "Copy Discord Invite",
    Func = function()
        setclipboard("https://discord.gg/3nuhm7Tha6")
        Library:Notify("Copied to clipboard!", 3)
    end,
    Tooltip = "Copies Discord invite to clipboard"
})


Library:Notify("BenixHub BABFT Loaded", 5)
