local QBCore = exports['qb-core']:GetCoreObject()
local eye
function hideUI()
    SetNuiFocus(false, false)
    SendNUIMessage({type = 'hideUI', data = { value = ''}})
end
function showUI()
    SendNUIMessage({
        type = 'showUI',
        data = {
            value = "FiveM Value"
        }
    })

    SetNuiFocus(true, true)
end
RegisterNUICallback("close", function(data, cb)
    SetNuiFocus(false, false)
    cb({
        success = true
    })
end)
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
RegisterNUICallback("getPlayerLevel", function (data, cb)
    lib.callback('cy_weaponcraft:getplayerLevel', false, function(level)
        if level then
            cb(level)
        end
    end)
end)
RegisterNUICallback("getPlayerXP", function (data, cb)
    lib.callback('cy_weaponcraft:getPlayerXP', false, function(xp)
        if xp then
            cb(xp)
        end
    end)
    
end)
RegisterNUICallback("getPlayerLevelUpgrade", function (data, cb)
    lib.callback('cy_weaponcraft:getplayerLevel', false, function(level)
        if level then
            local levelData = GetLevelValue(level)
            cb(levelData)
        end
    end)
end)
RegisterNUICallback("levelPlayerUp", function (data, cb)
    lib.callback('cy_weaponcraft:levelUp', false, function(success, data)
        if success then
            TriggerEvent('QBCore:Notify', 'Tillykke! Du levellede op til Level ' .. data.newLevel, 'success')
            hideUI()
        else
            TriggerEvent('QBCore:Notify', data, 'error')
        end
    end)
end)

RegisterNUICallback("weapon_craft", function(data, cb)
    local itemsToCraft = data.itemsToCraft  -- Fix the variable name, should match with `data`
    hideUI()
    lib.callback('cy_weaponcraft:checkCraftableWeapon', false, function(success, message)
        if success then
            TriggerEvent('QBCore:Notify', message, 'success')
            TriggerServerEvent('cy_weaponcraft:increaseXp')
        else
            TriggerEvent('QBCore:Notify', message, 'error')
        end
    end, itemsToCraft)
end)

RegisterNUICallback('getWeaponConfig', function(data, cb)
    cb(Config.Weapons)
end)

local function createEye()
    eye = exports.ox_target:addBoxZone({
        name = "cy_weaponcraft:craftBench",
        debug = false,
        coords = Config.WeaponBenchLocation[1],
        size = vec3(3.0, 1.0, 1.0),
        rotation = 25,
        options = {
            {
                icon = Config.EyeSettings.icon,
                label = Config.EyeSettings.label,
                distance = 1,
                onSelect = function (source)
                    showUI()
                end
            }
        },
    })
end

local function removeEye()
    if eye then
        exports.ox_target:removeZone(eye)
        eye = nil
    end
end

local function createEyePoint()
    eyeZone = lib.points.new({ coords = Config.WeaponBenchLocation[1], distance = 50, onEnter = createEye, onExit = removeEye, })
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        removeEye()
    end
end)

RegisterNetEvent('cy_weaponcraft:cacheConfig', function()
    if GetInvokingResource() then return end
    Wait(1000)
    createEyePoint()
end)