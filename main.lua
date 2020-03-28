local healthBefore = 0
local maxSlowdown = 5
local slowdown = maxSlowdown
local typeAlert = "1"
local percentageLimit = 0.75

local Congrats_EventFrame = CreateFrame("Frame")
Congrats_EventFrame:RegisterEvent("UNIT_HEALTH")
Congrats_EventFrame:SetScript("OnEvent",
function(self, event, unit)
    local health = UnitHealth(unit)
    local maxHealth = UnitHealthMax(unit)
    local limit = maxHealth * percentageLimit
    local role = UnitGroupRolesAssigned(unit);
        
    if  (typeAlert == "1" and unit == "player") or 
        (typeAlert == "2" and role == "TANK")   or
        (typeAlert == "3" and (unit == "player" or role == "TANK")) then
        -- print("health " .. health)
        -- print("healthBefore " .. healthBefore)
        -- print("slowdown " .. slowdown)
        if health <= limit and health < healthBefore and slowdown == maxSlowdown then
            -- PlaySound("PVPTHROUGHQUEUE", "master");
            PlaySoundFile("Interface\\AddOns\\PlanicHealthSound\\oskur.ogg", "Master")
            slowdown = 0
            -- print("LIMITS")
        end

        healthBefore =  UnitHealth(unit)
        if health == maxHealth or health > maxHealth * percentageLimit then
            slowdown = maxSlowdown
        end
    end
end)

SLASH_PHSAlertType1 = "/PHSAlertType"
SlashCmdList["PHSAlertType"] = function(msg)
    if msg == "1" or msg == "2" or msg == "3" or msg == "4" then
        typeAlert = msg
        if msg == "1" then
            print("PlanicHealthSound : La vie du joueur sera contrôlée")
            slowdown = maxSlowdown
        elseif msg == "2" then
            print("PlanicHealthSound : La vie du Tank sera contrôlée")
            slowdown = maxSlowdown
        elseif msg == "3" then
            print("PlanicHealthSound : Les vie du joueur et du Tank seront contrôlées")
            slowdown = maxSlowdown
        elseif msg == "4" then
            print("PlanicHealthSound : L'addon est désactivé")
            slowdown = maxSlowdown
        end
    else
        print("PlanicHealthSound : les seules valeurs acceptées sont 1 (contrôle de la vie du joueur -- valeur par défaut), 2(contrôle de la vie du tank), 3(contrôle de la vie du joueur et du tank), 4(desactivé)")
    end
end 

SLASH_PHSAlertLimit1 = "/PHSAlertLimit"
SlashCmdList["PHSAlertLimit"] = function(msg)
    local percentage = tonumber(msg)
    percentageLimit = percentage/100
    slowdown = maxSlowdown
    print("PlanicHealthSound : La limite est bien passé a " .. percentage .. "% de votre vie")
end 