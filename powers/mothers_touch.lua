-- Mother's Touch Gift
-- Renown: Glory
-- Cost: 1 Willpower
-- Action: Full
-- Pool: Intelligence + Glory
-- 
-- The theurge channels spiritual power through their hands to heal 
-- the wounds of any other living creature. This Gift may not heal 
-- the user, spirits, or the undead.

local MothersTouch = {}

--- Simplified version for testing - fully heals the target
-- @param caster table The character using Mother's Touch
-- @param target table The character being healed
-- @return boolean success Whether the healing was successful
-- @return string message Result message
function MothersTouch.heal(caster, target)
    -- Validation checks (to be fully implemented later)
    if not caster then
        return false, "No caster provided"
    end
    
    if not target then
        return false, "No target provided"
    end
    
    -- Cannot heal self
    if caster.id == target.id then
        return false, "Cannot use Mother's Touch on yourself"
    end
    
    -- Check if target has health stats
    if not target.health or not target.health.max then
        return false, "Target has no health to heal"
    end
    
    -- TODO: Check willpower cost
    -- TODO: Check if target is spirit or undead
    -- TODO: Implement dice roll (Intelligence + Glory)
    
    -- TESTING VERSION: Full heal
    local healed_amount = target.health.max - target.health.current
    target.health.current = target.health.max
    
    return true, string.format("Mother's Touch heals %s for %d health! Fully restored.", 
                               target.name or "target", healed_amount)
end

--- Full implementation with dice rolls (for future use)
-- @param caster table The character using Mother's Touch
-- @param target table The character being healed
-- @param dice_result number Number of successes from Intelligence + Glory roll
-- @return boolean success Whether the healing was successful
-- @return string message Result message
function MothersTouch.heal_with_roll(caster, target, dice_result)
    -- Validation checks
    if not caster then
        return false, "No caster provided"
    end
    
    if not target then
        return false, "No target provided"
    end
    
    if caster.id == target.id then
        return false, "Cannot use Mother's Touch on yourself"
    end
    
    -- TODO: Implement willpower deduction
    -- TODO: Check race (no spirits or undead)
    
    -- Heal superficial damage
    local healed = math.min(dice_result, target.health.superficial or 0)
    target.health.superficial = (target.health.superficial or 0) - healed
    
    -- If successes exceed Rage, can heal 1 Aggravated
    if dice_result > (target.rage or 0) and (target.health.aggravated or 0) > 0 then
        target.health.aggravated = target.health.aggravated - 1
        return true, string.format("Mother's Touch heals %d superficial and 1 aggravated damage!", healed)
    end
    
    return true, string.format("Mother's Touch heals %d superficial damage!", healed)
end

return MothersTouch