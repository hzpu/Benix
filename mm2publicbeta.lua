_G.coinfarmtoggle = true
_G.tweenspeed = 25
_G.delaytonextcoin = 0.2
_G.snapDistance = 4
_G.serverhop = true
_G.maxdis = 100
_G.disable3drendering = true
_G.fpslimit = 20 
_G.antiafk = true
local PN = game:GetService("Players").LocalPlayer.Name
local Players = game:GetService("Players")
local playerCount = #Players:GetPlayers()
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = nil
local TweenService = game:GetService("TweenService")
local mindis = math.huge
local nearestCoin = nil
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local placeId = game.PlaceId
local player = Players.LocalPlayer

local Humanoid = character:FindFirstChildOfClass("Humanoid")
local humanoid = character:FindFirstChildOfClass("Humanoid")
local mapnames = {"IceCastle","SkiLodge","Station","LogCabin","Bank2","BioLab","House2","Factory","Hospital3","Hotel","Mansion2","MilBase","Office3","PoliceStation","Workplace","ResearchFacility","ChristmasItaly"}

local function updatehrp()
    if not character or not character:IsDescendantOf(workspace) then
        character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    end
    if not hrp or not hrp:IsDescendantOf(character) then
        hrp = character:WaitForChild("HumanoidRootPart")
    end
end



game:GetService("RunService").Heartbeat:Connect(function()
    updatehrp()
end)

if _G.antiafk then
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        return nil
    end)
end

if _G.fpslimit then
    setfpscap(_G.fpslimit)
end

if _G.disable3drendering then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
end


local function serverHop()
    local servers = {}
    local cursor = ""
    while true do
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        if cursor ~= "" then
            url = url .. "&cursor=" .. cursor
        end

        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if success and response and response.data then
            for _, server in ipairs(response.data) do
                local hasSpace = server.playing < server.maxPlayers and server.id ~= game.JobId
                if hasSpace then
                    table.insert(servers, server)
                end
            end
            if response.nextPageCursor then
                cursor = response.nextPageCursor
            else
                break
            end
        else
            warn("Failed to get server list")
            break
        end
    end
    if #servers > 0 then
        table.sort(servers, function(a, b)
            return a.playing < b.playing
        end)
        TeleportService:TeleportToPlaceInstance(placeId, servers[1].id, player)
    else
        warn("no server found ;ccc")
    end
end

    task.spawn(function()
        while _G.coinfarmtoggle do
            for _, mapname in ipairs(mapnames) do
                local mapthing = workspace:FindFirstChild(mapname)
                if mapthing and mapthing:FindFirstChild("CoinContainer") then
                    local cc = mapthing.CoinContainer
                    nearestCoin = nil
                    mindis = math.huge
                    for _, coin in ipairs(cc:GetChildren()) do
                        if coin:IsA("BasePart") and coin.Name == "Coin_Server" and coin:FindFirstChild("TouchInterest") then
                            local cv = coin:FindFirstChild("CoinVisual")
                            if cv then
                                local dist = (coin.Position - hrp.Position).Magnitude
                                _G.maxdis = tonumber(_G.maxdis) or 100
                                if dist <= _G.maxdis and dist < mindis then
                                    mindis = dist
                                    nearestCoin = coin
                                end
                            end
                        end
                    end

                    if nearestCoin then
                        local coinpos = nearestCoin.Position
                        local distance = (coinpos - hrp.Position).Magnitude
                        local time = math.max(distance / _G.tweenspeed)
                        local ti = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                        hrp.Anchored = true
                        local tween = TweenService:Create(hrp, ti, {CFrame = CFrame.new(coinpos)})
                        local snapped = false
                        if hrp and nearestCoin and nearestCoin:IsDescendantOf(workspace) then
                            tween:Play()
                            local cnt
                            cnt = game:GetService("RunService").Heartbeat:Connect(function()
                                local currentpos = (coinpos - hrp.Position).Magnitude
                                if not _G.coinfarmtoggle then
                                    tween:Cancel()
                                    cnt:Disconnect()
                                    hrp.Anchored = false
                                    return
                                end
                                if currentpos <= _G.snapDistance then
                                    tween:Cancel()
                                    hrp.Anchored = false
                                    hrp.CFrame = CFrame.new(coinpos) * CFrame.new(0, 0.2, 0)
                                    task.wait()
                                    hrp.CFrame = CFrame.new(coinpos)
                                    snapped = true
                                    task.wait()
                                    cnt:Disconnect()
                                    nearestCoin = nil
                                end
                            end)
                        tween.Completed:Wait()
                        if cnt and cnt.Connected then
                            cnt:Disconnect()
                        end
                        task.wait(_G.delaytonextcoin)
                        hrp.Anchored = false
                        if _G.serverhop then
                            if #game.Players:GetPlayers() <= 2 then
                                serverHop()
                            end
                        end
                    end
                    end
                end
                task.wait()
            end
        end
    end)

print("benix is loaded <3 enjoy!")
