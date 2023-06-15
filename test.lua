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

        local tweenInfo = TweenInfo.new(speed or 10, Enum.EasingStyle.Quad)
        tween = game:GetService("TweenService"):Create(rootPart, tweenInfo, {CFrame = targetCFrame})

        local function cancelTeleportation()
            wait(0.1)
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
                teleportTriggered = true
                print("300 studs reached")
                cancelTeleportation()
                wait(0.1)
                rootPart.CFrame = CFrame.new(-2839, 1121, -1003)
                wait(0.2)
                print("Instant teleportation to target")
                  FireProximityPrompt(game:GetService("Workspace").chatnpcs.Quest:GetChildren()[6].ProximityPrompt)
                  wait(0.5)
                mousemoverel(770, 565)

                keypress(0x02)

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

TweenTPToCFrame(targetCFrame, 10)
