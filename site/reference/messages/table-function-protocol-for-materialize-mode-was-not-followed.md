---
message: "table-function protocol for materialize mode was not followed"
slug: table-function-protocol-for-materialize-mode-was-not-followed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_E_R_I_E_SRF_PROTOCOL_VIOLATED
    code: "39P02"
call_sites:
  - "postgres/src/backend/executor/execSRF.c:373"
  - "postgres/src/backend/executor/execSRF.c:667"
reproduced: false
---

# `table-function protocol for materialize mode was not followed`

## What it means

A set-returning function running in materialize mode did not follow the required protocol for returning its result — for example it failed to set up the expected tuplestore and result descriptor before returning. The executor cannot collect its rows.

## When it happens

It arises with C or PL functions that return a set in materialize mode (via `SFRM_Materialize`) but mis-implement the contract — a common bug in custom set-returning C functions.

## How to fix

Fix the function to follow the materialize-mode protocol: set `rsinfo->returnMode`, provide a properly built tuplestore and tuple descriptor, and check `allowedModes`. This is a function-implementation fix, typically in a C extension.

## Example

*Illustrative* — a materialize-mode SRF violating the protocol.

```text
ERROR:  table-function protocol for materialize mode was not followed
```

## Related

- [return type of transition function %s is not %s](./return-type-of-transition-function-is-not.md)
- [record type has not been registered](./record-type-has-not-been-registered.md)
