# Decision Records

One file per record, used in **scale mode**: `ADR-NNN-<slug>.md` for architecture decisions and `TDR-NNN-<slug>.md` for technology decisions.

- Index, entry format, and mode choice: [`.ai/DECISIONS.md`](../../.ai/DECISIONS.md).
- Status lifecycle: `Proposed → Accepted → Superseded | Deprecated`.
- Small projects stay in **simple mode**, with entries inline in `.ai/DECISIONS.md`; create files here only after switching to scale mode.
- Keep IDs stable during migration and record only decisions that were observed, documented, or approved.

This directory is empty while the project remains in simple mode. Keeping it in the repository makes the scale-mode layout explicit for adopters.
