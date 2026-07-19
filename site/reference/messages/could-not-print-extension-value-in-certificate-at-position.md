---
message: "could not print extension value in certificate at position %d"
slug: could-not-print-extension-value-in-certificate-at-position
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/sslinfo/sslinfo.c:452"
reproduced: false
---

# `could not print extension value in certificate at position %d`

## What it means

The `sslinfo` extension tried to render a certificate extension field as text and OpenSSL could not print it. The `%d` value is the extension's position. Some certificate extensions have no printable text form in the linked OpenSSL.

## When it happens

It happens when calling `sslinfo` functions that expose certificate extensions, when a particular extension cannot be converted to text — usually an extension type the linked OpenSSL does not know how to print.

## How to fix

This reflects a certificate extension the installed OpenSSL cannot render, not a fault in your query. Query a different extension field, or use a certificate whose extensions OpenSSL can print. Upgrading OpenSSL may add support for the extension type.

## Example

*Illustrative* — an unprintable certificate extension.

```text
ERROR:  could not print extension value in certificate at position 2
```

## Related

- [could not parse salt options](./could-not-parse-salt-options.md)
- [could not print result table](./could-not-print-result-table.md)
