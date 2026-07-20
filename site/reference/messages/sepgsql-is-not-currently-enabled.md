---
message: "sepgsql is not currently enabled"
slug: sepgsql-is-not-currently-enabled
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/sepgsql/label.c:622"
  - "postgres/contrib/sepgsql/label.c:868"
reproduced: false
---

# `sepgsql is not currently enabled`

## What it means

An `sepgsql` operation was requested but the extension is not active in this session or build. The placeholder-free message reports that sepgsql's enforcement is off, so the requested sepgsql action cannot be performed.

## When it happens

It arises when calling sepgsql functionality (such as `SECURITY LABEL FOR selinux`) while sepgsql is not loaded as a shared preload library, or SELinux is not in an enforcing/permitting state it requires.

## How to fix

Enable sepgsql properly: add it to `shared_preload_libraries`, restart the server, and ensure SELinux is configured as sepgsql requires on the host. This is an install/host-configuration step.

## Example

*Illustrative* — using sepgsql while it is disabled.

```text
ERROR:  sepgsql is not currently enabled
```

## Related

- [SELinux: hardwired security policy violation](./selinux-hardwired-security-policy-violation.md)
- [SELinux: failed to get initial security label: %m](./selinux-failed-to-get-initial-security-label.md)
