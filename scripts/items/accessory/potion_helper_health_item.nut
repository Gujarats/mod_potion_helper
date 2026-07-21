this.potion_helper_health_item <- this.inherit("scripts/items/accessory/accessory", {
    m = {
        Tier = "low"
    },

    function create()
    {
        this.accessory.create();
        this.m.SlotType = this.Const.ItemSlot.Bag;
        this.m.IsAllowedInBag = true;
        this.m.IsDroppedAsLoot = true;
        this.m.ShowOnCharacter = false;
        this.m.Icon = "consumables/potion_01.png";
        this.m.Value = 35;
    }

    function onEquip()
    {
        this.accessory.onEquip();
        local skill = this.new("scripts/skills/actives/potion_helper_drink_skill");
        skill.setItem(this);
        skill.setTier(this.m.Tier);
        this.addSkill(skill);
    }

    function onPutIntoBag()
    {
        this.onEquip();
    }

    function onUse( _actor, _item = null )
    {
        if (_actor == null || this.Tactical.isActive())
        {
            return false;
        }

        ::PotionHelper.restoreHealth(_actor, this.m.Tier);
        if (this.m.Tier == "high" && this.Math.rand(1, 100) <= ::PotionHelper.conf("HighInjuryCureChance"))
        {
            local injuries = _actor.getSkills().query(this.Const.SkillType.TemporaryInjury);
            if (injuries.len() > 0)
            {
                _actor.getSkills().remove(injuries[this.Math.rand(0, injuries.len() - 1)]);
            }
        }

        return true;
    }
});
