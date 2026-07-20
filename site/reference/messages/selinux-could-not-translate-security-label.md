---
message: "SELinux: could not translate security label: %m"
slug: selinux-could-not-translate-security-label
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/contrib/sepgsql/label.c:590"
  - "postgres/contrib/sepgsql/label.c:628"
reproduced: false
---

# `SELinux: could not translate security label: %m`

## What it means

The `sepgsql` extension asked SELinux to translate a security label (between its raw and human-readable forms) and the SELinux library reported a failure. The placeholder carries the system error. Without a valid translation, the label cannot be processed.

## When it happens

It arises on systems running `sepgsql` when the SELinux userspace (libselinux/policy) cannot translate a label — a misconfigured or missing policy, or an SELinux subsystem problem.

## How to fix

Check the SELinux configuration on the host: ensure the policy is loaded and consistent, the `mcstrans` service (if used) is healthy, and the label format is valid. This is a host/SELinux administration issue, not a SQL one.

## Example

*Illustrative* — SELinux failing to translate a label.

```text
ERROR:  SELinux: could not translate security label: Invalid argument
```

## Related

- [SELinux: failed to get initial security label: %m](./selinux-failed-to-get-initial-security-label.md)
- [SELinux: invalid security label: "%s"](./selinux-invalid-security-label.md)
