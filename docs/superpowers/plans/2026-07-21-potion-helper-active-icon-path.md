# Potion Helper Active Skill Icon Path Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make health-potion active-skill icons visible in combat and show a grayscale variant when disabled.

**Architecture:** Generate normal colored and grayscale `_sw` PNG variants under `gfx/skills`, matching Battle Brothers' active-skill asset resolver. Point the skill's disabled icon to the `_sw` path, remove the wrongly located `gfx/ui/skills` assets, and verify the release contents.

**Tech Stack:** Battle Brothers Squirrel scripts, PowerShell icon generator, static layout test, and release-build script.

## Global Constraints

- Keep item icons in `gfx/ui/items/consumables`.
- Put active-skill icons only in `gfx/skills`.
- Create normal and `_sw` variants for low, medium, and high tiers.
- Do not change potion balance or sound behavior.

---

### Task 1: Use the correct active-skill asset paths

**Files:**

- Modify: `scripts/skills/actives/potion_helper_drink_skill.nut`
- Modify: `tools/test_potion_helper_layout.ps1`

**Interfaces:**

- Consumes: `setTier( _tier )` receives `low`, `medium`, or `high`.
- Produces: `Icon = "skills/potion_helper_health_<tier>.png"` and `IconDisabled = "skills/potion_helper_health_<tier>_sw.png"`.

- [ ] **Step 1: Write a failing static layout check**

Require `"skills/potion_helper_health_" + this.m.Tier + "_sw.png"` in the active skill.

- [ ] **Step 2: Run the layout test to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: FAIL because the disabled icon currently points to the normal colored path.

- [ ] **Step 3: Set the tier-specific disabled icon path**

Replace `this.m.IconDisabled = this.m.Icon;` with:

```squirrel
this.m.IconDisabled = "skills/potion_helper_health_" + this.m.Tier + "_sw.png";
```

- [ ] **Step 4: Run the layout test to verify it passes that assertion**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: the disabled-icon assertion passes; the test may still fail until Task 2 creates the files.

### Task 2: Generate, package, and verify the six skill icons

**Files:**

- Modify: `tools/create_potion_icons.ps1`
- Modify: `tools/test_potion_helper_layout.ps1`
- Create: `gfx/skills/potion_helper_health_low.png`
- Create: `gfx/skills/potion_helper_health_low_sw.png`
- Create: `gfx/skills/potion_helper_health_medium.png`
- Create: `gfx/skills/potion_helper_health_medium_sw.png`
- Create: `gfx/skills/potion_helper_health_high.png`
- Create: `gfx/skills/potion_helper_health_high_sw.png`
- Delete: `gfx/ui/skills/potion_helper_health_low.png`
- Delete: `gfx/ui/skills/potion_helper_health_medium.png`
- Delete: `gfx/ui/skills/potion_helper_health_high.png`

**Interfaces:**

- Consumes: normal and disabled skill paths from Task 1.
- Produces: six `gfx/skills` PNGs packaged in `release/mod_potion_helper.zip`.

- [ ] **Step 1: Require the six correct icon files in the layout test**

Check all tier names with both suffixes: `potion_helper_health_<tier>.png` and `potion_helper_health_<tier>_sw.png` under `gfx/skills`.

- [ ] **Step 2: Run the layout test to verify it fails**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: FAIL because the files are still in `gfx/ui/skills`.

- [ ] **Step 3: Extend the icon generator**

Write each colored health bitmap to `gfx/skills/potion_helper_health_<tier>.png`. Create a grayscale bitmap using each source pixel's luminance and write it as `gfx/skills/potion_helper_health_<tier>_sw.png`.

- [ ] **Step 4: Generate assets and run the layout test**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\create_potion_icons.ps1; powershell -ExecutionPolicy Bypass -File .\tools\test_potion_helper_layout.ps1`

Expected: all six correct icon files exist and the layout test PASSes.

- [ ] **Step 5: Remove misplaced assets, build, and inspect the ZIP**

Run: `powershell -ExecutionPolicy Bypass -File .\tools\build_release.ps1; tar -tf .\release\mod_potion_helper.zip | Select-String 'gfx/skills/potion_helper_health_'`

Expected: ZIP lists all six `gfx/skills` assets and no `gfx/ui/skills` assets.

- [ ] **Step 6: Commit**

Run: `git add scripts/skills/actives/potion_helper_drink_skill.nut tools/create_potion_icons.ps1 tools/test_potion_helper_layout.ps1 gfx/skills; git rm gfx/ui/skills/potion_helper_health_*.png; git commit -m "fix: package potion active skill icons"`
