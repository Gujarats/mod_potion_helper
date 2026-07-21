# Potion Helper full-health quick-slot behavior

## Purpose

Prevent accidental consumption of a health potion from the character screen
when its target already has full health.

## Design

The health potion's world-map `onUse` method will return `false` before
restoration when the actor's current hitpoints equal its maximum. The vanilla
character screen interprets that result as a failed use and continues its
normal item-equipping path, placing this bag-slot accessory into the quick
slot. If no bag slot is available, vanilla UI handling leaves it unconsumed.

This does not affect combat usage, healing values, injury removal, armor
potions, prices, or market availability.

## Verification

The static layout test will require the full-health guard. Build the release
ZIP and confirm it contains the updated health potion script.
