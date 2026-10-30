# God's Eye View investigation evals

An eval set for an investigation agent built on the [God's Eye View](https://github.com/bilawalsidhu/gods-eye-view) MCP server. The questions are about real events from late 2025 to October 2026.

## Why the set looks like this
Most of the app's tools are live or short-window: earthquakes cover 24 hours, launches 30 days, and vessel and aircraft tracks are recent only. So a question about a past event is mostly a test of whether the agent:
- uses the layers that don't change over time (cables, dams, datacenters, military sites, terrain) for context,
- says plainly what it cannot see, and
- does not invent history.

Each item is tagged with an answerability class:

| Class | Meaning | Items |
|---|---|---|
| A_LIVE | Answerable now; ground truth is an independent fetch at run time | 5 |
| B_STATIC | Past event, answered with layers that don't change over time | 4 |
| B_STATIC+C_ARCHIVE | Static context, but the event data needs an archive tool the app lacks | 3 |
| C_ARCHIVE | Needs history the tools don't have; correct answer says so | 1 |
| D_BUILTIN | Event has a dedicated tool (`get_bhote_koshi_flood`) | 1 |
| E_OUT_OF_SCOPE | Must be declined | 1 |
| F_FALSE_PREMISE | Must reject the premise | 1 |

When Phase 2 adds history tools, the C items should move to answerable, and their `ground_truth` already gives the targets.

## Files
- `evals.jsonl`: 16 items. Fields: `question`, `event`, `ground_truth` (with `status`), `expected_tools`, `must_do`, `must_not`, `failure_modes_probed`, `sources`.
- `RUBRIC.md`: 8 dimensions scored 0–2, a gate on Hard failures, grading procedure and pass bar.
- `FAILURE_MODES.md`: 15 failure-mode codes with severity.

## Ground-truth status
- `verified_core`: the facts listed come from the cited sources.
- `partial`: some facts are explicitly unverified; check before grading.
- `live_at_run_time`: graded against an independent fetch.
- `policy`: graded against the project's scope rules.

Figures marked "reported" or "single source" are intentionally kept that way. The agent is scored on keeping them that way too.

## Gaps to fill next
- FM-09 (simulated traffic) has no item yet.
- No event yet exercises the transit, CCTV or radio layers.
- Isaias landfall and the Red Sea July 2026 cable names need checking against a primary source.
