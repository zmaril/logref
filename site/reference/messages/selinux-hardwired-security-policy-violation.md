---
message: "SELinux: hardwired security policy violation"
slug: selinux-hardwired-security-policy-violation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/contrib/sepgsql/dml.c:167"
  - "postgres/contrib/sepgsql/dml.c:172"
reproduced: false
---

# `SELinux: hardwired security policy violation`

## What it means

The `sepgsql` extension blocked an operation that its built-in (hardwired) policy always forbids, independent of the loaded SELinux policy. Certain actions are denied unconditionally as a safety backstop.

## When it happens

It arises on a host running `sepgsql` when an operation hits one of these always-denied cases — for example an action sepgsql categorically refuses regardless of the surrounding policy.

## How to fix

The operation is intentionally not allowed under sepgsql. Redesign the action to avoid the forbidden operation; there is no policy tweak that permits a hardwired denial. Consult the sepgsql documentation for which operations are unconditionally blocked.

## Example

*Illustrative* — an operation sepgsql categorically denies.

```text
ERROR:  SELinux: hardwired security policy violation
```

## Related

- [sepgsql is not currently enabled](./sepgsql-is-not-currently-enabled.md)
- [SELinux: invalid security label: "%s"](./selinux-invalid-security-label.md)
