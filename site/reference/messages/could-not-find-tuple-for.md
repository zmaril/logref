---
message: "could not find tuple for %s %u"
slug: could-not-find-tuple-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:4207"
  - "postgres/src/backend/catalog/dependency.c:1295"
reproduced: false
---

# `could not find tuple for %s %u`

## What it means

Internal error. Catalog code looked up a system-catalog tuple by OID (for dependency or privilege processing) and did not find it. The placeholders are the object kind and its OID. Code expected the catalog row to exist because something still references it.

## When it happens

It should not occur through ordinary SQL. Reaching it points to a catalog inconsistency — a referenced object missing from its catalog — often surfacing during dependency tracking or `DROP`/`GRANT` processing.

## How to fix

Treat it as a catalog inconsistency. Capture the command and the object kind and OID, and report it. If a specific object reproduces it, inspect the relevant catalog for the missing OID; an absent row suggests corruption worth restoring from backup.

## Example

*Illustrative* — a catalog tuple missing during dependency work.

```text
ERROR:  could not find tuple for role 16401
```

## Related

- [could not find tuple for amop entry](./could-not-find-tuple-for-amop-entry.md)
- [could not find target tuple](./could-not-find-target-tuple.md)
