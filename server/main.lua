local QBCore = exports['qb-core']:GetCoreObject()
function GetLevelValue(level)
    if level == 3 then
        value = Config.Levels[level]
    else
        value = Config.Levels[level + 1]
    end
    if value then
        return value
    else
        return nil
    end
end

function sendLogs(color, name, message, footer, logs)
    local embed = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = footer,
              },
          }
      }
  
    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end


lib.callback.register('cy_weaponcraft:getPlayerXP', function(source)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then
        return nil
    end
    local identifier = player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT xp FROM cy_weaponcraft WHERE identifier = ?', { identifier })
    if result and result[1] then
        return result[1].xp
    else
        return nil
    end
end)

lib.callback.register('cy_weaponcraft:levelUp', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then
        return false, "Spiller ikke fundet"
    end
    local identifier = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT level, xp FROM cy_weaponcraft WHERE identifier = ?', { identifier })
    if not result or #result < 1 then
        return false, "Spiller data ikke fundet"
    end
    local currentLevel = result[1].level
    local currentXP = result[1].xp
    local xpToLevelUp = GetLevelValue(currentLevel)
    if currentLevel == 3 then
        return false, "Du kan ikke level mere op!"
    end
    if currentXP >= xpToLevelUp then
        local newLevel = currentLevel + 1
        local remainingXP = 0
        MySQL.update.await('UPDATE cy_weaponcraft SET level = ?, xp = ? WHERE identifier = ?', { newLevel, remainingXP, identifier })
        sendLogs(7730498, "CY WEAPON CRAFT", "Player: ".. Player.PlayerData.name .. "\nLevel up: " ..newLevel, "Lavet af Notepad", Config.Logs.CraftWeapon)
        return true, { newLevel = newLevel, remainingXP = remainingXP }
    else
        return false, "Du har ikke nok XP."
    end
end)

RegisterNetEvent('cy_weaponcraft:increaseXp', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        print("Player not found")
        return
    end

    local identifier = Player.PlayerData.citizenid
    local addedXp = math.random(25, 50)
    local currentXp = 0
    MySQL.Async.fetchScalar('SELECT xp FROM cy_weaponcraft WHERE identifier = ?', { identifier }, function(result)
        if result then
            currentXp = result
        else
            MySQL.insert('INSERT INTO cy_weaponcraft (identifier, xp) VALUES (?, ?)', { identifier, 0 })
        end
        local newXp = currentXp + addedXp
        MySQL.update('UPDATE cy_weaponcraft SET xp = ? WHERE identifier = ?', { newXp, identifier })

        TriggerClientEvent('QBCore:Notify', src, ("Din XP er blevet øget med %d! Total XP: %d"):format(addedXp, newXp), 'success')
        sendLogs(7730498, "CY WEAPON CRAFT", "Player: ".. Player.PlayerData.name.. "\nModtog XP: ".. addedXp .. "\nXP: ".. newXp, "Lavet af Notepad", Config.Logs.XPGain)
    end)
end)


lib.callback.register('cy_weaponcraft:getplayerLevel', function(source)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then
        return nil
    end
    local identifier = player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT level FROM cy_weaponcraft WHERE identifier = ?', {identifier})
    if result[1] then
        return result[1].level
    else
        return nil
    end
end)
lib.callback.register('cy_weaponcraft:checkCraftableWeapon', function(source, weaponName)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then
        return false, "Player not found"
    end
    if not Config.RequiredItems[weaponName] then
        return false, "Invalid weapon: " .. weaponName
    end

    local requiredItems = Config.RequiredItems[weaponName]
    local hasAllItems = true

    for _, req in ipairs(requiredItems) do
        local playerItem = Player.Functions.GetItemByName(req.item)
        if not playerItem or playerItem.amount < req.amount then
            hasAllItems = false
            break
        end
    end

    if hasAllItems then
        for _, req in ipairs(requiredItems) do
            exports.ox_inventory:RemoveItem(source, req.item, req.amount)
        end
        exports.ox_inventory:AddItem(source, weaponName, 1)
        sendLogs(7730498, "CY WEAPON CRAFT", "Player: ".. Player.PlayerData.name .. "\nCrafted: ".. weaponName, "Lavet af Notepad", Config.Logs.CraftWeapon)
        return true, "Våbenet blev fremstillet med succes!"
    else
        return false, "Ikke nok nødvendige genstande til at fremstille dette!"
    end
end)

lib.callback.register('cy_weaponcraft:addPlayer', function(source)
    local player = QBCore.Functions.GetPlayer(source)
    local identifier = player.PlayerData.citizenid
    MySQL.Async.fetchScalar('SELECT 1 FROM cy_weaponcraft WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result then
            MySQL.Async.execute('INSERT INTO cy_weaponcraft (identifier, level, xp) VALUES (@identifier, @level, @xp)', {
                ['@identifier'] = identifier,
                ['@level'] = 0,
                ['@xp'] = 0,
            }, function(rowsChanged)
                return false
            end)
        else
            return false
        end
    end)
end)

AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
    local playerId = player.PlayerData.citizenid
    MySQL.Async.fetchAll('SELECT * FROM cy_weaponcraft WHERE identifier = @identifier', {
        ['@identifier'] = playerId
    }, function(result)
        if #result == 0 then
            MySQL.Async.execute('INSERT INTO cy_weaponcraft (identifier, level, xp) VALUES (@identifier, @level, @xp)', {
                ['@identifier'] = playerId,
                ['@level'] = 0, -- Default level
                ['@xp'] = 0     -- Default XP
            })
            sendLogs(7730498, "CY WEAPON CRAFT", "Tilføjede spiller til cy_weaponcraft database: ".. playerId, "Lavet af Notepad", Config.Logs.AddedPlayer)
        end
    end)
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        SetTimeout(2000, function()
            TriggerClientEvent('cy_weaponcraft:cacheConfig', -1)
        end)
    end
end)