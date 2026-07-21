---
message: "could not open critical system index %u"
slug: could-not-open-critical-system-index
passthrough: false
api: [ereport]
level: [PANIC]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:4417"
reproduced: false
---

# `could not open critical system index %u`

## What it means

During startup the relation cache tried to open one of the indexes it treats as critical — an index on a core system catalog — and could not. These indexes must be usable before the server can run queries.

## When it happens

It fires at the highest severity during startup, marking data corruption, when a critical system index cannot be opened — usually a damaged or missing index file on a core catalog.

## How to fix

This points at catalog corruption. Start the server in single-user mode with system-index use disabled to rebuild the affected index with `REINDEX`, following the documented recovery procedure, and check the storage underneath for faults. If the damage is broader, restore from a backup.

## Example

*Illustrative* — a core catalog index could not be opened at startup.

```text
PANIC:  could not open critical system index 2662
```

## Related

- [could not overwrite high key in half-dead page](./could-not-overwrite-high-key-in-half-dead-page.md)
- [could not open lock file](./could-not-open-lock-file.md)
