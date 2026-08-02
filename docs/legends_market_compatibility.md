# Legends Market Compatibility Plan

## Goal

Make Potion Helper stock its existing health and armor-repair potions in Legends marketplaces and alchemists without changing vanilla behavior.

## Root Cause

Legends replaces `building.fillStash` and does not call vanilla `onAfterFillStash`. Potion Helper's vanilla market hooks therefore cannot run. The previous Legends guard also returned before Potion Helper included any market code.

## Implementation

1. Keep `addStock` and `addMarketStock` as the shared stock logic.
2. Move the existing `onAfterFillStash` registrations into `registerVanillaMarketHooks()`.
3. Load Potion Helper's service and market logic in every game.
4. In non-Legends games, call `registerVanillaMarketHooks()`.
5. In Legends games, load a dedicated compatibility module after `mod_legends`.
6. Hook `building.fillStash`, call the original implementation, then add stock only when `getID()` is `building.marketplace` or `building.alchemist`.
7. Preserve all existing tier restrictions, stock counts, price multipliers, and sorting.

## Verification

Confirm debug output in `C:\Users\gujar\Documents\Battle Brothers\log.html` reports the Legends post-fill injection. Refresh a shop stash or visit a newly generated settlement; existing saved stock is not retroactively changed.
