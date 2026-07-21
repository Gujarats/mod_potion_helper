this.potion_helper_drink_skill <- this.inherit("scripts/skills/skill", {
    m = {
        Tier = "low"
    },

    function create()
    {
        this.m.ID = "actives.potion_helper_drink";
        this.m.Name = "Drink Health Potion";
        this.m.Description = "Drink this potion to restore health.";
        this.m.Type = this.Const.SkillType.Active;
        this.m.IsActive = true;
        this.m.IsStacking = true;
        this.m.IsTargeted = true;
        this.m.ActionPointCost = ::PotionHelper.conf("PotionDrinkAPCost");
        this.m.FatigueCost = 5;
        this.m.MinRange = 0;
        this.m.MaxRange = 0;
        this.m.SoundOnUse = [
            "sounds/combat/drink_01.wav",
            "sounds/combat/drink_02.wav",
            "sounds/combat/drink_03.wav"
        ];
    }

    function setTier( _tier )
    {
        this.m.Tier = _tier;
        this.m.Icon = "skills/potion_helper_health_" + this.m.Tier + ".png";
        this.m.IconDisabled = "skills/potion_helper_health_" + this.m.Tier + "_sw.png";
        this.m.Overlay = "potion_helper_health_" + this.m.Tier;
    }

    function onUse( _user, _targetTile )
    {
        ::PotionHelper.restoreHealth(_user, this.m.Tier);

        if (this.m.Item != null && !this.m.Item.isNull())
        {
            local container = this.m.Item.getItemContainer();
            if (container != null)
            {
                container.removeItem(this.m.Item);
            }
            else
            {
                this.m.Item.removeSelf();
            }
        }

        if (this.getContainer() != null)
        {
            this.getContainer().remove(this);
        }

        return true;
    }
});