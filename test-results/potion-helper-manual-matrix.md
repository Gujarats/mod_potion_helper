# Potion Helper Manual Test Matrix

| Scenario | Expected result |
|---|---|
| Health potion in battle | Uses the quick-slot skill, restores configured maximum-HP percentage, and is consumed. |
| High potion outside battle | Restores health and may remove one temporary injury. |
| Armor potion outside battle | Repairs only the most damaged equipped helmet or body armor. |
| Armor potion in battle | Cannot be consumed. |
| Marketplace refresh | All four potions appear with configured stock by default. |
| Restrictions | Medium/High availability obeys alchemist and settlement settings. |
