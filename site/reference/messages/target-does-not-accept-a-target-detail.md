---
message: "target \"%s\" does not accept a target detail"
slug: target-does-not-accept-a-target-detail
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/backup/basebackup.c:950"
  - "postgres/src/backend/backup/basebackup_target.c:216"
reproduced: false
---

# `target "%s" does not accept a target detail`

## What it means

A `SECURITY LABEL` (or a similar labeled command) supplied a detail/sub-target to a target provider that does not accept one. The placeholder is the target name. Some label providers take only a plain target, without additional detail.

## When it happens

It arises from `SECURITY LABEL FOR provider ON ... IS ...` where the provider was given an extra detail token it does not support.

## How to fix

Omit the unsupported detail, using the target form the provider accepts. Consult the label provider's documentation for its exact target syntax.

## Example

*Illustrative* — a label provider given an unsupported detail.

```text
ERROR:  target "selinux" does not accept a target detail
```

## Related

- [SELinux: invalid security label: "%s"](./selinux-invalid-security-label.md)
- [storage "%s" not recognized](./storage-not-recognized.md)
