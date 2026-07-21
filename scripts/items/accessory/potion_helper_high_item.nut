this.potion_helper_high_item <- this.inherit("scripts/items/accessory/potion_helper_health_item", {
    function create()
    {
        this.potion_helper_health_item.create();
        this.m.ID = "accessory.potion_helper_high";
        this.m.Name = "High Health Potion";
        this.m.Description = "A powerful emergency health potion.";
        this.m.Tier = "high";
        this.m.Icon = "consumables/potion_helper_health_high.png";
        this.m.Value = ::PotionHelper.getPrice("HighHealthPrice");
    }
});
