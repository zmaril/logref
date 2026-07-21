---
message: "wrong number of hash keys: %d"
slug: wrong-number-of-hash-keys
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/cache/catcache.c:385"
  - "postgres/src/backend/utils/cache/catcache.c:440"
reproduced: false
---

# `wrong number of hash keys: %d`

## What it means

Internal error. Hash-join or hashed-subplan execution found the number of hash keys it was given does not match what the plan expected.

## When it happens

It fires as a consistency check when the hash-key list and the plan's expectation disagree. Ordinary queries do not produce it.

## How to fix

This is an internal consistency guard. If a real query triggers it, capture the query and report it as a reproducible planner bug.

## Example

*Illustrative* — a hash-key count mismatch.

```text
FATAL:  wrong number of hash keys: 3
```

## Related

- [wrong number of tlist entries](./wrong-number-of-tlist-entries.md)
- [wrong number of output columns in WITH](./wrong-number-of-output-columns-in-with.md)
