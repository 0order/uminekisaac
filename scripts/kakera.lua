local kakera = Isaac.GetItemIdByName("Kakera")
local wisps = 0
local hasitem = 0
local wispAlive = 0

function BernMod:onStart()
    wisps = 0
    hasitem = 0
    wispAlive = 0
end

BernMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BernMod.onStart)
BernMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, BernMod.onStart)


function BernMod:kakeraUse(itemUsed, _, player, _, slot, _)
    local x = Isaac.GetPlayer(0).Position.X
    local y = Isaac.GetPlayer(0).Position.Y
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, Game():GetItemPool():GetCollectible(ItemPoolType.POOL_NULL), Vector(x,y+50), Vector(0,0), nil);

    local roomEntities=Isaac.GetRoomEntities()
    for _, entity in ipairs(roomEntities) do
        if entity.Type == 3 then
            entity:TakeDamage(5,0,EntityRef(player),1)
        end
    end
    return{
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end


function BernMod:spawn(player)
    local x = Isaac.GetPlayer(0).Position.X
    local y = Isaac.GetPlayer(0).Position.Y
        while wisps > 0 do
            if wispAlive < 6 then
                player:AddWisp(kakera, Vector(x,y), 0, 0)
                wispAlive = wispAlive + 1
            end
            wisps = wisps -1    
        end

    local itemCount = player:GetCollectibleNum(kakera)
        if itemCount > 0 then
            hasitem = 1
        else hasitem = 0
        end
    
        if hasitem == 1 then
            player.SetActiveCharge(player,wispAlive,ActiveSlot.SLOT_POCKET)
        end

end


function BernMod:add()
    if hasitem == 1 then
        wisps = wisps + 1
    end
end

function BernMod:kill()
    if wispAlive > 0 then
        wispAlive = wispAlive - 1
    end
end

function BernMod:card(cardUsed,player)
    local itemCount = player:GetCollectibleNum(kakera)
    if itemCount > 0 then
        hasitem = 1
    else hasitem = 0
    end
    if hasitem == 1 then
        if cardUsed == 96 then
            wispAlive=6
        end
    end
end



BernMod:AddCallback(ModCallbacks.MC_USE_ITEM,BernMod.kakeraUse,kakera)
BernMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE,BernMod.spawn)
BernMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,BernMod.add)
BernMod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL,BernMod.kill,3)
BernMod:AddCallback(ModCallbacks.MC_USE_CARD,BernMod.card)