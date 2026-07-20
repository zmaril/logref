---
message: "SELinux: invalid security label: \"%s\""
slug: selinux-invalid-security-label
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_NAME
    code: "42602"
call_sites:
  - "postgres/contrib/sepgsql/label.c:122"
  - "postgres/contrib/sepgsql/label.c:489"
reproduced: false
---

# `SELinux: invalid security label: "%s"`

## What it means

A security label supplied to `sepgsql` (for example via `SECURITY LABEL`) is not a valid SELinux context. The placeholder is the offending label. SELinux rejected it as malformed or not present in the policy.

## When it happens

It arises from `SECURITY LABEL FOR selinux ON ... IS '...'` with a context string that is syntactically wrong or unknown to the loaded policy.

## How to fix

Use a valid SELinux context that exists in the active policy (check with the SELinux tools on the host). Correct the label's format (`user:role:type:level`) and confirm the type is defined in the policy.

## Example

*Illustrative* — an invalid SELinux label.

```text
ERROR:  SELinux: invalid security label: "not_a_context"
```

## Related

- [SELinux: could not translate security label: %m](./selinux-could-not-translate-security-label.md)
- [SELinux: hardwired security policy violation](./selinux-hardwired-security-policy-violation.md)
