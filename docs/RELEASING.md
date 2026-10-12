# Releases

Run **Release** in GitHub Actions with the next stable version, such as `0.0.6`.
The workflow updates `com.styly.shader-collection.urp/package.json` on `develop`,
commits the change, creates a `v<version>` tag and a draft GitHub Release, and
calls the shared STYLY signing workflow to attach the signed UPM `.tgz`.

Before the first signed release, add `UPM_SERVICE_ACCOUNT_KEY_ID`,
`UPM_SERVICE_ACCOUNT_KEY_SECRET`, and `UPM_ORG_ID` as repository Actions secrets.
The Unity service account must have the organization role
**Package Manager Package Signer**. Merge the OpenUPM metadata change to
`trackingMode: githubRelease` before creating the new version tag. The workflow
checks these settings before it changes the repository.

Wait for all jobs, including **sign-release**, to succeed. Review the release
notes and verify that `com.styly.shader-collection.urp-<version>.tgz` is attached
before publishing the draft. If preparation or signing fails, inspect the
branches, tag, and draft before retrying; do not publish the incomplete release.

This repository releases from `develop` and does not require a `main` branch.
Existing package versions are unchanged. Shared implementation and setup:
[STYLY package signing](https://github.com/styly-dev/STYLY-NetSync/blob/develop/docs/PACKAGE_SIGNING.md).
