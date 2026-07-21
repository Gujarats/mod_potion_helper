# Potion Helper Full-Health Quick-Slot Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move a health potion into the quick slot instead of consuming it when used outside combat on a fully healed character.

**Architecture:** Add a guard to the health potion's existing world-map `onUse` method. It returns `false` before calling the restoration service when current hitpoints equal maximum, allowing the vanilla character-screen equip flow to place the bag-slot potion in the quick slot.

**Tech Stack:** Battle Brothers Squirrel scripts and the existing PowerShell static layout test and release-build scripts.

## Global Constraints

- Do not change combat use, healing values, injury removal, armor potions, prices, or markets.
- At full health, do not call `PotionHelper.restoreHealth`.
- Rely on the vanilla character screen's `onUse == false` fallback to equip the potion in a bag slot.

---

### Task 1: Guard full-health world-map consumption

**Files:**

- Modify: `scripts/items/accessory/potion_helper_health_item.nut`
- Modify: `tools/test_potion_helper_layout.ps1`

**Interfaces:**

- Consumes: `_actor.getHitpoints()` and `_actor.getHitpointsMax()`.
- Produces: `onUse` returns `false` for a full-health actor and otherwise retains the existing restore-and-consume behavior.

- [ ] **Step 1: Write a failing static layout check**

Require `if (_actor.getHitpoints() >= _actor.getHitpointsMax())` and its `return false;` in the health potion item script.

- [ ] **Step 2: Run the test to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: FAIL because the health potion has no full-health guard.

- [ ] **Step 3: Write the minimal Squirrel guard**

Insert the following immediately after the existing null/tactical guard and before `::PotionHelper.restoreHealth`:

```squirrel
if (_actor.getHitpoints() >= _actor.getHitpointsMax())
{
    return false;
}
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: PASS.

- [ ] **Step 5: Build the release ZIP and inspect the script entry**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\build_release.ps1; tar -tf .\release\mod_potion_helper.zip | Select-String 'scripts/items/accessory/potion_helper_health_item.nut'`

Expected: build succeeds and lists the health potion item script.

- [ ] **Step 6: Commit**

Run: `git add scripts/items/accessory/potion_helper_health_item.nut tools/test_potion_helper_layout.ps1; git commit -m "feat: preserve full health potions"`
