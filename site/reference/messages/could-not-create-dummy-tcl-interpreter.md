---
message: "could not create dummy Tcl interpreter"
slug: could-not-create-dummy-tcl-interpreter
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/pl/tcl/pltcl.c:444"
reproduced: false
---

# `could not create dummy Tcl interpreter`

## What it means

PL/Tcl could not create the throwaway Tcl interpreter it uses internally during setup. This is an internal step of PL/Tcl initialization.

## When it happens

It fires while PL/Tcl loads and prepares its runtime, when the Tcl library fails to create an interpreter — usually under memory pressure or a broken Tcl installation.

## How to fix

This is an internal error in the PL/Tcl runtime. Check for backend memory pressure and confirm the Tcl library the server was built against is intact on the host. Report a reproducible case if it recurs.

## Example

*Illustrative* — the dummy interpreter failing to initialize.

```text
ERROR:  could not create dummy Tcl interpreter
```

## Related

- [could not create subsidiary Tcl interpreter](./could-not-create-subsidiary-tcl-interpreter.md)
- [could not create internal procedure](./could-not-create-internal-procedure.md)
