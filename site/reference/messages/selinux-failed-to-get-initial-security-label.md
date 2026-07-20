---
message: "SELinux: failed to get initial security label: %m"
slug: selinux-failed-to-get-initial-security-label
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/contrib/sepgsql/label.c:459"
  - "postgres/contrib/sepgsql/uavc.c:177"
reproduced: false
---

# `SELinux: failed to get initial security label: %m`

## What it means

The `sepgsql` extension could not obtain the initial security label for a new object from SELinux. The placeholder carries the system error. Without a starting label, sepgsql cannot assign the object its security context.

## When it happens

It arises during object creation on a host running `sepgsql` when the SELinux policy's type-transition rules fail to yield a label — usually a policy gap or an SELinux subsystem problem.

## How to fix

Review the SELinux policy for the transitions sepgsql needs, and confirm the SELinux userspace is functioning. This is host-side SELinux administration; consult the sepgsql and SELinux documentation for the required policy.

## Example

*Illustrative* — sepgsql unable to derive an initial label.

```text
ERROR:  SELinux: failed to get initial security label: Operation not permitted
```

## Related

- [SELinux: could not translate security label: %m](./selinux-could-not-translate-security-label.md)
- [sepgsql is not currently enabled](./sepgsql-is-not-currently-enabled.md)
