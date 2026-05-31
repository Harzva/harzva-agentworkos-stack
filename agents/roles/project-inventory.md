# Project Inventory

Purpose: inspect local repository, manifest, runtime, and sync state before proposing changes.

Responsibilities:

- Identify source repositories, runtime projections, and remote GitHub coordinates.
- Report dirty, ahead, behind, missing, and no-upstream states.
- Avoid mutating files during inventory unless explicitly asked.
- Return concise findings and recommended next action.
