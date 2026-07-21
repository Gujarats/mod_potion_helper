# Potion Helper Design

## Goal

Create `mod_potion_helper`, a vanilla-focused Battle Brothers mod with affordable, single-use health potions for combat and one out-of-battle armor-repair potion.

## Items and Defaults

- Low Health Potion: restores 30% of the target's maximum hitpoints; base price 35 crowns.
- Medium Health Potion: restores 65% of maximum hitpoints; base price 65 crowns.
- High Health Potion: restores 100% of maximum hitpoints; base price 90 crowns. Outside combat only, it has a configurable 25% default chance to remove one temporary injury.
- Armor Repair Potion: outside combat only; repairs exactly one of the target's equipped helmet or body armor—the one with the lowest condition percentage—by a random 10–20% of its maximum condition; base price 45 crowns.

All potions are single-use. Health potions are accessory items that may be equipped in a bag/quick slot and are usable in tactical combat. They restore no injuries in combat. Armor repair cannot be used during tactical combat.

## Availability and Economy

All four potions are added to every marketplace by default, regardless of settlement size or whether it has an alchemist. Default stock is one item per potion tier on a successful stock roll. The user can configure each tier's stock, stock chance, and base price.

The user can optionally restrict Medium and High health potions to alchemists and optionally restrict High potions to settlements of size three or above. The default leaves both restrictions disabled.

Price is the item base price multiplied by an optional level-and-roster scaling factor. The factor is based on the highest non-guest player level and the number of non-guest brothers. The existing marketplace price multiplier remains in effect, so settlement situations and vanilla reputation discounts work naturally; no custom discount system is added.

## Architecture

The preload loader registers with Modern Hooks, requires MSU 1.9.0+, exposes settings, and includes the item, market, and utility services.

A shared potion-item base owns tooltip, price, and use helpers. Three health item subclasses use the same base with tier data. The armor item derives from the same base but rejects tactical use and chooses the lowest-condition eligible armor item. Market hooks add configured stock to `marketplace_building` and, when enabled by restrictions, `alchemist_building`.

## Compatibility

The first release supports vanilla Battle Brothers, Modern Hooks, and MSU. It does not require or support Legends. It will log and disable itself when Legends is detected. It must not depend on Potion of Resurrection, but will document that both can be installed.

## Verification

Static PowerShell validation checks loader identity/dependencies/settings, item contracts, tactical/out-of-combat restrictions, armor target selection, marketplace hooks, and archive contents. Manual tests cover each potion tier, combat restriction, temporary-injury chance, stock restrictions, price scaling, and save/load.

