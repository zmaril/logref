---
message: "grantable rights not supported for event triggers"
slug: grantable-rights-not-supported-for-event-triggers
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:285"
  - "postgres/src/backend/catalog/aclchk.c:3046"
reproduced: false
---

# `grantable rights not supported for event triggers`

## What it means

Internal error. A privilege operation tried to compute grantable rights for an event trigger, which does not have grantable privileges. It is a guard in the ACL machinery.

## When it happens

It fires from a privilege path that reached an event trigger, an object type with no `GRANT` support. Ordinary DDL does not surface it; it indicates an internal inconsistency.

## How to fix

Event triggers do not take privileges, so do not attempt to grant on them. If you reached this without such an attempt, capture the steps and report a reproducible case.

## Example

*Illustrative* — grantable rights computed for an event trigger.

```text
ERROR:  grantable rights not supported for event triggers
```

## Related

- [event triggers are not supported for](./event-triggers-are-not-supported-for.md)
- [dependent privileges exist](./dependent-privileges-exist.md)
