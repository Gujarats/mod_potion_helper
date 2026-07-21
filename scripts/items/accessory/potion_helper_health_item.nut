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
        this.m.ItemType = this.Const.Items.ItemType.Usable;
        this.m.IsUsable = true;
        this.m.Icon = "consumables/potion_01.png";
        this.m.Value = 35;
    }

    function isUsable()
    {
        if (!this.item.isUsable())
        {
            return false;
        }

        local container = this.getContainer();
        if (container != null && container.getActor() != null && !container.getActor().isNull())
        {
            local actor = container.getActor();
            if (actor.getHitpoints() >= actor.getHitpointsMax())
            {
                return false;
            }
        }

        return true;
    }

    function onEquip()
    {
        this.accessory.onEquip();
        local skill = this.new("scripts/skills/actives/potion_helper_drink_skill");
        skill.setItem(this);
        skill.setTier(this.m.Tier);
        this.addSkill(skill);
    }

    function onUnequip()
    {
        if (this.m.Skill != null && !this.m.Skill.isNull() && this.getContainer() != null && this.getContainer().getActor() != null)
        {
            this.getContainer().getActor().getSkills().remove(this.m.Skill);
        }

        this.accessory.onUnequip();
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

        if (_actor.getHitpoints() >= _actor.getHitpointsMax())
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
