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
        this.m.Order = this.Const.SkillOrder.Any - 10; // Puts it neatly with other active items
	    this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsUsingHitchance = false;
        this.m.ActionPointCost = ::PotionHelper.conf("PotionDrinkAPCost");
        this.m.FatigueCost = 5;
        this.m.MinRange = 0;
        this.m.MaxRange = 1;
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

    function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				text = this.getCostString()
			}
		];

		return ret;
	}

	function getCursorForTile( _tile )
	{
		return this.Const.UI.Cursor.Bandage;
	}

	function isUsable()
	{
		if (!this.Tactical.isActive())
		{
			return false;
		}

		return true;
	}

    function onUse( _user, _targetTile )
    {
        ::PotionHelper.restoreHealth(_user, this.m.Tier);

        if (this.m.Item != null && !this.m.Item.isNull())
        {
            this.m.Item.removeSelf();
        }

        if (this.getContainer() != null)
        {
            this.getContainer().remove(this);
        }

        return true;
    }
});