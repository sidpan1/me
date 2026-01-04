# OpenProse: AI Agent Orchestration Language
**v0.3.1 (Beta) | MIT License | github.com/openprose/prose**

---

## What It Is

OpenProse is a programming language for orchestrating multi-agent AI workflows. Unlike traditional frameworks (LangChain, CrewAI) that run **outside** the AI, OpenProse runs **inside** the AI session itself—treating the AI as a Turing-complete execution environment.

**Core Insight:** *An AI session is a computer. OpenProse is the language it executes.*

---

## The Paradigm Shift: Intelligent Inversion of Control

**Traditional Orchestration (External)**
```python
# LangChain/CrewAI: You control the AI
orchestrator = SequentialChain([Agent1, Agent2])
orchestrator.run()
```

**OpenProse (Internal)**
```prose
# The AI executes your program
let research = session: researcher
let analysis = session: analyst
  context: research
```

The AI session **is** the IoC container—it spawns subagents, manages context, and makes intelligent decisions.

---

## Core Mental Models

### 1. The AI Session as a Computer
| Component | OpenProse Equivalent |
|-----------|---------------------|
| CPU | AI reasoning & tool execution |
| RAM | Conversation history |
| I/O | Task tool (spawn subagents) |
| Instruction Pointer | Emoji narration markers |
| Variables | Session output bindings |

### 2. The Fourth Wall: `**...**` Discretion Markers
Semantic conditions instead of boolean logic:
```prose
loop until **the code is bug-free** (max: 10):
  session "Fix bugs"

if **user seems frustrated**:
  session "Apologize and help"

choice **best deployment strategy**:
  option "Blue-green": ...
  option "Canary": ...
```

The AI interprets these conditions intelligently using conversation context.

### 3. Structured + Intelligent
- **Strict control flow:** Parallel, loops, error handling execute exactly as written
- **Intelligent evaluation:** AI determines when `**conditions**` are met
- **Best of both:** Predictability of code + flexibility of natural language

---

## Key Language Constructs

### Sessions (The Primitive)
```prose
session "Research quantum computing"        # Direct prompt
session: researcher                         # Agent reference
session: researcher
  prompt: "Focus on entanglement"
  model: opus                               # Override model
  context: previous_result                  # Pass data
  retry: 3                                  # Auto-retry
  backoff: "exponential"                    # Retry strategy
```

### Agents (Reusable Templates)
```prose
agent researcher:
  model: sonnet | opus | haiku
  prompt: "You are a research assistant"
  skills: ["web-search", "data-analysis"]
  permissions:
    read: ["docs/**/*.md"]
    write: ["output/"]
    bash: deny
```

### Variables & Context
```prose
let x = session "..."        # Mutable
const y = session "..."      # Immutable

# Context passing forms
context: var                 # Single
context: [a, b, c]          # Array
context: { a, b, c }        # Object
context: []                 # Fresh start
```

### Parallel Execution
```prose
parallel:                              # Wait for all
  a = session "Task A"
  b = session "Task B"

parallel ("first"):                    # Race
parallel ("any", count: 2):           # First N successes
parallel (on-fail: "continue"):       # Wait despite errors
```

### Loops
```prose
# Fixed iterations
repeat 5 as i:
  session "Process {i}"

for item in items:
  session "Process"
    context: item

parallel for item in items:           # Parallel fan-out
  session "Process concurrently"

# AI-evaluated (unbounded)
loop until **draft is publication-ready** (max: 10):
  draft = session "Improve"
    context: draft
```

### Pipelines
```prose
let results = items
  | filter: session "Is valid?"
  | pmap: session "Process in parallel"
  | reduce(acc, x): session "Merge"
```

### Error Handling
```prose
try:
  session "Risky operation"
    retry: 3
    backoff: "exponential"
catch as err:
  session "Handle error"
    context: err
finally:
  session "Cleanup"
```

### Conditionals
```prose
if **user has admin privileges**:
  session "Grant admin access"
elif **user has editor role**:
  session "Grant edit access"
else:
  session "Read-only access"

choice **best approach for user's skill level**:
  option "Beginner": session "Tutorial"
  option "Advanced": session "API docs"
```

---

## How It Works: The OpenProse VM

**Execution Model:**
1. AI reads `.prose` program
2. Parses structure & collects definitions
3. **Embodies the VM** (conversation = state)
4. Executes statements via Tool calls (spawn subagents)
5. Narrates progress with emoji markers (📋📍✅🔀🔄)
6. Returns final result

**Two State Modes:**
- **In-Context** (default): State in conversation history
- **File-Based** (beta): Persists to `.prose/execution/` for resumability

**Context Auto-Summarization:**
- < 2000 chars: Pass verbatim
- 2000-8000 chars: Summarize key points
- \> 8000 chars: Extract essentials

---

## Example: Research Pipeline

```prose
# Define specialized agents
agent researcher:
  model: sonnet
  skills: ["web-search"]

agent writer:
  model: opus

# Parallel research from multiple angles
parallel:
  market = session: researcher
    prompt: "Market trends"
  tech = session: researcher
    prompt: "Technical landscape"
  competition = session: researcher
    prompt: "Competitor analysis"

# Synthesize with all context
let draft = session: writer
  prompt: "Write comprehensive analysis"
  context: { market, tech, competition }

# Iteratively refine
loop until **report is publication-ready** (max: 5):
  draft = session: writer
    prompt: "Review and improve"
    context: draft

# Quality gate
if **meets all standards**:
  session "Deploy to website"
else:
  session "Flag for manual review"
```

---

## Integration: Claude Code Plugin

**Installation:**
```bash
/plugin marketplace add git@github.com:openprose/prose.git
/plugin install open-prose@prose
```

**Three Commands:**
- `/prose-boot` - Interactive onboarding
- `/prose-run <file>` - Execute program
- `/prose-compile <file>` - Validate & compile

**Under the Hood:**
Sessions spawn via Claude Code's `Task` tool:
```typescript
Task({
  prompt: "session prompt",
  subagent_type: "general-purpose",
  model: "sonnet"
})
```

---

## Key Features Summary

| Feature | Syntax |
|---------|--------|
| Comments | `# comment` |
| Strings | `"text"` or `"""multi-line"""` |
| Interpolation | `"Hello {name}"` |
| Agents | `agent name: model: sonnet ...` |
| Sessions | `session "prompt"` or `session: agent` |
| Variables | `let x = ...` / `const y = ...` |
| Parallel | `parallel: a = ... b = ...` |
| Join strategies | `parallel ("first")` / `("any", count: N)` |
| Loops (fixed) | `repeat N:` / `for x in xs:` |
| Loops (unbounded) | `loop until **condition** (max: N):` |
| Pipelines | `items \| map: ... \| filter: ...` |
| Error handling | `try: ... catch as err: ... finally: ...` |
| Conditionals | `if **condition**: ...` |
| Choice | `choice **criteria**: option "A": ...` |
| Imports | `import "skill" from "github:..."` |

---

## Use Cases

**Code Review Workflow**
```prose
parallel:
  security = session "Security review"
  performance = session "Performance review"
  style = session "Style review"

session "Consolidate feedback"
  context: { security, performance, style }
```

**Iterative Content Creation**
```prose
let article = session "Write first draft"

loop until **article meets publication standards** (max: 5):
  article = session "Improve article"
    context: article
```

**Resilient API Integration**
```prose
try:
  session "Call API"
    retry: 3
    backoff: "exponential"
catch:
  session "Use cached fallback"
```

**Multi-Perspective Research**
```prose
parallel for source in sources:
  session "Research from {source} perspective"
    context: source

let synthesis = session "Synthesize all perspectives"
```

---

## Why OpenProse?

**vs. LangChain/CrewAI:**
- ✅ No Python runtime needed
- ✅ Runs anywhere (AI-agnostic)
- ✅ Zero dependencies
- ✅ Plain text files (version control friendly)
- ✅ Reads like pseudocode

**vs. AutoGPT/BabyAGI:**
- ✅ Full control over execution flow
- ✅ Predictable behavior
- ✅ Clear debugging via narration
- ✅ Known workflows, not emergent behavior

**Design Principles:**
- **Pattern over Framework:** Minimal, composable primitives
- **Self-Evident:** Understandable without docs
- **AI-Native:** Designed for intelligent execution
- **Zero Lock-In:** Open standard, portable
- **Framework-Agnostic:** Works with Claude Code, OpenCode, Codex, Amp

---

## Best Practices

**✓ DO:**
- Parallelize independent tasks
- Set `max:` on unbounded loops
- Use appropriate models (haiku for simple, opus for complex)
- Pass minimal context (auto-summarizes if too large)
- Handle expected errors with try/catch

**✗ DON'T:**
- Run sequential when parallel would work
- Use opus for trivial tasks (expensive)
- Forget max limits on unbounded loops
- Pass excessive context (forces summarization)
- Leave errors unhandled

---

## Advanced Patterns

**Supervisor Pattern:** Workers + validator
**Consensus Pattern:** Multiple agents vote
**MapReduce:** Parallel map → reduce
**Circuit Breaker:** Fail-fast after N failures
**Retry Escalation:** Upgrade model on retries

---

## Getting Started

1. **Install:** `/plugin install open-prose@prose` in Claude Code
2. **Onboard:** `/prose-boot`
3. **Try Examples:** `/prose-run examples/01-hello-world.prose`
4. **Learn:** Read `docs.md` (syntax) & `prose.md` (semantics)
5. **Build:** Write your first workflow

---

## Limitations & Future

**Current Limitations:**
- Beta software (syntax may evolve)
- No traditional functions with return values
- No static type system
- Single-file programs (no module system yet)
- Requires Claude Code or compatible assistant

**Roadmap (Tier 13-14):**
- Custom functions with return values
- Module system for code organization
- Type annotations
- VS Code extension with LSP
- Interactive debugger

---

## Resources

**GitHub:** https://github.com/openprose/prose
**License:** MIT
**Docs:** `docs.md` (syntax), `prose.md` (VM semantics)
**Examples:** 31 programs in `examples/`
**Community:** GitHub Issues & Discussions

---

## The Bottom Line

OpenProse is a **new paradigm** for AI orchestration: structured programs that run inside AI sessions, combining the clarity of code with the intelligence of natural language evaluation.

**Key Innovation:** The `**discretion markers**` let you specify *what* you want (semantically) without rigid *how* (boolean logic).

**Mental Model:** Think of `.prose` files as "sheet music for AI orchestras"—you write the score, the AI conducts the performance.

---

*"A long-running AI session is a Turing-complete computer. OpenProse is a programming language for it."*
