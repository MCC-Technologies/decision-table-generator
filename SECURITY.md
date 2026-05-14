# Security Policy

## Supported Versions

| Version | Supported |
|---|---|
| Latest | ✅ |
| Older releases | ❌ |

Only the latest release is actively maintained and will receive security fixes.

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, use GitHub's [private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability) feature for this repository.

Include as much of the following as possible:

- A description of the vulnerability and its potential impact
- Steps to reproduce the issue
- Any suggested fixes or mitigations if you have them

You can expect an initial response within **7 days**. If the vulnerability is confirmed, a fix will be prioritized and a security advisory will be published once resolved.

## Scope

This is a client-side Flutter application with no backend, no authentication, and no network requests beyond package dependencies. The primary security surface areas are:

- Third-party dependencies (`provider`, `path_provider`, `share_plus`)
- File system access on the host device (CSV export)

## Dependency Vulnerabilities

If you have found a vulnerability in one of this project's dependencies rather than in the application code itself, please report it directly to the maintainer of that package. You are still welcome to open a private advisory here if you believe it affects this project specifically.
