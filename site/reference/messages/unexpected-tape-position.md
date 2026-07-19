---
message: "unexpected tape position"
slug: unexpected-tape-position
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/tuplesort.c:1478"
  - "postgres/src/backend/utils/sort/tuplesort.c:1492"
reproduced: false
---

# `unexpected tape position`

## What it means

Internal error. During an external merge sort, the logical-tape machinery found the read or write position of a spilled run at an offset it did not expect.

## When it happens

It fires from the tuplesort/logtape code when a spilled sort run's position bookkeeping is inconsistent — a temp-file problem or an internal fault, not ordinary SQL.

## How to fix

This is an internal consistency guard. Check for temp-file or disk trouble (`temp_tablespaces`, disk errors, out-of-space during the sort); if storage is healthy and it recurs, capture the query and report it.

## Example

*Illustrative* — a sort tape at an unexpected offset.

```text
ERROR:  unexpected tape position
```

## Related

- [unexpected end of tape](./unexpected-end-of-tape.md)
- [unexpected typLen: %d](./unexpected-typlen.md)
