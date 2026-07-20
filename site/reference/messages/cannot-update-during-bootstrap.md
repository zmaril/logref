---
message: "cannot UPDATE during bootstrap"
slug: cannot-update-during-bootstrap
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeModifyTable.c:2762"
reproduced: false
---

# `cannot UPDATE during bootstrap`

## What it means

An internal guard fired: an `UPDATE` was attempted while the server was in bootstrap mode, the special single-user phase `initdb` uses to build the initial catalogs. Bootstrap supports only inserts into fresh catalogs, so updates are not allowed.

## When it happens

It is reached only during `initdb` or a manual bootstrap run. It reflects a problem in the bootstrap input rather than anything a normal user encounters.

## How to fix

There is no user-level fix in a running server. If it appears during `initdb`, the installation's bootstrap data or the build is at fault; reinstall from a clean, matching source. Report it if it happens with an unmodified release.

## Example

*Illustrative* — an update during bootstrap.

```text
ERROR:  cannot UPDATE during bootstrap
```

## Related

- [cannot update in frozen hashtable](./cannot-update-in-frozen-hashtable.md)
- [cannot update SecondarySnapshot during a parallel operation](./cannot-update-secondarysnapshot-during-a-parallel-operation.md)
