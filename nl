repeat task.wait(0.25) until game:IsLoaded()
getgenv().Image = "rbxassetid://15481959860"
getgenv().ToggleUI = "LeftControl" 
task.spawn(function()
    if not getgenv().LoadedMobileUI == true then
        getgenv().LoadedMobileUI = true
        local CoreGui = game:GetService("CoreGui")
        if not CoreGui:FindFirstChild("OpenUI") then
            local OpenUI = Instance.new("ScreenGui")
            local ImageButton = Instance.new("ImageButton")
            local UICorner = Instance.new("UICorner")
            OpenUI.Name = "OpenUI"
            OpenUI.Parent = CoreGui
            OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ImageButton.Parent = OpenUI
            ImageButton.BackgroundColor3 = Color3.fromRGB(105,105,105)
            ImageButton.BackgroundTransparency = 0.8
            ImageButton.Position = UDim2.new(0.9,0,0.1,0)
            ImageButton.Size = UDim2.new(0,50,0,50)
            ImageButton.Image = getgenv().Image
            ImageButton.Draggable = true
            ImageButton.Transparency = 1
            UICorner.CornerRadius = UDim.new(0,200)
            UICorner.Parent = ImageButton
            ImageButton.MouseButton1Click:Connect(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true,getgenv().ToggleUI,false,game)
            end)
        end
    end
end)


local PN = game:GetService("Players").LocalPlayer.Name
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = nil
local mi = "Blazing Vortex Island"
local rEvents = game:GetService("ReplicatedStorage"):WaitForChild("rEvents")
local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
local statGui = playerGui:WaitForChild("statEffectsGui")
local hoopGui = playerGui:WaitForChild("hoopGui")
local br = "buyRank"
local ranks = game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()
local Crystal = {}
local insafezonevalue = nil
_G.autoswingvar = false
_G.autohoopsvar = false
_G.autosellvar = false
_G.autosellwhenfullvar = false
_G.autobuybeltsvar = false
_G.autobuyswordvar = false
_G.autospinfortunevar = false
_G.autobuyskillsvar = false
_G.killallvar = false
_G.killedpopup = false
_G.autobuyranksvar = false
_G.autobuyshurikenvar = false
_G.selectedegg = nil
_G.openCrystal = false
_G.killaura = false
_G.killauradis = 10
_G.killaurax = 0
_G.killauray = 7.5
_G.killauraz = 0
_G.killauramode = 1
local function killaurafunc()
    _G.killauramode = tonumber(_G.killauramode) or 0
    _G.killauradis = tonumber(_G.killauradis) or 10
    _G.killaurax = tonumber(_G.killaurax) or 0
    _G.killauray = tonumber(_G.killauray) or 7.5
    _G.killauraz = tonumber(_G.killauraz) or 0
    hrp = character:WaitForChild("HumanoidRootPart")
    if not hrp then return end
    local ninjaEvent = LocalPlayer:WaitForChild("ninjaEvent")
    if not ninjaEvent then return end
    task.spawn(function()
        while _G.killaura do
            for _, v in ipairs(Players:GetPlayers()) do
                if v == LocalPlayer or workspace[v.Name]:FindFirstChild("inSafezone") then continue end
                if v.Character then
                    local targetHRP = v.Character:FindFirstChild("Head")
                    if targetHRP then
                    local myPos = hrp and hrp.Position
                    local targetPos = targetHRP and targetHRP.Position
                    if myPos and targetPos then
                        local distance = (myPos - targetPos).Magnitude
                        if _G.killauramode == 1 then
                            if distance <= _G.killauradis then
                                if not workspace[LocalPlayer.Name]:FindFirstChild("inSafezone") then
                                    ninjaEvent:FireServer("attackShuriken", Vector3.new(0, 0, 0))
                                    task.wait(0.1)
                                end
                            end
                        elseif _G.killauramode == 0 then
                            if distance <= _G.killauradis then
                                character:PivotTo(targetHRP.CFrame * CFrame.new(_G.killaurax, _G.killauray, _G.killauraz))
                                task.wait(.05)
                                if not workspace[LocalPlayer.Name]:FindFirstChild("inSafezone") then
                                    ninjaEvent:FireServer("attackShuriken", Vector3.new(0, 0, 0))
                                    task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    end)
end


local function getcrystal()
    table.clear(Crystal)
    local crystalFolder = workspace:FindFirstChild("mapCrystalsFolder")
    for _, v in pairs(crystalFolder:GetChildren()) do
        table.insert(Crystal, v.Name)
    end
end
getcrystal()
local function unlockallislands()
    local islandspath = workspace.islandUnlockParts
    for i,v in ipairs(islandspath:GetChildren()) do
        if v:FindFirstChild("TouchInterest") then
            firetouchinterest(v, hrp, 0)
            firetouchinterest(v, hrp, 1)
        end
    end
end

local function updhrp(character)
    hrp = character:WaitForChild("HumanoidRootPart")
end
LocalPlayer.CharacterAdded:Connect(updhrp)
if LocalPlayer.Character then
    updhrp(LocalPlayer.Character)
end

local function autobuyshurikenfunc()
    task.spawn(function()
        while _G.autobuyshurikenvar do
            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllShurikens", mi)
            task.wait(1)
        end
    end)
end

local function autobuyranksfunc()
    task.spawn(function()
        while _G.autobuyranksvar do
            for _,x in ipairs(ranks) do
                game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(br, x.Name)
                game:GetService("RunService").Heartbeat:Wait()
            end
            task.wait()
        end
    end)
end

local function autosellwhenfullfunc()
    task.spawn(function()
        while _G.autosellwhenfullvar do
            if LocalPlayer.PlayerGui.gameGui.maxNinjitsuMenu.Visible == true then
                if hrp and hrp.Parent and hrp.Parent:FindFirstChild("HumanoidRootPart") then
                    workspace.sellAreaCircles.sellAreaCircle16.circleInner.CFrame = hrp.CFrame * CFrame.new()
                    task.wait(.2)
                    workspace.sellAreaCircles.sellAreaCircle16.circleInner.CFrame = CFrame.new(0, 0, 0)
                end
            end
            game:GetService("RunService").Heartbeat:Wait()
        end
    end)
end
local function killall()
    task.spawn(function()
        while _G.killallvar do
            for i,v in ipairs(game:GetService("Players"):GetPlayers()) do
                local insafezonevalue = workspace[v.Name]:FindFirstChild("inSafezone")
            if v:IsA("Player") and v.Name ~= PN and v.Character and not insafezonevalue then
                v.Character:WaitForChild("Head").CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
            end
            end
            game:GetService("RunService").Heartbeat:Wait()
        end
    end)
end



local function autobuyskills()
    task.spawn(function()
        while _G.autobuyskillsvar do
            game:GetService("Players").LocalPlayer:WaitForChild("ninjaEvent"):FireServer("buyAllSkills", mi)
            task.wait(1)
        end
    end)
end


local function autospinfortune()
    task.spawn(function()
    while _G.autospinfortunevar do
task.wait(1)
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openFortuneWheelRemote"):InvokeServer("openFortuneWheel", workspace:WaitForChild("Fortune Wheel"))
        end
    end)
end



local function autobuybelt()
    task.spawn(function()
while _G.autobuybeltsvar do
game:GetService("Players").LocalPlayer:WaitForChild("ninjaEvent"):FireServer("buyAllBelts", "Blazing Vortex Island")
task.wait(1)
        end
    end)
end

local function autoswingfunc()
    task.spawn(function()
    while _G.autoswingvar do
task.wait(.3)
local args = {
	"swingKatana"
}
game:GetService("Players").LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
        end
    end)
end

local function autobuysword()
    task.spawn(function()
        while _G.autobuyswordvar do
            local args = {
                "buyAllSwords",
                "Blazing Vortex Island"
            }
            game:GetService("Players").LocalPlayer:WaitForChild("ninjaEvent"):FireServer(unpack(args))
            task.wait(1)
        end
    end)
end

local function autosellfunc()
    task.spawn(function()
        while _G.autosellvar do
            workspace.sellAreaCircles.sellAreaCircle16.circleInner.CFrame = hrp.CFrame * CFrame.new()
            task.wait(.2)
            workspace.sellAreaCircles.sellAreaCircle16.circleInner.CFrame = CFrame.new(0, 0, 0)
        end
    end)
end

local function autohoopsfunc()
    task.spawn(function()
        while _G.autohoopsvar do
            local hoopspath = workspace.Hoops
            for i,v in ipairs(hoopspath:GetChildren()) do
            if not v:FindFirstChild("wasUsed") then
            v.touchPart.CFrame = hrp.CFrame
            task.wait(.09)
            v.touchPart.CFrame = CFrame.new(0, 0, 0)
                end
            end
            task.wait(.09)
        end
    end)
end

local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Benix",
    SubTitle = "Always free & keyless",
    TabWidth = 125,
    Size = UDim2.fromOffset(480, 380),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart"}),
    PVP = Window:AddTab({ Title = "PVP", Icon = "swords"}),
    Crystal = Window:AddTab({ Title = "Crystal", Icon = "gem"}),
    Config = Window:AddTab({ Title = "Config", Icon = "settings" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "cog" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "scroll" })
}


local Dropdown = Tabs.Crystal:AddDropdown("Dropdown", {
    Title = "Select Crystal",
    Description = "",
    Values = Crystal,
    Multi = false,
    Default = 1,
    Callback = function(value)
        _G.selectedegg = value
    end
})

local Toggle = Tabs.Crystal:AddToggle("MyToggle", 
{
    Title = "Open Crystals",
    Description = "",
    Default = false,
    Callback = function(state)
    _G.openCrystal = state
    task.spawn(function()
    while _G.openCrystal and task.wait(.5) do
        if _G.selectedegg then
            game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer("openCrystal", _G.selectedegg)
            end
        end
    end)
end
})

Tabs.Credits:AddButton({
    Title = "Discord Server",
    Description = "",
    Callback = function()
        setclipboard("https://dsc.gg/benixscripts")
    end
})

Tabs.Credits:AddButton({
    Title = "Youtube Channel",
    Description = "",
    Callback = function()
        setclipboard("https://www.youtube.com/channel/UC4dzfAboguKKoo0Z4wMozTA/community?pvf=CAE%253D")
    end
})


Tabs.Credits:AddParagraph({
    Title = "Developers",
    Content = "hzpu"
})

local Toggle = Tabs.PVP:AddToggle("MyToggle", 
{
    Title = "Kill All",
    Description = "",
    Default = false,
    Callback = function(state)
        _G.killallvar = state
        if state then
            killall()
        end
    end
})

local Section = Tabs.PVP:AddSection("Kill Aura")

local Toggle = Tabs.PVP:AddToggle("MyToggle", 
{
    Title = "Kill Aura", 
    Description = "needs shuriken to attack | beta",
    Default = false,
    Callback = function(state)
        _G.killaura = state
	if state then
        killaurafunc()
    end
    end 
})

local Section2 = Tabs.PVP:AddSection("Kill Aura Settings")

local Dropdown = Tabs.PVP:AddDropdown("Dropdown", {
    Title = "Kill Aura Mode",
    Description = "",
    Values = {"None", "Teleport"},
    Multi = false,
    Default = 1,
    Callback = function(value)
        if value == "None" then
            _G.killauramode = 1
        elseif value == "Teleport" then
            _G.killauramode = 0
        end
        end
})


local Slider = Tabs.PVP:AddSlider("Slider", 
{
    Title = "Kill Aura Distance",
    Description = "",
    Default = 10,
    Min = 5,
    Max = 25,
    Rounding = 1,
    Callback = function(Value)
        _G.killauradis = Value
        if _G.killaura then
            killaurafunc()
        end
    end
})

local Slider2 = Tabs.PVP:AddSlider("Slider2", 
{
    Title = "Kill Aura X Offset",
    Description = "",
    Default = 10,
    Min = 0,
    Max = 25,
    Rounding = 1,
    Callback = function(Value)
        _G.killaurax = Value
    end
})

local Slider3 = Tabs.PVP:AddSlider("Slider3", 
{
    Title = "Kill Aura Y Offset",
    Description = "",
    Default = 10,
    Min = 0,
    Max = 25,
    Rounding = 1,
    Callback = function(Value)
        _G.killauray = Value
    end
})

local Slider4 = Tabs.PVP:AddSlider("Slider4", 
{
    Title = "Kill Aura Z Offset",
    Description = "",
    Default = 10,
    Min = 0,
    Max = 25,
    Rounding = 1,
    Callback = function(Value)
        _G.killauraz = Value
    end
})

Tabs.Misc:AddButton({
    Title = "Inf Multi Jump",
    Description = "",
    Callback = function()
        game:GetService("Players").LocalPlayer.multiJumpCount.Value = 10000000000000000
    end
})

Tabs.Misc:AddButton({
    Title = "Unlock All Elements",
    Description = "",
    Callback = function()
        rEvents.elementMasteryEvent:FireServer("Inferno")
        rEvents.elementMasteryEvent:FireServer("Frost")
        rEvents.elementMasteryEvent:FireServer("Shadow Charge")
        rEvents.elementMasteryEvent:FireServer("Eternity Storm")
        rEvents.elementMasteryEvent:FireServer("Lightning")
        rEvents.elementMasteryEvent:FireServer("Blazing Entity")
        rEvents.elementMasteryEvent:FireServer("Shadowfire")
        rEvents.elementMasteryEvent:FireServer("Electral Chaos")
        rEvents.elementMasteryEvent:FireServer("Masterful Wrath")
    end
})

Tabs.Misc:AddButton({
    Title = "Unlock All Islands",
    Description = "",
    Callback = function()
        unlockallislands()
    end
})

local Toggle = Tabs.Shop:AddToggle("MyToggle", 
{
    Title = "Auto Buy Belts",
    Description = "",
    Default = false,
    Callback = function(state)
        _G.autobuybeltsvar = state
        if state then
        autobuybelt()
        end
    end
})

local Toggle2 = Tabs.Shop:AddToggle("MyToggle2", 
{
    Title = "Auto Buy Swords", 
    Description = "",
    Default = false,
    Callback = function(state)
        _G.autobuyswordvar = state
        if state then
        autobuysword()
        end
    end
})

local Toggle4 = Tabs.Shop:AddToggle("MyToggle4", 
{
    Title = "Auto Buy Ranks", 
    Description = "buggy on low end devices",
    Default = false,
    Callback = function(state)
        _G.autobuyranksvar = state
        if state then
        autobuyranksfunc()
        end
    end
})

local Toggle5 = Tabs.Shop:AddToggle("MyToggle5", 
{
    Title = "Auto Buy Shurikens", 
    Description = "",
    Default = false,
    Callback = function(state)
        _G.autobuyshurikenvar = state
        if state then
        autobuyshurikenfunc()
        end
    end
})


local Section = Tabs.Shop:AddSection("Misc")

local Toggle2 = Tabs.Shop:AddToggle("MyToggle2", 
{
    Title = "Auto Spin Fortune Wheel", 
    Description = "",
    Default = false,
    Callback = function(state)
        _G.autospinfortunevar = state
        if state then
        autospinfortune()
        end
    end
})


local Toggle = Tabs.Main:AddToggle("MyToggle", 
{
    Title = "Auto Swing", 
    Description = "",
    Default = false,
    Callback = function(state)
	_G.autoswingvar = state
    if state then
    autoswingfunc()
    end
    end
})

local Toggle3 = Tabs.Main:AddToggle("MyToggle3", 
{
    Title = "Auto Sell", 
    Description = "",
    Default = false,
    Callback = function(state)
	_G.autosellvar = state
    if state then
    autosellfunc()
    end
    end
})

local Toggle4 = Tabs.Main:AddToggle("MyToggle4", 
{
    Title = "Auto Sell When Full", 
    Description = "",
    Default = false,
    Callback = function(state)
    _G.autosellwhenfullvar = state
    if state then
    autosellwhenfullfunc()
    end
    end
})


local Section = Tabs.Main:AddSection("Utility")

local Toggle2 = Tabs.Main:AddToggle("MyToggle2", 
{
    Title = "Auto Collect Hoops", 
    Description = "",
    Default = false,
    Callback = function(state)
	_G.autohoopsvar = state
    if state then
    autohoopsfunc()
    end
    end
})



local Toggle5 = Tabs.Main:AddToggle("MyToggle5", 
{
    Title = "Kill Coin Popups", 
    Description = "",
    Default = false,
    Callback = function(state)
	_G.killedpopup = state
        statGui.Enabled = not state
        hoopGui.Enabled = not state
    end
})
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder("BenixHub_Ninja_Legends")
SaveManager:BuildConfigSection(Tabs.Config)
SaveManager:LoadAutoloadConfig()
Window:SelectTab(1)
Fluent:Notify({
    Title = "Benix",
    Content = "The script has been loaded.",
    Duration = 8
})
 
