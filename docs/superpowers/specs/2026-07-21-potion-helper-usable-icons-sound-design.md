# Potion Helper usability and combat feedback

## Purpose

Make health potions usable from the roster/inventory menu outside combat, while
preserving their existing bag-slot combat skill. Make that combat skill clearly
match the consumed potion and provide audible feedback.

## Design

- Mark every health potion as a usable item, matching the existing armor potion.
  Its `onUse` method remains restricted to non-tactical play; its combat active
  skill remains available when the item is in the bag.
- Generate three UI skill icons from the existing colored health-potion art:
  low green, medium orange, and high red.
- When a health potion installs its active skill, the tier setter selects its
  matching skill icon. The skill plays Battle Brothers' existing random drink
  sound set through `SoundOnUse`.
- No balance settings, prices, healing amounts, armor-repair behavior, or
  market behavior change.

## Verification

- Run the Potion Helper layout test and release build.
- Confirm the ZIP includes both the new `gfx/ui/skills` files and the edited
  scripts.
- In game, confirm health potions can be consumed outside combat and that a
  bagged health potion shows the matching icon and makes a drink sound in
  combat.
