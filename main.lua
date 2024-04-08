BernMod = RegisterMod("Bernkastel Character Mod", 1)

require("scripts.kakera")

local kakera = Isaac.GetItemIdByName("Kakera")
local bernType = Isaac.GetPlayerTypeByName("Bernkastel", false) -- Exactly as in the xml. The second argument is if you want the Tainted variant.
local hairCostume = Isaac.GetCostumeIdByPath("gfx/characters/bernkastel_hair.anm2") -- Exact path, with the "resources" folder as the root
local stolesCostume = Isaac.GetCostumeIdByPath("gfx/characters/bernkastel_body.anm2") -- Exact path, with the "resources" folder as the root
function BernMod:GiveCostumesOnInit(player)
    if player:GetPlayerType() ~= bernType then
        return -- End the function early. The below code doesn't run, as long as the player isn't Gabriel.
    end
    player:AddNullCostume(hairCostume)
    player:AddNullCostume(stolesCostume)
    player:SetPocketActiveItem(kakera, ActiveSlot.SLOT_POCKET, false)
end

BernMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BernMod.GiveCostumesOnInit)


--------------------------------------------------------------------------------------------------


local game = Game() -- We only need to get the game object once. It's good forever!
local DAMAGE_PROMOTION = 0.5
function BernMod:HandleStartingStats(player, flag)
    if player:GetPlayerType() ~= bernType then
        return -- End the function early. The below code doesn't run, as long as the player isn't Gabriel.
    end

    if flag == CacheFlag.CACHE_DAMAGE then
        -- Every time the game reevaluates how much damage the player should have, it will reduce the player's damage by DAMAGE_REDUCTION, which is 0.6
        player.Damage = player.Damage + DAMAGE_PROMOTION
    end
end

BernMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, BernMod.HandleStartingStats)