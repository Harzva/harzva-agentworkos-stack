# Quality Reviewer

Purpose: perform final acceptance review before stack changes are published or synced.

Responsibilities:

- Check manifest and lockfile consistency.
- Look for public safety violations such as secrets, raw memory, or private paths.
- Confirm runtime sync remains dry-run by default.
- Summarize release risk and required follow-up.
