# Skills Architecture Guide

## Overview

This document explains the correct architecture for Claude Code skills in this project. **Skills are self-contained bundles** that package documentation, implementation code, detailed references, and templates together.

## Why Self-Contained Skills?

Traditional software projects separate documentation from code (e.g., `docs/` and `src/`). Claude Code skills work differently:

1. **Progressive Disclosure**: Claude reads skill frontmatter → full SKILL.md → references only when needed
2. **Context Efficiency**: Scripts execute without loading source code into context
3. **Discoverability**: Claude scans skill descriptions to find relevant capabilities
4. **Portability**: Skills can be shared/reused as complete packages

## Standard Skill Structure

Every skill follows this four-directory pattern:

```
skill-name/
├── SKILL.md              # Required: Entry point with workflow instructions
├── scripts/              # Optional: Executable implementation code
├── references/           # Optional: Detailed documentation (loaded on-demand)
└── assets/               # Optional: Templates and output resources
```

### SKILL.md (Required)

The entry point for every skill with this exact format:

```yaml
---
name: skill-name
description: Brief description under 125 characters that triggers skill activation
---

## Overview
[Main instructions and workflow steps]

## How to Use This Skill
[Procedural steps for Claude to follow]

## Scripts
- **`scripts/main.py`** - Description of what it does
- **`scripts/helper.py`** - Description

Run manually:
```bash
cd .claude/skills/skill-name
python scripts/main.py --arg value
```

## References
- [Detailed Documentation](./references/detailed-guide.md)
- [Examples](./references/examples.md)

## Integration with Workflow
This skill is part of the larger pipeline...
```

**Key Requirements:**
- Keep SKILL.md **under 500 lines** for optimal performance
- The `description` field (frontmatter) is the primary activation trigger
- Use the body for workflow instructions
- Link to detailed docs in `references/` rather than embedding everything

### scripts/ Directory (Optional)

Contains executable code that Claude runs **without loading the source into context**.

```
scripts/
├── main_logic.py         # Primary script
├── helpers.py            # Helper functions
├── api_clients/          # Subdirectory for API wrappers
│   ├── veo3_client.py
│   └── youtube_client.py
└── utils.py              # Utilities
```

**Benefits:**
- Scripts execute and only **output** consumes tokens (not source code)
- Keeps context efficient even with large codebases
- Organize code logically within the skill

**Example Usage in SKILL.md:**
```markdown
This skill executes `scripts/generate_ideas.py` which:
- Fetches trending data
- Analyzes performance history
- Outputs ranked list as JSON
```

### references/ Directory (Optional)

Stores detailed documentation loaded **only when Claude needs it** (progressive disclosure).

```
references/
├── api-reference.md         # Detailed API docs
├── troubleshooting.md       # Common issues
├── examples.md              # Usage examples
└── patterns-catalog.md      # Pattern library
```

**Best Practices:**
- Keep reference structure **one level deep** (avoid deep nesting)
- Link from SKILL.md like: `See [API Reference](./references/api-reference.md)`
- Claude loads these files only when the task requires them

**Example SKILL.md Reference:**
```markdown
## Satisfying Video Patterns

This skill uses proven patterns from [Satisfying Patterns Catalog](./references/patterns-catalog.md), including:
- Symmetrical compositions
- Perfect loops
- Transformation reveals

(Claude will load patterns-catalog.md only if needed)
```

### assets/ Directory (Optional)

Contains files intended for **output**, not for loading into context.

```
assets/
├── templates/
│   ├── script-template.md
│   ├── idea-template.json
│   └── video-metadata.json
├── remotion-templates/       # React components
│   ├── Video.tsx
│   └── Composition.tsx
├── logo.png                  # Brand assets
└── config-examples/          # Example configs
```

**Use Cases:**
- Templates that skills copy and modify
- Boilerplate code for output
- Static resources (images, fonts)
- Configuration examples

**Example:**
A script-writer skill might copy `assets/templates/script-template.md` and fill it with generated content.

## Skills vs. Separate src/ Directory

| Aspect | Skills (Our Approach) | Traditional src/ |
|--------|----------------------|------------------|
| **Organization** | Self-contained bundles | Code separated from docs |
| **Documentation** | SKILL.md + references/ | Separate docs/ directory |
| **Execution** | Scripts run without loading source | Code loaded into context |
| **Discovery** | Claude scans frontmatter descriptions | Manual navigation |
| **Sharing** | Copy entire skill directory | Need to extract dependencies |
| **Context Usage** | Only output consumes tokens | Full code in context |

**When to Use Skills**: Reusable workflows, specialized utilities, autonomous agents

**When to Use src/**: Large codebases meant for manual editing (not applicable to this project)

## This Project's Skills

We have **6 core skills** for the autonomous video generation pipeline:

### 1. idea-generator
- **Purpose**: Generate viral video ideas from trends and analytics
- **Scripts**: `generate_ideas.py`, `trend_analyzer.py`, API clients
- **References**: Satisfying patterns catalog, Indian audience preferences
- **Assets**: Idea output template (JSON)

### 2. script-writer
- **Purpose**: Write optimized scripts with hooks and timing
- **Scripts**: `write_script.py`, `timing_calculator.py`
- **References**: Hook formulas, script examples, pacing guidelines
- **Assets**: Script template (Markdown)

### 3. scene-planner
- **Purpose**: Break scripts into visual scenes with storyboards
- **Scripts**: `plan_scenes.py`, `storyboard_generator.py`
- **References**: Composition guide, transition catalog
- **Assets**: Storyboard template (JSON)

### 4. asset-generator
- **Purpose**: Generate AI assets (video clips, voiceover, music)
- **Scripts**: `generate_assets.py`, API clients (Veo3, DALL-E, ElevenLabs, Soundverse)
- **References**: API documentation, quality guidelines
- **Assets**: SFX library

### 5. video-assembler
- **Purpose**: Assemble video programmatically with Remotion
- **Scripts**: `assemble_video.py`, `remotion_builder.js`, `render_video.py`
- **References**: Remotion guide, effects catalog
- **Assets**: React component templates (Video.tsx, Composition.tsx, etc.)

### 6. youtube-publisher
- **Purpose**: Upload videos to YouTube with optimized metadata
- **Scripts**: `upload_video.py`, `oauth_handler.py`, `metadata_optimizer.py`
- **References**: YouTube API guide, SEO best practices
- **Assets**: Title/description templates

### 7. analytics-collector
- **Purpose**: Collect performance metrics and generate insights
- **Scripts**: `collect_analytics.py`, `analyze_performance.py`, `generate_insights.py`
- **References**: Metrics guide, optimization strategies
- **Assets**: Performance data template

## Example: How a Skill Works

Let's trace the `idea-generator` skill execution:

1. **User triggers**: `claude -p "Generate 10 video ideas"`

2. **Claude scans skills**: Reads frontmatter of all skills in `.claude/skills/`
   ```yaml
   ---
   name: idea-generator
   description: Generates viral video ideas for Indian audience based on trends
   ---
   ```

3. **Activates skill**: Loads full `idea-generator/SKILL.md` into context

4. **Reads workflow**: SKILL.md says "Execute `scripts/generate_ideas.py`"

5. **Runs script**:
   ```bash
   cd .claude/skills/idea-generator
   python scripts/generate_ideas.py --count 10 --theme satisfying
   ```

6. **Script executes**:
   - Fetches trending data
   - Analyzes `data/performance_log.json`
   - Applies patterns from `references/satisfying-patterns.md` (loaded if needed)
   - Outputs JSON to `data/ideas/2026-01-09.json`

7. **Claude reads output**: Only the JSON output consumes context tokens, not the Python source code

8. **Presents to user**: "Generated 10 ideas. Top pick: 'Perfect Synchronized Rangoli Creation'"

## Code Organization Best Practices

### API Clients: Where Do They Go?

**Option 1: Inside the skill that uses them**
```
asset-generator/
├── scripts/
│   ├── generate_assets.py
│   └── api_clients/
│       ├── veo3_client.py
│       ├── dalle_client.py
│       └── elevenlabs_client.py
```

**Option 2: Shared if used by multiple skills**
```
# If multiple skills need YouTube API:
scripts/                    # Project-level shared utilities
└── youtube_client.py       # Imported by multiple skills
```

**Recommendation**: Start with Option 1 (inside skills). Only extract to shared if truly used by 3+ skills.

### Remotion Templates

Remotion templates live in `video-assembler/assets/remotion-templates/`:

```
video-assembler/
└── assets/
    ├── remotion-templates/
    │   ├── Video.tsx
    │   ├── Composition.tsx
    │   ├── TextOverlay.tsx
    │   ├── ZoomEffect.tsx
    │   └── SceneTransition.tsx
    ├── package.json
    └── remotion.config.ts
```

The `video-assembler` skill's scripts will:
1. Read the scene plan from previous skill
2. Generate React components from templates
3. Inject timing, assets, effects
4. Render to MP4

### Dependencies

Each skill can have its own dependencies:

**Python dependencies**: Add to root `requirements.txt` (all skills share Python env)

**Node.js dependencies**:
- `video-assembler/assets/package.json` for Remotion
- Root `package.json` for any global tools (optional)

## Progressive Disclosure in Action

Skills minimize context usage through smart loading:

**Step 1**: Claude reads all skill frontmatter (tiny)
```yaml
---
name: idea-generator
description: Generates viral video ideas...
---
```

**Step 2**: Activates relevant skill → loads SKILL.md (< 500 lines)

**Step 3**: Only if needed, loads references
```markdown
See [Satisfying Patterns](./references/patterns-catalog.md) for details
```

**Step 4**: Executes script → only output loaded (not source)
```bash
python scripts/generate_ideas.py
# Output: JSON with 10 ideas
```

**Result**: Maximum capability with minimal context consumption.

## Migration from src/ to Skills

If you started with a traditional `src/` structure, migrate like this:

**Before (Incorrect)**:
```
src/
├── generators/
│   └── ideation.py
├── api_clients/
│   └── veo3_client.py
└── analytics/
    └── collector.py
```

**After (Correct)**:
```
.claude/skills/
├── idea-generator/
│   └── scripts/
│       ├── generate_ideas.py  # was generators/ideation.py
│       └── api_clients/
│           └── veo3_client.py  # moved here
└── analytics-collector/
    └── scripts/
        └── collect_analytics.py  # was analytics/collector.py
```

## Tips for Writing Skills

1. **Start with SKILL.md**: Write the workflow documentation first
2. **Keep it under 500 lines**: Move details to `references/`
3. **Clear description**: The frontmatter description triggers activation
4. **Link references explicitly**: Use relative links like `./references/guide.md`
5. **Scripts should be runnable**: Test them standalone before integration
6. **One level deep**: Avoid deeply nested reference directories
7. **Self-document scripts**: Add clear comments at top of each script file

## Testing Skills

Test skills in isolation:

```bash
# Test idea-generator
cd .claude/skills/idea-generator
python scripts/generate_ideas.py --count 5 --theme satisfying

# Test script-writer
cd .claude/skills/script-writer
python scripts/write_script.py --idea data/ideas/2026-01-09.json --index 0

# Test with Claude
claude -p "Use the idea-generator skill to create 3 video ideas"
```

## Summary

✅ **DO**:
- Bundle documentation and code together in skill directories
- Keep SKILL.md under 500 lines
- Use `scripts/` for executable code
- Use `references/` for detailed docs (loaded on-demand)
- Use `assets/` for templates and outputs
- Write clear, triggerable descriptions in frontmatter
- Test skills in isolation

❌ **DON'T**:
- Create a separate `src/` directory
- Embed all documentation in SKILL.md (use references)
- Deeply nest reference files
- Load script source into context (execute instead)
- Mix skill-specific code with project-level code
- Forget the YAML frontmatter in SKILL.md

**This architecture makes skills discoverable, efficient, and portable—perfect for autonomous workflows.**

---

For implementation examples, see the skills templates in `MASTER_PLAN.md`.
