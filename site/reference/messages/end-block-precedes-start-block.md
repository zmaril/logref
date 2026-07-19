---
message: "end block precedes start block"
slug: end-block-precedes-start-block
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:453"
reproduced: false
---

# `end block precedes start block`

## What it means

`pg_amcheck` was given an ending block number lower than the starting block number. The block range is empty or reversed.

## When it happens

It fires at `pg_amcheck` startup when `--endblock` is less than `--startblock`.

## How to fix

Set `--startblock` less than or equal to `--endblock`. Swap the two values if they are reversed.

## Example

*Illustrative* — a reversed block range.

```text
pg_amcheck: error: end block precedes start block
```

## Related

- [end block out of bounds](./end-block-out-of-bounds.md)
- [ending block number must be between 0 and](./ending-block-number-must-be-between-0-and.md)
