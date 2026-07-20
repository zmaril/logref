---
message: "unrecognized table-function returnMode: %d"
slug: unrecognized-table-function-returnmode
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_SRF_PROTOCOL_VIOLATED
    code: "39P02"
call_sites:
  - "postgres/src/backend/executor/execSRF.c:380"
  - "postgres/src/backend/executor/execSRF.c:685"
reproduced: false
---

# `unrecognized table-function returnMode: %d`

## What it means

Internal error, or a misbehaving set-returning function. The executor met a return-mode value from a table function that is neither the materialize nor value-per-call mode.

## When it happens

It fires where a set-returning function's declared return mode is switched on and the value is outside the known set — usually a C function that filled its return context incorrectly.

## How to fix

This is a protocol guard for set-returning functions. If a custom SRF triggers it, fix the function to set a valid `returnMode`; if only built-in functions are involved, capture the query and report it.

## Example

*Illustrative* — an invalid SRF return mode.

```text
ERROR:  unrecognized table-function returnMode: 3
```

## Related

- [unrecognized strategy: %d](./unrecognized-strategy.md)
- [wrong result type supplied in RETURN NEXT](./wrong-result-type-supplied-in-return-next-c25cc9.md)
