---
message: "sort key generation failed: %s"
slug: sort-key-generation-failed
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:861"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:1166"
reproduced: false
---

# `sort key generation failed: %s`

## What it means

Internal error. Building the sort key for a value failed. The placeholder carries the underlying reason. Sort-key generation turns a value into the comparable form a sort uses; a failure here aborts the sort.

## When it happens

It fires from sort setup — for example when a collation-aware or abbreviated-key routine cannot produce a key, sometimes because of an underlying ICU/collation error carried in the detail.

## How to fix

This is an internal guard; read the attached reason. If it stems from a collation problem, check the collation/ICU health for the involved columns; otherwise capture the query and report it.

## Example

*Illustrative* — a sort-key routine reporting failure.

```text
ERROR:  sort key generation failed: could not convert string
```

## Related

- [unexpected end of tape](./unexpected-end-of-tape.md)
- [retrieved too many tuples in a bounded sort](./retrieved-too-many-tuples-in-a-bounded-sort.md)
