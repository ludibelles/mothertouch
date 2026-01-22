-- Function to heal a character
function heal(character)
    local currentHealth = character.health
    local maxHealth = character.maxHealth
    local missingHealth = maxHealth - currentHealth

    -- Heal only 50% of missing health instead of 100%
    local healAmount = missingHealth * 0.5
    character.health = math.min(maxHealth, currentHealth + healAmount)
end

-- Example of using the heal function
-- heal(character) -- Uncomment this line to heal the character
