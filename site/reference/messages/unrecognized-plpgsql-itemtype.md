---
message: "unrecognized plpgsql itemtype: %d"
slug: unrecognized-plpgsql-itemtype
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1238"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1336"
reproduced: false
---

# `unrecognized plpgsql itemtype: %d`

## What it means

Internal error. The PL/pgSQL executor met a namespace-item type (variable, row, record, and so on) that it does not recognize while resolving a name.

## When it happens

It fires where a compiled PL/pgSQL item's type is switched on and the value is outside the known set. A function that compiled cleanly does not normally reach it.

## How to fix

This is an internal guard in the PL/pgSQL executor. If a real function triggers it, capture the function body and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized PL/pgSQL item type.

```text
ERROR:  unrecognized plpgsql itemtype: 3
```

## Related

- [unrecognized exception condition "%s"](./unrecognized-exception-condition.md)
- [unexpected RAISE parameter list length](./unexpected-raise-parameter-list-length.md)
