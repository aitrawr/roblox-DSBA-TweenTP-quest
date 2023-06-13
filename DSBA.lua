local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local platformHeight = 2 
local platformSize = Vector3.new(4, 0.2, 4) -- u can ajust even tho its alright like this

local createPlatform = true 

local platform 
local teleporting = false 
local teleported = false 


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

game:GetService("RunService").RenderStepped:Connect(updatePlatformPosition)

player.CharacterAdded:Connect(createPlatform)

createPlatform()

local function teleportToCFrame(cframe, speed)
    if platform then
        local targetCFrame = platform.CFrame * cframe
        
        local tweenInfo = TweenInfo.new(speed or 1, Enum.EasingStyle.Quad)
        local tween = game:GetService("TweenService"):Create(rootPart, tweenInfo, {CFrame = targetCFrame})
        
        local connection
        connection = tween.Completed:Connect(function()
            connection:Disconnect() 
            if platform then
                platform:Destroy()
                platform = nil
                print("Platform Removed")
            end
            teleporting = false
            teleported = true
        end)
        
        teleporting = true
        teleported = false
        print("TweenTP initiated")
        tween:Play()
    end
end

local function instantTeleportToCFrame(cframe)
    if platform then
        platform:Destroy()
        platform = nil
        print("Platform Removed")
        
        rootPart.CFrame = cframe
        
        teleporting = false
        teleported = true
    end
end

local function checkPlayerDistance()
    local targetCFrame = CFrame.new(-2844.87524, 1121.98523, -1008.09894, -0.707116485, -8.28877091e-06, -0.70709753, 3.40334955e-05, 1, -4.57502902e-05, 0.70709753, -5.64306974e-05, -0.707116485)
    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    if distance <= 300 and not teleporting and not teleported then
        print("300 studs reached")
        instantTeleportToCFrame(targetCFrame)
        print("Instant teleportation to target")
    elseif distance > 300 and teleported then
        teleported = false
    end
end

game:GetService("RunService").RenderStepped:Connect(checkPlayerDistance)
