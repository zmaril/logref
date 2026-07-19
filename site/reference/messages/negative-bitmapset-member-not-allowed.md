---
message: "negative bitmapset member not allowed"
slug: negative-bitmapset-member-not-allowed
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/nodes/bitmapset.c:224"
  - "postgres/src/backend/nodes/bitmapset.c:654"
  - "postgres/src/backend/nodes/bitmapset.c:752"
  - "postgres/src/backend/nodes/bitmapset.c:942"
  - "postgres/src/backend/nodes/bitmapset.c:995"
  - "postgres/src/backend/nodes/bitmapset.c:1159"
reproduced: false
---

# `negative bitmapset member not allowed`

## What it means

Internal error. A `Bitmapset` — Postgres's set-of-small-integers structure used throughout the planner and executor — was asked to add or test a negative member. Bitmapset members are non-negative by definition, so a negative value is a caller bug caught by an assertion-style guard.

## When it happens

It should never occur from SQL. It indicates a bug in code that manipulates bitmapsets (often planner or extension code), or memory corruption.

## How to fix

Treat it as an internal bug. If it is tied to a specific extension or query shape, capture that and a stack trace and report it. It is not caused by anything in your data.

## Example

*Illustrative* — emitted internally by the bitmapset code.

```text
ERROR:  negative bitmapset member not allowed
```

## Related

- [unrecognized RTE kind](./unrecognized-rte-kind.md)
- [unterminated List structure](./unterminated-list-structure.md)
