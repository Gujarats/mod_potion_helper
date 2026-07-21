# Potion Helper Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a configurable market potion mod with tactical health potions and an out-of-battle single-piece armor repair potion.

**Architecture:** MSU settings describe tiers, stock, price scaling, and rarity restrictions. A shared item base serves health and armor subclasses; marketplace hooks add stock after vanilla filling.

**Tech Stack:** Squirrel, Modern Hooks, MSU 1.9.0+, PowerShell.

## Global Constraints

- Mod ID `mod_potion_helper`, version `1.0.0`; vanilla, Modern Hooks, MSU only.
- Health defaults: 30%/35 crowns, 65%/65 crowns, 100%/90 crowns.
- Armor defaults: random 10–20% of maximum condition, most damaged equipped helmet/body armor only, 45 crowns.
- Every marketplace receives configured stock by default; rarity restrictions are opt-in.
- Legends detection logs and disables hooks.

---

### Task 1: Scaffold, settings, tests, and packaging

**Files:** Create `mod_config.json`, preload loader, static validator, package script, README, and manual matrix.

- [ ] Write a failing validator requiring `mod_potion_helper`, MSU 1.9.0, health and armor settings, Legends guard, item service, and market service.
- [ ] Run the validator; expect a missing loader failure.
- [ ] Add the loader with all MSU range/Boolean settings and a safe Legends guard.
- [ ] Add a packager that creates `release/mod_potion_helper.zip` from `scripts` and `gfx`.
- [ ] Run the validator/build and commit `chore: scaffold potion helper mod`.

### Task 2: Implement potion items

**Files:** Create `scripts/items/accessory/potion_helper_base_item.nut`, three health subclasses, one armor subclass, and `scripts/mods/potion_helper_service.nut`.

- [ ] Extend validator with failing item contracts for tactical health use, high-tier outside-combat injury chance, tactical armor rejection, and lowest-condition armor selection.
- [ ] Run validator; expect missing item-service failure.
- [ ] Implement health items as usable accessories allowed in bag/quick slots. During battle restore the tier’s configured percentage of the user’s maximum hitpoints; high-tier outside combat may remove one temporary injury using configured chance.
- [ ] Implement armor item as usable only outside tactical state. Compare equipped head and body condition percentages, repair only the lower valid item by a configured random percentage, and consume only after a valid repair.
- [ ] Add dynamic tooltips and base-price calculation using configured level/roster scaling.
- [ ] Validate and commit `feat: add health and armor potion items`.

### Task 3: Implement stock, assets, and documentation

**Files:** Create `scripts/mods/potion_helper_market.nut`, potion icons under `gfx/ui/items/consumables/`, README, and manual matrix.

- [ ] Extend validator with failing market and documentation contracts.
- [ ] Run validator; expect market-service failure.
- [ ] Hook `marketplace_building.onAfterFillStash` to add all configured potions by default. Add an alchemist hook only when rarity settings require it. Respect stock, chance, tier restrictions, settlement size, and vanilla building price multiplier.
- [ ] Create four distinct potion icons based on the vanilla potion icon dimensions.
- [ ] Document every setting, the all-market default, armor target rule, and Legends exclusion. Add manual cases for all items, restrictions, price scaling, and save/load.
- [ ] Run validator/build, inspect archive entries, and commit `feat: add potion helper market distribution`.

## Plan Review

- Every item type, economy rule, restriction, compatibility boundary, asset, test, and package output from the approved design is covered.
- The plan uses test-first static contracts and commits each independently testable unit.

