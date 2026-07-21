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
        this.m.IsTargeted = true;
        this.m.ActionPointCost = 3;
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
        this.m.IconDisabled = this.m.Icon;
        this.m.Overlay = "potion_helper_health_" + this.m.Tier;
    }

    function onUse( _user, _targetTile )
    {
        ::PotionHelper.restoreHealth(_user, this.m.Tier);
        this.m.Item.get().removeSelf();
        return true;
    }
});
