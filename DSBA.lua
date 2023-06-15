--[[
too lazy to do the update log in another page so i'll do it here so whats up!
This has been sent the 06/15/2023 and i've added new 'features' and i'll spoil the other ones lol
1st one is that i've optimized some parameters, for example The TweenTP. 
If you wish to execute the script starting from the spawn I strongly advice you to modify at the end of the script the CFrame speed to 5 from 10.
You can run the script normally in the snow biome without any issues! I've also modified how the TweenTP works when close to the quest! It should be instantly teleporting
the player when close to the quest giver so we avoid TweenTP dynamic speed, and to gain some time!
Upcoming updates! 
Add of a FireProximityPrompt() (Auto accept quest)
Return to Original location if in the Snow biome (basically near the qustgiver lmao)
and that is it! enjoy boys!
--]]


local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local platformHeight = 2
local platformSize = Vector3.new(4, 0.2, 4) 

local createPlatform = true

local platform = nil
local teleporting = false
local teleported = false
local tween = nil 
local teleportTriggered = false 

local function createPlatform()
    if platform then
        platform:Destroy()
        platform = nil
        print("Platform Removed")
    end

    if createPlatform and not teleporting then
        platform = Instance.new("Part")
        platform.Size = platformSize
        platform.CanCollide = true
        platform.Anchored = true
        platform.Parent = workspace
    end
end

local function updatePlatformPosition()
    if platform then
        local offset = Vector3.new(0, platformHeight + (rootPart.Size.Y / 2), 0)
        platform.Position = rootPart.Position - offset
    end
end

game:GetService("RunService").Heartbeat:Connect(updatePlatformPosition)

player.CharacterAdded:Connect(createPlatform)

createPlatform()

local function TweenTPToCFrame(cframe, speed)
    if platform then
        local targetCFrame = platform.CFrame * cframe

        local tweenInfo = TweenInfo.new(speed or 1, Enum.EasingStyle.Quad)
        tween = game:GetService("TweenService"):Create(rootPart, tweenInfo, {CFrame = targetCFrame})

        local function cancelTeleportation()
            wait(0.1) --Do not remove this pls 
            if platform then
                platform:Destroy()
                platform = nil
                print("Platform Removed")
            end
            tween:Cancel()
            teleporting = false
            teleported = true
            print("TweenTP cancelled")
        end

        teleporting = true
        teleported = false
        teleportTriggered = false 
        print("TweenTP initiated")
        tween:Play()

        while tween.PlaybackState == Enum.PlaybackState.Playing do
            local distance = (targetCFrame.Position - rootPart.Position).Magnitude
            if distance <= 300 and not teleported and not teleportTriggered then
                teleportTriggered = true -- set the flag to true to prevent repeated teleportation without it your roblox would crash LOL
                print("300 studs reached")
                cancelTeleportation()
                wait(0.1) 
                rootPart.CFrame = targetCFrame 
                print("Instant teleportation to target")
                break
            end
            wait() 
        end
    end
end

local function checkPlayerDistance()
    local targetCFrame = CFrame.new(-2844.87524, 1121.98523, -1008.09894, -0.707116485, -8.28877091e-06, -0.70709753, 3.40334955e-05, 1, -4.57502902e-05, 0.70709753, -5.64306974e-05, -0.707116485)
    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    if distance <= 300 and not teleporting and not teleported and not teleportTriggered then
        teleportTriggered = true 
        print("300 studs reached")
        TweenTPToCFrame(targetCFrame, 1)
    elseif distance > 300 and teleported then
        teleported = false
    end
end

game:GetService("RunService").Heartbeat:Connect(checkPlayerDistance)

local targetCFrame = CFrame.new(-2844.87524, 1121.98523, -1008.09894, -0.707116485, -8.28877091e-06, -0.70709753, 3.40334955e-05, 1, -4.57502902e-05, 0.70709753, -5.64306974e-05, -0.707116485)

TweenTPToCFrame(targetCFrame, 5)  --The actual speed changer, the closer it gets from 0 the faster it is. Using less than 5 is risky and could get you kicked.
