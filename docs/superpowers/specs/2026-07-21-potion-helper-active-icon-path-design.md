# Potion Helper active skill icon path

## Purpose

Fix blank health-potion active-skill icons in combat.

## Design

Active skill paths such as `skills/potion_helper_health_low.png` resolve from
`gfx/skills`, not `gfx/ui/skills`. The icon generator will therefore create
the three colored skill icons in `gfx/skills`, plus matching grayscale
`_sw` disabled variants. The active skill will use the colored path normally
and its matching `_sw` path when disabled.

Item icons remain in `gfx/ui/items/consumables`; they use the item UI asset
path convention and are already correct. The misplaced `gfx/ui/skills` files
will be removed from the project because the game never resolves them.

## Verification

The static layout test will assert the six `gfx/skills` icon files and the
skill's normal and disabled icon paths. The release ZIP will be rebuilt and
inspected for the six correct entries.
