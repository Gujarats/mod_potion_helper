::PotionHelper <- {
	ID = "mod_potion_helper",
	Version = "1.1.0",
	Name = "Potion Helper",
	Tiers = {
		low = {
			Pct = "LowHealthPct",
			Price = "LowHealthPrice",
			Stock = "LowHealthStock"
		},
		medium = {
			Pct = "MediumHealthPct",
			Price = "MediumHealthPrice",
			Stock = "MediumHealthStock"
		},
		high = {
			Pct = "HighHealthPct",
			Price = "HighHealthPrice",
			Stock = "HighHealthStock"
		}
	}
};

::include("scripts/mods/potion_helper/compatibility/legends_market_patch");

::PotionHelper.HooksMod <- ::Hooks.register(::PotionHelper.ID, ::PotionHelper.Version, ::PotionHelper.Name);
::PotionHelper.HooksMod.require("mod_msu >= 1.9.0");
::PotionHelper.HooksMod.queue(">mod_msu", ">mod_legends", function() {
	::PotionHelper.Mod <- ::MSU.Class.Mod(::PotionHelper.ID, ::PotionHelper.Version, ::PotionHelper.Name);
	::PotionHelper.configureDebugLogging <- function()
	{
		if ("GuzBluezDebugLogController" in getroottable()
			&& "registerTarget" in ::GuzBluezDebugLogController)
		{
			::GuzBluezDebugLogController.registerTarget(::PotionHelper.ID, ::PotionHelper.Mod);
			return;
		}

		::PotionHelper.Mod.Debug.setFlag("default", ::PotionHelper.Mod.ModSettings.getSetting("DebugLogging").getValue());
	};

    ::PotionHelper.conf <- function(_key) {
		return::PotionHelper.Mod.ModSettings.getSetting(_key).getValue();
	};
	local p = ::PotionHelper.Mod.ModSettings.addPage("General");
	local debugLogging = p.addBooleanSetting("DebugLogging", true, "Debug Logging", "Write Potion Helper debug lines to log.html.");
	debugLogging.addCallback(function( _ )
	{
		::PotionHelper.configureDebugLogging();
	});
	::PotionHelper.configureDebugLogging();
	p.addBooleanSetting("EnablePriceScaling", true, "Enable Price Scaling", "Scale base prices by highest brother level and roster size.");
	p.addBooleanSetting("RestrictMediumToAlchemists", false, "Restrict Medium to Alchemists", "Do not add Medium health potions to ordinary marketplaces.");
	p.addBooleanSetting("RestrictHighToAlchemists", false, "Restrict High to Alchemists", "Do not add High health potions to ordinary marketplaces.");
	p.addBooleanSetting("RestrictHighToLargeSettlements", false, "Restrict High to Large Settlements", "Only add High health potions in settlements of size 3 or larger.");
	p.addRangeSetting("LowHealthPct", 30, 1, 100, 1, "Low Health Restored (%)", "Percentage of maximum hitpoints restored in battle.");
	p.addRangeSetting("MediumHealthPct", 65, 1, 100, 1, "Medium Health Restored (%)", "Percentage of maximum hitpoints restored in battle.");
	p.addRangeSetting("HighHealthPct", 100, 1, 100, 1, "High Health Restored (%)", "Percentage of maximum hitpoints restored in battle.");
	p.addRangeSetting("PotionDrinkAPCost", 3, 0, 20, 1, "Potion Drink AP Cost", "Action points consumed when drinking a health potion in battle.");
	p.addRangeSetting("LowHealthPrice", 35, 0, 1000, 1, "Low Base Price", "Crowns before market modifiers.");
	p.addRangeSetting("MediumHealthPrice", 65, 0, 1000, 1, "Medium Base Price", "Crowns before market modifiers.");
	p.addRangeSetting("HighHealthPrice", 90, 0, 1000, 1, "High Base Price", "Crowns before market modifiers.");
	p.addRangeSetting("LowHealthStock", 1, 0, 10, 1, "Low Stock", "Copies per market refresh.");
	p.addRangeSetting("MediumHealthStock", 1, 0, 10, 1, "Medium Stock", "Copies per market refresh.");
	p.addRangeSetting("HighHealthStock", 1, 0, 10, 1, "High Stock", "Copies per market refresh.");
	p.addRangeSetting("HighInjuryCureChance", 25, 0, 100, 1, "High Injury Cure Chance (%)", "Outside combat chance to cure one temporary injury.");
	p.addRangeSetting("ArmorRepairMinPct", 10, 0, 100, 1, "Armor Repair Minimum (%)", "Minimum repair percentage.");
	p.addRangeSetting("ArmorRepairMaxPct", 20, 0, 100, 1, "Armor Repair Maximum (%)", "Maximum repair percentage.");
	p.addRangeSetting("ArmorRepairPrice", 45, 0, 1000, 1, "Armor Repair Base Price", "Crowns before market modifiers.");
	p.addRangeSetting("ArmorRepairStock", 1, 0, 10, 1, "Armor Repair Stock", "Copies per market refresh.");
    ::include("scripts/mods/potion_helper_service");
    ::include("scripts/mods/potion_helper_market");

	if (::Hooks.hasMod("mod_legends"))
	{
		::PotionHelper.Compatibility.Legends.registerHooks(::PotionHelper.HooksMod);
	}
	else
	{
		::PotionHelper.registerVanillaMarketHooks();
	}
});
