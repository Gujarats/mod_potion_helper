# Potion Helper Usability and Combat Feedback Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make health potions usable outside combat and make their combat skill show its matching potion icon and play a drink sound.

**Architecture:** Health-potion items retain their accessory and bag-slot behavior, with the missing usable-item flags added. The existing active skill receives the tier and selects a corresponding UI icon, and it uses the vanilla drink sound list. The icon-generation tool writes the same tier-colored artwork to both item and skill UI folders.

**Tech Stack:** Battle Brothers Squirrel scripts, PowerShell asset generator, existing layout and release-build scripts.

## Global Constraints

- Health potion balance, market availability, and armor-potion behavior must not change.
- Health potions remain unusable from the world-map menu during tactical combat.
- Skill icons must be low=green, medium=orange, high=red, matching item icons.
- Sound uses the existing `sounds/combat/drink_01.wav` through `drink_03.wav` assets.

---

### Task 1: Add health-potion usability and combat feedback

**Files:**

- Modify: `scripts/items/accessory/potion_helper_health_item.nut`
- Modify: `scripts/skills/actives/potion_helper_drink_skill.nut`
- Modify: `tools/test_potion_helper_layout.ps1`

**Interfaces:**

- Consumes: `potion_helper_health_item.onEquip()` calling `skill.setTier(this.m.Tier)`.
- Produces: a usable health item and a tier-configured active skill.

- [ ] **Step 1: Write a failing static layout check**

Require the health item to contain `this.m.ItemType = this.Const.Items.ItemType.Usable;` and `this.m.IsUsable = true;`. Require the skill to contain `"skills/potion_helper_health_" + this.m.Tier + ".png"` and `"sounds/combat/drink_01.wav"`.

- [ ] **Step 2: Run the layout test to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: FAIL because the health potion lacks usable flags and the active skill lacks icon and sound configuration.

- [ ] **Step 3: Write the minimal implementation**

Add the usable flags to `potion_helper_health_item.create()`. In `potion_helper_drink_skill.create()`, set `SoundOnUse` to the three vanilla drink sounds. In `setTier( _tier )`, assign `Tier`, `Icon`, `IconDisabled`, and `Overlay` from the selected tier.

- [ ] **Step 4: Run the layout test to verify it passes**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: PASS.

- [ ] **Step 5: Commit**

Run: `git add scripts/items/accessory/potion_helper_health_item.nut scripts/skills/actives/potion_helper_drink_skill.nut tools/test_potion_helper_layout.ps1; git commit -m "feat: make health potions usable"`

### Task 2: Generate matching active-skill artwork and build the release

**Files:**

- Modify: `tools/create_potion_icons.ps1`
- Create: `gfx/ui/skills/potion_helper_health_low.png`
- Create: `gfx/ui/skills/potion_helper_health_medium.png`
- Create: `gfx/ui/skills/potion_helper_health_high.png`
- Create: `release/mod_potion_helper.zip` (ignored)

**Interfaces:**

- Consumes: `potion_helper_drink_skill.setTier()` icon paths from Task 1.
- Produces: packaged icon assets at `gfx/ui/skills/potion_helper_health_<tier>.png`.

- [ ] **Step 1: Write a failing skill-asset check**

Require `gfx/ui/skills/potion_helper_health_low.png`, `potion_helper_health_medium.png`, and `potion_helper_health_high.png` in the layout test.

- [ ] **Step 2: Run the layout test to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: FAIL because the three skill PNG files do not exist.

- [ ] **Step 3: Extend the icon generator**

For each tier, write the recolored bitmap to both `gfx/ui/items/consumables/potion_helper_health_<tier>.png` and `gfx/ui/skills/potion_helper_health_<tier>.png`.

- [ ] **Step 4: Generate icons and verify the layout**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\create_potion_icons.ps1; powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: three skill PNGs exist and the layout test PASSes.

- [ ] **Step 5: Build and inspect the release ZIP**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\build_release.ps1; tar -tf .\release\mod_potion_helper.zip | Select-String 'gfx/ui/skills/potion_helper_health_'`

Expected: build succeeds and lists the three skill icons.

- [ ] **Step 6: Commit source and artwork**

Run: `git add tools/create_potion_icons.ps1 gfx/ui/skills; git commit -m "feat: add potion skill icons and sounds"`
