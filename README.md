# Potion Helper

Adds health potions for quick-slot tactical use and an out-of-battle armor repair potion.

## Required dependencies

- Modern Hooks
- MSU 1.9.0 or newer

## Defaults

- Low/Medium/High health potions restore 30%/65%/100% maximum hitpoints and cost 35/65/90 crowns.
- High health potions can also cure one temporary injury outside battle using a configurable 25% chance.
- Armor Repair Potion repairs the most damaged equipped helmet or body armor by a random 10–20% of maximum condition, outside battle only.
- All potions appear in every marketplace by default. Stock, price, effect values, scaling, and rarity restrictions are configurable in MSU.

## Compatibility

Legends is intentionally unsupported; Potion Helper logs and disables its hooks when Legends is detected. Potion of Resurrection is not required.

## Known Issue
 **bugs show again** : 
-  the active skill can only be exist 1 potion at a time, cannot have 2 same potion or 2 different potion
- some weird active skill still active after usage, but gone after pressing `esc`

**Fixes** :
- on combat when using the active skill the item now consumed and gone
- the active skill also gone (expected)

**Workaround** : 
 - to use 2 potions, use the first skill showing in the UI menu battle
 - after than go to the menu character pressing (C) or (I) then move the potion to different slot quick bag
