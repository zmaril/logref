---
message: "unsupported object class: %u"
slug: unsupported-object-class
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/dependency.c:1553"
  - "postgres/src/backend/catalog/objectaddress.c:4322"
  - "postgres/src/backend/catalog/objectaddress.c:4948"
  - "postgres/src/backend/catalog/objectaddress.c:6443"
  - "postgres/src/backend/commands/alter.c:101"
  - "postgres/src/backend/commands/alter.c:138"
reproduced: false
---

# `unsupported object class: %u`

## What it means

Internal error. Generic dependency or object-address code switched over the catalog an object belongs to and reached a class it has no handler for. The placeholder is the class OID (a `pg_class`-style catalog OID). Because the supported classes are enumerated, an unknown one means a caller passed an object kind this path does not cover.

## When it happens

It should not occur through normal DDL. Reaching it suggests a bug — frequently in an extension that registers dependencies for a new object kind without teaching every code path about it.

## How to fix

Treat it as an internal bug. If it is tied to a specific extension's objects, suspect that extension. Capture the operation and a stack trace and report it.

## Example

*Illustrative* — emitted internally during dependency processing.

```text
ERROR:  unsupported object class: 1259
```

## Related

- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)
- [could not find tuple for extension](./could-not-find-tuple-for-extension.md)
