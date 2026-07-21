---
message: "extconfig and extcondition arrays do not match"
slug: extconfig-and-extcondition-arrays-do-not-match
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:2992"
  - "postgres/src/backend/commands/extension.c:3006"
  - "postgres/src/backend/commands/extension.c:3205"
  - "postgres/src/backend/commands/extension.c:3217"
reproduced: false
---

# `extconfig and extcondition arrays do not match`

## What it means

Internal error. An extension's configuration-table bookkeeping was inconsistent: the `extconfig` array (the extension's user-data tables) and the `extcondition` array (the dump filter for each) in `pg_extension` have different lengths. They must be parallel arrays of the same size.

## When it happens

It should not occur for correctly-registered extensions. Reaching it points to catalog inconsistency, sometimes from an extension that manipulates its config-table registration incorrectly, or corruption.

## How to fix

Treat it as an internal or extension bug. If it involves a specific extension, its configuration-table setup (`pg_extension_config_dump` calls) may be wrong — report it to the author. Inspect the extension's `pg_extension` row if you need to confirm the mismatch.

## Example

*Illustrative* — emitted internally over an extension's config arrays.

```text
ERROR:  extconfig and extcondition arrays do not match
```

## Related

- [could not find tuple for extension](./could-not-find-tuple-for-extension.md)
- [conkey is not a 1-D smallint array](./conkey-is-not-a-1-d-smallint-array.md)
