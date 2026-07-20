---
message: "could not create subsidiary Tcl interpreter"
slug: could-not-create-subsidiary-tcl-interpreter
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/tcl/pltcl.c:509"
reproduced: false
---

# `could not create subsidiary Tcl interpreter`

## What it means

PL/Tcl could not create a subsidiary Tcl interpreter, the sandboxed interpreter it uses for the trusted `pltcl` language. This is an internal step of PL/Tcl setup.

## When it happens

It fires while PL/Tcl prepares a trusted interpreter, when the Tcl library fails to create it — usually under memory pressure or a broken Tcl installation.

## How to fix

This is an internal error in the PL/Tcl runtime. Check for backend memory pressure and confirm the Tcl library the server was built against is intact. Report a reproducible case if it recurs.

## Example

*Illustrative* — the subsidiary interpreter failing to initialize.

```text
ERROR:  could not create subsidiary Tcl interpreter
```

## Related

- [could not create dummy Tcl interpreter](./could-not-create-dummy-tcl-interpreter.md)
- [could not create internal procedure](./could-not-create-internal-procedure.md)
