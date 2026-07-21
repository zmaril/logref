---
message: "could not initialize XML library"
slug: could-not-initialize-xml-library
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/xml.c:1221"
reproduced: false
---

# `could not initialize XML library`

## What it means

XML support tried to initialize the underlying `libxml2` library and it reported failure. Postgres sets up `libxml2` before parsing or generating XML values.

## When it happens

It fires the first time a session uses XML functionality, when `libxml2` cannot be initialized — usually a version mismatch or a broken `libxml2` installation the server is linked against.

## How to fix

Confirm the `libxml2` the server was built against is installed and healthy, and that its version matches what the build expects. Repairing or reinstalling `libxml2` resolves it; if it recurs on a matching, working library, capture the log and report it.

## Example

*Illustrative* — libxml2 failed to initialize.

```text
ERROR:  could not initialize XML library
```

## Related

- [could not initialize gmt time zone](./could-not-initialize-gmt-time-zone.md)
- [could not initialize dummy tcl interpreter](./could-not-initialize-dummy-tcl-interpreter.md)
