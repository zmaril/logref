---
message: "unexpected RAISE parameter list length"
slug: unexpected-raise-parameter-list-length
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3831"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3855"
reproduced: false
---

# `unexpected RAISE parameter list length`

## What it means

Internal error. The PL/pgSQL executor handling a `RAISE` statement found a parameter list whose length does not match the format string's expectations.

## When it happens

It fires when the compiled representation of a `RAISE` and its argument list disagree. A source-level `RAISE` that compiled cleanly does not normally reach it.

## How to fix

This is an internal guard in the PL/pgSQL executor. If a real function triggers it, capture the function body and report it as a reproducible bug.

## Example

*Illustrative* — a mismatched RAISE argument list.

```text
ERROR:  unexpected RAISE parameter list length
```

## Related

- [unrecognized plpgsql itemtype: %d](./unrecognized-plpgsql-itemtype.md)
- [unexpected statement subtype: %d](./unexpected-statement-subtype.md)
