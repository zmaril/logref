---
message: "could not set libxslt security preferences"
slug: could-not-set-libxslt-security-preferences
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/contrib/xml2/xslt_proc.c:140"
reproduced: false
---

# `could not set libxslt security preferences`

## What it means

The `xml2` extension could not apply its libxslt security preferences before running a stylesheet. Those preferences restrict what a stylesheet may do — such as reading or writing files — during an XSLT transform.

## When it happens

It fires inside `xslt_process()` from the `xml2` extension when the security-preferences setup on the libxslt transform context fails.

## How to fix

This is an internal failure in the XSLT setup path and does not usually depend on your input. Confirm the `xml2` extension and the libxslt library it links against are a healthy, matched build. Capture the query and the extension version if it recurs.

## Example

*Illustrative* — the XSLT security setup failed.

```text
ERROR:  could not set libxslt security preferences
```

## Related

- [could not set up XML error handler](./could-not-set-up-xml-error-handler.md)
- [could not register XML namespace with name and URI](./could-not-register-xml-namespace-with-name-and-uri.md)
