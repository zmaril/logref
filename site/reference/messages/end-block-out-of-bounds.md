---
message: "end block out of bounds"
slug: end-block-out-of-bounds
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:421"
reproduced: false
---

# `end block out of bounds`

## What it means

`pg_amcheck` was given an ending block number beyond the end of the relation being checked. The requested block does not exist in the target.

## When it happens

It fires at `pg_amcheck` startup when `--endblock` names a block number larger than the highest block in the relation.

## How to fix

Pass an `--endblock` within the relation's size. Check the table's block count (its size divided by the page size) and keep the end block below it, or omit `--endblock` to check to the end.

## Example

*Illustrative* — an out-of-range end block.

```text
pg_amcheck: error: end block out of bounds
```

## Related

- [end block precedes start block](./end-block-precedes-start-block.md)
- [ending block number must be between 0 and](./ending-block-number-must-be-between-0-and.md)
