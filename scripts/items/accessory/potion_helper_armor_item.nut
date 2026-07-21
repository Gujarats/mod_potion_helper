this.potion_helper_armor_item <- this.inherit("scripts/items/item", {
    function create()
    {
        this.item.create();
        this.m.ID = "misc.potion_helper_armor";
        this.m.Name = "Armor Repair Potion";
        this.m.Description = "Repairs the most damaged equipped helmet or body armor outside battle.";
        this.m.ItemType = this.Const.Items.ItemType.Usable;
        this.m.IsUsable = true;
        this.m.Icon = "consumables/potion_helper_armor.png";
        this.m.Value = ::PotionHelper.getPrice("ArmorRepairPrice");
    }

    function onUse( _actor, _item = null )
    {
        if (_actor == null || this.Tactical.isActive())
        {
            return false;
        }

        local head = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Head);
        local body = _actor.getItems().getItemAtSlot(this.Const.ItemSlot.Body);
        local target = null;
        if (head != null && head.getConditionMax() > 0 && head.getCondition() < head.getConditionMax())
        {
            target = head;
        }

        if (body != null && body.getConditionMax() > 0 && body.getCondition() < body.getConditionMax()
            && (target == null || body.getCondition().tofloat() / body.getConditionMax() < target.getCondition().tofloat() / target.getConditionMax()))
        {
            target = body;
        }

        if (target == null)
        {
            return false;
        }

        local minimum = ::PotionHelper.conf("ArmorRepairMinPct");
        local maximum = ::Math.max(minimum, ::PotionHelper.conf("ArmorRepairMaxPct"));
        local percent = this.Math.rand(minimum, maximum);
        target.setCondition(this.Math.min(target.getConditionMax(), target.getCondition() + this.Math.ceil(target.getConditionMax() * percent / 100.0)));
        _actor.getItems().updateAppearance();
        return true;
    }
});
