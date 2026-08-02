if (!("Compatibility" in ::PotionHelper))
{
    ::PotionHelper.Compatibility <- {};
}

::PotionHelper.Compatibility.Legends <- {
    function registerHooks( _mod )
    {
        _mod.hook("scripts/entity/world/settlements/buildings/building", function(q)
        {
            q.fillStash = @(__original) function( _list, _stash, _priceMult, _allowDamagedEquipment = false )
            {
                local result = __original(_list, _stash, _priceMult, _allowDamagedEquipment);
                local buildingID = this.getID();

                if (buildingID == "building.marketplace")
                {
                    ::PotionHelper.addMarketStock(this, _stash, false);
                    ::PotionHelper.Mod.Debug.printLog("[PotionHelper][Legends] added potion stock to marketplace");
                }
                else if (buildingID == "building.alchemist")
                {
                    ::PotionHelper.addMarketStock(this, _stash, true);
                    ::PotionHelper.Mod.Debug.printLog("[PotionHelper][Legends] added potion stock to alchemist");
                }

                return result;
            };
        });
    }
};
