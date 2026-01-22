-- Client-side script for Mother's Touch
-- Handles commands and particle effects

-- Register command to use Mother's Touch on another player
RegisterCommand('motherstouch', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    
    if not targetId then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"Mother's Touch", "Usage: /motherstouch [playerID]"}
        })
        return
    end
    
    -- Send to server to process
    TriggerServerEvent('motherstouch:heal', targetId)
end, false)

-- Receive healing from server
RegisterNetEvent('motherstouch:receiveHeal')
AddEventHandler('motherstouch:receiveHeal', function(healerName, healAmount)
    -- Play green sparkly particle effect
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Request particle effect dictionary
    RequestNamedPtfxAsset('core')
    while not HasNamedPtfxAssetLoaded('core') do
        Wait(0)
    end
    
    -- Use particle effect
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedAtCoord(
        'ent_sht_electrical_box',  -- Green sparkly effect
        coords.x, coords.y, coords.z + 1.0,
        0.0, 0.0, 0.0,
        1.5,  -- Scale
        false, false, false
    )
    
    -- Alternative green effect
    UseParticleFxAssetNextCall('core')
    StartParticleFxNonLoopedAtCoord(
        'ent_dst_elec_crackle',
        coords.x, coords.y, coords.z + 0.5,
        0.0, 0.0, 0.0,
        1.0,
        false, false, false
    )
    
    -- Notify player
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"Mother's Touch", string.format("%s healed you for %d HP! ✨", healerName, healAmount)}
    })
end)

-- Notify healer of successful heal
RegisterNetEvent('motherstouch:healSuccess')
AddEventHandler('motherstouch:healSuccess', function(targetName, healAmount)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"Mother's Touch", string.format("You healed %s for %d HP!", targetName, healAmount)}
    })
end)

-- Notify of errors
RegisterNetEvent('motherstouch:error')
AddEventHandler('motherstouch:error', function(message)
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"Mother's Touch", message}
    })
end)

-- Testing command to check health
RegisterCommand('checkhealth', function()
    TriggerServerEvent('motherstouch:checkHealth')
end, false)

RegisterNetEvent('motherstouch:displayHealth')
AddEventHandler('motherstouch:displayHealth', function(current, max)
    TriggerEvent('chat:addMessage', {
        color = {100, 200, 255},
        multiline = true,
        args = {"Health", string.format("Current: %d / %d HP", current, max)}
    })
end)

-- Testing command to damage yourself
RegisterCommand('damage', function(source, args)
    local amount = tonumber(args[1]) or 50
    TriggerServerEvent('motherstouch:takeDamage', amount)
end, false)