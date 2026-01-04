# OpenProse: In-Depth Research Findings

**Research Date:** January 4, 2026
**Project:** OpenProse v0.3.1
**Repository:** https://github.com/openprose/prose
**License:** MIT

---

## Executive Summary

OpenProse is a revolutionary programming language designed for orchestrating AI agent workflows. Unlike traditional orchestration frameworks (LangChain, CrewAI, etc.) that run **outside** the AI session, OpenProse runs **inside** the AI session itself, treating the AI as a Turing-complete execution environment. This paradigm shift—called "Intelligent Inversion of Control"—enables developers to write structured programs with clear control flow while leveraging the AI's intelligence for decision-making through "discretion markers" (`**condition**`).

---

## 1. Core Mental Model

### The Fundamental Insight

**Traditional Orchestration:**
```
Orchestrator (Python/JS)
    └─> Controls AI agents
        └─> AI does task and returns
```

**OpenProse Inversion:**
```
AI Session (the VM itself)
    └─> Executes OpenProse program
        └─> Spawns subagents via Task tool
            └─> Results flow back to VM
```

### Key Conceptual Shifts

1. **The AI Session IS the Computer**: The conversation history is RAM, the AI's reasoning is the CPU, and tool calls are I/O operations.

2. **The Fourth Wall**: The `**...**` syntax lets you "speak" to the VM with semantic conditions instead of boolean expressions:
   ```prose
   loop until **the code passes all tests**:
     session "Fix bugs"
   ```

3. **Structured Chaos**: Combines strict control flow (parallel, loops, error handling) with intelligent evaluation (AI determines "done", "best option", "meets criteria").

4. **Agent-as-Template**: Agents are reusable configurations, not running processes. Each `session: agentName` spawns a fresh instance.

5. **Context as Currency**: Session outputs become variables that flow through the program, automatically summarized when too large.

---

## 2. Language Constructs Deep Dive

### 2.1 Sessions: The Primitive Operation

Every non-trivial operation in OpenProse is a **session**—a spawned subagent via the Task tool.

**Four Forms:**

```prose
# 1. Direct prompt (anonymous agent)
session "Research quantum computing"

# 2. Agent reference (uses agent's configuration)
session: researcher

# 3. Agent with prompt override
session: researcher
  prompt: "Focus on quantum entanglement"

# 4. Full configuration
session: researcher
  prompt: "..."
  model: opus              # Override agent's model
  context: [var1, var2]    # Pass data
  retry: 3                 # Auto-retry on failure
  backoff: "exponential"   # 1s, 2s, 4s delays
```

**Mental Model:** Think of sessions as function calls that execute in a separate process and return a value.

---

### 2.2 Agents: Reusable Configurations

Agents are **templates** for session configuration, not running instances.

```prose
agent researcher:
  model: sonnet              # Default model (haiku|sonnet|opus)
  prompt: "You are a researcher..."  # System/role prompt
  skills: ["web-search", "data-analysis"]  # External capabilities
  permissions:
    read: ["docs/**/*.md"]   # File read access
    write: ["output/"]       # File write access
    bash: deny               # Disable shell access
    network: allow           # Enable network tools
```

**Key Insight:** Every `session: researcher` creates a **new instance** with this configuration. Agents don't maintain state between sessions unless you explicitly pass context.

---

### 2.3 Variables: Data Flow Management

OpenProse has two binding types, similar to JavaScript:

```prose
let mutable = session "..."      # Can be reassigned
const immutable = session "..."  # Cannot be reassigned

mutable = session "..."          # OK
immutable = session "..."        # ERROR: E017
```

**Context Passing** (4 forms):

```prose
# 1. Single variable
session "Analyze this"
  context: research

# 2. Array (ordered)
session "Compare these"
  context: [a, b, c]

# 3. Object (named fields)
session "Synthesize"
  context: { market, tech, competition }

# 4. Empty (fresh start)
session "Forget everything"
  context: []
```

**Auto-Summarization:** If context exceeds 2000 chars, the VM intelligently summarizes. If exceeds 8000, extracts essentials only.

---

### 2.4 Parallel Execution: True Concurrency

OpenProse enables genuine parallel execution via multiple simultaneous Task tool calls.

**Basic Parallel:**
```prose
parallel:
  a = session "Task A"
  b = session "Task B"
  c = session "Task C"

# Result: { a, b, c } all available
```

**Join Strategies** (how to wait):

```prose
parallel ("all"):           # Default: wait for all (AND)
parallel ("first"):         # Race: first to complete wins
parallel ("any"):           # First success (ignores failures)
parallel ("any", count: 2): # Wait for N successes
```

**Failure Policies** (what happens on error):

```prose
parallel (on-fail: "fail-fast"):  # Default: cancel all on any failure
parallel (on-fail: "continue"):   # Wait for all, collect errors
parallel (on-fail: "ignore"):     # Treat failures as successes
```

**Mental Model:** Like Promise.all(), Promise.race(), Promise.any() in JavaScript, but for AI agents.

---

### 2.5 Loops: Fixed and Intelligent

**Fixed Loops** (deterministic):

```prose
# Repeat N times
repeat 3:
  session "..."

# With iteration counter
repeat 5 as i:
  session "Process iteration {i}"
    context: i

# For-each loop
for item in items:
  session "Process item"
    context: item

# For-each with index
for item, idx in items:
  session "Item {idx}: process"
    context: [item, idx]

# Parallel for-each (fan-out)
parallel for item in items:
  session "Process concurrently"
    context: item
```

**Unbounded Loops** (AI-evaluated):

```prose
# Until condition is true
loop until **the code is bug-free** (max: 10):
  session "Find and fix bugs"

# While condition remains true
loop while **user requests more features** (max: 5):
  session "Add next feature"

# With iteration variable
loop until **converged** (max: 20) as attempt:
  session "Optimize model (attempt {attempt})"
    context: attempt
```

**The `max:` Parameter:** Prevents infinite loops. VM tracks iterations and stops at max regardless of condition.

**Mental Model:** Fixed loops are like traditional for/while. Unbounded loops are like "repeat until satisfied" with the AI's judgment.

---

### 2.6 Pipelines: Functional Transformations

Borrowed from functional programming paradigms:

```prose
# Map: Transform each item
let processed = items | map:
  session "Transform item"
    context: item

# Filter: Keep only matching items
let valid = items | filter:
  session "Is this valid? Answer yes or no"
    context: item

# Reduce: Accumulate into single value
let summary = items | reduce(accumulator, item):
  session "Merge item into accumulator"
    context: [accumulator, item]

# Parallel Map: Map with concurrency
let results = items | pmap:
  session "Process in parallel"
    context: item

# Chaining
let final = items
  | filter: session "Keep if valid"
  | map: session "Transform"
  | reduce(acc, x): session "Combine"
```

**Mental Model:** Like Array.map(), filter(), reduce() in JavaScript, but each operation is an AI session.

---

### 2.7 Error Handling: Structured Recovery

```prose
try:
  session "Risky API call"
catch as error:
  session "Log and recover"
    context: error
finally:
  session "Cleanup resources"

# Re-raise in catch
catch as err:
  session "Log error"
  throw  # Propagates to outer handler

# Custom errors
throw "Invalid configuration detected"
```

**Retry & Backoff:**
```prose
session "Call flaky API"
  retry: 3
  backoff: "exponential"  # 1s, 2s, 4s
```

**Mental Model:** Like try/catch in traditional languages, but with AI-powered recovery strategies.

---

### 2.8 Conditionals: Intelligent Branching

**If/Elif/Else:**
```prose
if **user has admin privileges**:
  session "Grant admin access"
elif **user has editor role**:
  session "Grant edit access"
else:
  session "Grant read-only access"

# Multi-line conditions
if ***
  The user's request is valid AND
  the system has available capacity AND
  no conflicts exist
***:
  session "Process request"
```

**Choice Blocks** (AI selects best option):
```prose
choice **the most appropriate deployment strategy**:
  option "Blue-green deployment":
    session "Deploy blue-green"
  option "Canary release":
    session "Deploy canary"
  option "Rolling update":
    session "Deploy rolling"
```

**Mental Model:** Conditions are evaluated by AI reasoning, not boolean logic. The VM interprets semantic meaning.

---

### 2.9 Composition: Blocks and Sequences

**Named Reusable Blocks:**
```prose
block review(topic):
  let research = session "Research {topic}"
  let analysis = session "Analyze {topic}"
    context: research
  session "Write review of {topic}"
    context: [research, analysis]

# Invoke block
do review("quantum computing")
do review("AI safety")
```

**Do Blocks** (explicit sequential):
```prose
let result = do:
  session "Step 1"
  session "Step 2"
  session "Step 3"
```

**Arrow Sequences** (inline chaining):
```prose
session "Research"
  -> session "Analyze"
  -> session "Write report"
```

**Mental Model:** Blocks are like functions with parameters. Arrows are like Unix pipes.

---

### 2.10 String Interpolation

```prose
let name = session "Get user name"
let greeting = "Hello {name}!"

session "Welcome message for {name}"

# Multi-line with interpolation
session """
Generate a report for {name}.
Include sections:
- Background: {background}
- Analysis: {analysis}
"""
```

**Mental Model:** Like template literals in JavaScript (`` `${var}` ``) or f-strings in Python.

---

### 2.11 Imports: External Skills

```prose
# From GitHub
import "web-search" from "github:anthropic/skills"

# From npm
import "data-viz" from "npm:@company/tools"

# Local file
import "custom-tool" from "./skills/custom"

agent researcher:
  skills: ["web-search", "data-viz"]
```

**Mental Model:** Like npm/pip packages, but for AI capabilities.

---

## 3. The OpenProse VM: Execution Architecture

### 3.1 You ARE the VM

The most radical aspect: **the AI session embodies the virtual machine**. There's no separate interpreter process.

**VM Components Mapped:**

| Traditional VM | OpenProse VM |
|----------------|--------------|
| CPU | AI's reasoning & tool execution |
| RAM | Conversation history |
| Instruction Pointer | Narration emoji markers |
| Heap | Variable bindings in context |
| I/O | Task tool calls (spawn subagents) |
| Exception Handler | try/catch blocks |
| Call Stack | Nested block execution |

### 3.2 Execution Algorithm

```
1. PARSE the .prose file into AST
2. COLLECT all agent/block definitions (global scope)
3. INITIALIZE execution state (variables, position)
4. FOR each statement in program order:
   a. NARRATE current position (📍 emoji)
   b. EVALUATE statement:
      - session → spawn Task tool
      - parallel → spawn multiple Tasks
      - loop → check condition, iterate
      - if → evaluate condition, branch
      - choice → ask AI to select
      - try/catch → wrap in error handler
      - block call → inline block body
   c. CAPTURE result
   d. UPDATE variables
   e. NARRATE completion (✅ emoji)
5. RETURN final result
```

### 3.3 Narration Protocol

The VM "thinks aloud" using emoji markers to track state:

```
📋 Program Start: analyzing program structure
   Collected 2 agents: [researcher, writer]
   Collected 1 block: [review]

📍 Statement 1: parallel (3 branches)
🔀 Spawning parallel branches...
   [Task tool calls for a, b, c]
🔀 All branches complete
📦 parallel results: { a: "...", b: "...", c: "..." }

📍 Statement 2: let draft = session: writer
   [Task tool call]
✅ Session complete
📦 let draft = "Draft content..."

📍 Statement 3: loop until **publication-ready** (max: 5)
🔄 Iteration 1
   [Task tool call]
✅ Iteration 1 complete
🔄 Condition check: **publication-ready** → false
🔄 Iteration 2
   ...
🔄 Condition check: **publication-ready** → true
🔄 Loop exit: condition satisfied

📋 Program Complete
```

### 3.4 State Management: Two Modes

**Mode 1: In-Context (Default)**
- State lives in conversation history
- Fast, no file I/O
- Conversation reset clears state
- Works for short programs

**Mode 2: File-Based (Beta)**
- State persists to `.prose/execution/run-{timestamp}/`
- Resumable across sessions
- Handles long-running programs
- Structure:
  ```
  .prose/execution/run-20260104-143022-abc123/
  ├── program.prose        # Original program
  ├── position.json        # Current statement
  ├── variables/           # Variable values
  │   ├── draft.md
  │   ├── research.md
  │   └── manifest.json
  ├── parallel/            # Parallel branch results
  ├── loops/               # Loop iteration state
  └── execution.log        # Full trace
  ```

**Trigger:** User phrases like "use file-based state", "enable persistence", "I need to resume later"

---

## 4. Discretion Markers: The Fourth Wall

The `**...**` syntax is OpenProse's most unique feature—it allows semantic conditions instead of boolean logic.

### 4.1 How They Work

**Single-line:**
```prose
if **user seems frustrated**:
  session "Apologize and offer help"
```

**Multi-line:**
```prose
loop until ***
  The code is:
  - Bug-free
  - Well-documented
  - Performance-optimized
*** (max: 10):
  session "Improve code"
```

### 4.2 Evaluation Process

1. **Context Gathering:** VM examines recent session outputs, variable values, conversation history
2. **Semantic Interpretation:** AI determines if condition is satisfied based on natural language understanding
3. **Decision:** Returns true/false (for if/loop) or option index (for choice)
4. **Narration:** Explains decision in emoji-marked narration

**Example:**
```
🔄 Condition check: **the draft meets publication standards**
   Analyzing draft...
   - Grammar: ✓
   - Factual accuracy: ✓
   - Structure: ✗ (needs better transitions)
➡️ Condition: false (continue iterating)
```

### 4.3 Use Cases

**Quality Gates:**
```prose
loop until **the code passes all tests**:
  session "Fix bugs"
```

**User Intent Detection:**
```prose
if **user wants to continue**:
  session "Next feature"
else:
  session "Finalize and deploy"
```

**Best Option Selection:**
```prose
choice **the fastest algorithm for this dataset**:
  option "Quicksort": ...
  option "Mergesort": ...
  option "Heapsort": ...
```

**Convergence Detection:**
```prose
loop until **model has converged** (max: 100):
  session "Training iteration"
```

---

## 5. Integration with Claude Code

### 5.1 Plugin Architecture

OpenProse is a **Claude Code skill**, installed via:

```bash
# Add from marketplace
/plugin marketplace add git@github.com:openprose/prose.git

# Install
/plugin install open-prose@prose

# Restart Claude Code to activate
```

### 5.2 Three Commands

**1. `/prose-boot` - Onboarding**

Entry point: `commands/prose-boot.md`

**New User Flow:**
- Welcome message
- Poll question: "What brings you to OpenProse?"
- 1-3 bridge questions to understand use case
- Generate example `.prose` file
- Offer to run it

**Returning User Flow:**
- Scan for existing `.prose` files
- Assess current stage (beginner/intermediate/advanced)
- Ask tailored question about next goal
- Guide toward reinforcing action

**2. `/prose-run <file>` - Execute Program**

Entry point: `commands/prose-run.md`

**Process:**
1. Read `.prose` file
2. Activate OpenProse VM (load `prose.md` semantics)
3. Parse program
4. Embody VM and execute
5. Return final result

**Example:**
```bash
/prose-run examples/research-pipeline.prose
```

**3. `/prose-compile <file>` - Validate**

Entry point: `commands/prose-compile.md`

**Process:**
1. Read `.prose` file
2. Parse to AST
3. Validate syntax & semantics
4. Check for errors/warnings
5. Output canonical form or error report

**Example:**
```bash
/prose-compile my-program.prose
```

### 5.3 Task Tool Integration

Sessions are executed via Claude Code's **Task tool**:

```typescript
// VM spawns subagent like this:
Task({
  description: "OpenProse session: researcher",
  prompt: "Research quantum computing",
  subagent_type: "general-purpose",
  model: "sonnet"  // or "haiku" / "opus"
})
```

**Parallel Execution:**
```typescript
// Single message with multiple Task calls
Task({ ... })  // Branch A
Task({ ... })  // Branch B
Task({ ... })  // Branch C
```

---

## 6. Design Philosophy & Principles

### 6.1 Core Values

1. **Pattern over Framework:** Minimal primitives that compose powerfully
2. **Self-Evidence:** Code should be understandable without extensive docs
3. **AI-Native:** Designed for intelligent execution, not rigid parsing
4. **Zero Lock-In:** `.prose` files run on any compatible AI assistant
5. **Framework-Agnostic:** Works with Claude Code, OpenCode, Codex, Amp, etc.
6. **Portable:** Programs are plain text, version control friendly

### 6.2 Intelligent Inversion of Control

Traditional orchestrators (LangChain, CrewAI) are **containers** that manage AI agents:

```python
# LangChain style
chain = SequentialChain([
    ResearchAgent(),
    AnalysisAgent(),
    WritingAgent()
])
result = chain.run()
```

OpenProse inverts this: **the AI session is the container**:

```prose
# OpenProse style
let research = session: researcher
let analysis = session: analyst
  context: research
let report = session: writer
  context: [research, analysis]
```

**Why This Matters:**
- **Context-Aware:** The VM has full conversation context
- **Intelligent Decisions:** Can evaluate `**conditions**` semantically
- **No External State:** Everything lives in the session
- **Simpler Deployment:** No Python/JS runtime needed

### 6.3 The Fourth Wall Principle

`**discretion markers**` let you "speak to" the VM directly, bridging natural language and code:

```prose
# Traditional code (rigid)
while quality_score < 0.95 and iterations < 10:
    improve_draft()

# OpenProse (semantic)
loop until **the draft meets publication standards** (max: 10):
    session "Improve draft"
```

This enables:
- **Semantic Conditions:** "meets standards" is subjective but understood
- **Human Intent:** Express what you want, not how to measure it
- **Graceful Uncertainty:** AI handles ambiguity intelligently

---

## 7. Example Programs & Patterns

### 7.1 Simple Sequential Workflow

```prose
# Research → Analyze → Write
let research = session "Research topic X"
let analysis = session "Analyze findings"
  context: research
let report = session "Write report"
  context: [research, analysis]
```

### 7.2 Parallel Research Synthesis

```prose
# Three perspectives in parallel
parallel:
  market = session "Market analysis"
  tech = session "Technical analysis"
  competition = session "Competitive analysis"

# Synthesize all three
let summary = session "Write executive summary"
  context: { market, tech, competition }
```

### 7.3 Iterative Refinement

```prose
let draft = session "Write first draft"

loop until **the draft is publication-ready** (max: 5):
  draft = session "Review and improve"
    context: draft
```

### 7.4 Code Review Workflow

```prose
agent reviewer:
  model: sonnet
  prompt: "You are a code reviewer"

parallel:
  security = session: reviewer
    prompt: "Check for security issues"
  performance = session: reviewer
    prompt: "Check for performance issues"
  style = session: reviewer
    prompt: "Check for style issues"

let consolidated = session "Consolidate reviews"
  context: { security, performance, style }
```

### 7.5 Resilient API Integration

```prose
try:
  let data = session "Call external API"
    retry: 3
    backoff: "exponential"

  session "Process data"
    context: data
catch as error:
  session "Log error to monitoring"
    context: error

  # Fallback strategy
  let fallback = session "Use cached data"
  session "Process fallback"
    context: fallback
finally:
  session "Clean up resources"
```

### 7.6 Multi-Stage Pipeline

```prose
let candidates = session "Find candidates"

let validated = candidates | filter:
  session "Is this valid? yes/no"
    context: item

let processed = validated | pmap:
  session "Process in parallel"
    context: item

let summary = processed | reduce(acc, item):
  session "Merge into summary"
    context: [acc, item]
```

### 7.7 Intelligent Routing

```prose
choice **the best approach for this user's skill level**:
  option "Beginner tutorial":
    session "Generate step-by-step guide"
  option "Intermediate deep-dive":
    session "Generate detailed explanation"
  option "Advanced reference":
    session "Generate API documentation"
```

---

## 8. Language Grammar Reference

### 8.1 Syntax Overview

OpenProse uses **Python-like indentation** for block structure:

```
program      := statement*
statement    := agent_def | session | binding | assignment
             | parallel_block | loop_block | try_block
             | choice_block | if_statement | block_def
             | throw_statement | import_statement | comment

agent_def    := "agent" NAME ":" INDENT property* DEDENT
session      := "session" (STRING | ":" NAME) properties?
binding      := ("let" | "const") NAME "=" expression
assignment   := NAME "=" expression
parallel_block := "parallel" modifiers? ":" INDENT branch* DEDENT
loop_block   := ("repeat" | "for" | "loop") condition ":" INDENT statement* DEDENT
try_block    := "try:" INDENT statement* DEDENT catch_block? finally_block?
```

### 8.2 Comments

```prose
# Single-line comment

let x = session "..."  # Inline comment

# Multi-line comments are just multiple single-line comments
# Like this
# And this
```

### 8.3 Strings

**Single-line:**
```prose
"Simple string"
"String with \"escaped\" quotes"
"String with {variable} interpolation"
```

**Multi-line:**
```prose
"""
Multi-line string
Preserves newlines
Supports {variable} interpolation
"""
```

**Escape sequences:** `\\`, `\"`, `\n`, `\t`, `\{`

### 8.4 Reserved Keywords

```
agent, session, let, const, parallel, repeat, for, loop, until, while,
try, catch, finally, throw, if, elif, else, choice, option, block, do,
map, filter, reduce, pmap, import, from, as, in, context, prompt, model,
retry, backoff, skills, permissions, read, write, bash, network, max,
count, on-fail, true, false, null
```

---

## 9. Error Codes Reference

### 9.1 Errors (Block Execution)

| Code | Description | Example |
|------|-------------|---------|
| E001 | Unterminated string | `session "no closing quote` |
| E002 | Invalid syntax | `sesion "typo"` |
| E003 | Indentation error | Mixed tabs/spaces |
| E004 | Unexpected token | `parallel 123:` |
| E005 | Invalid block structure | Missing colon |
| E006 | Invalid expression | Malformed binding |
| E007 | Undefined agent reference | `session: nonexistent` |
| E008 | Invalid model value | `model: gpt4` |
| E009 | Duplicate property | `model: opus\nmodel: sonnet` |
| E010 | Import not found | `import "missing" from "..."` |
| E011 | Circular import | A imports B imports A |
| E012 | Invalid import source | Bad URL/path |
| E013 | Skill not available | Agent uses unavailable skill |
| E014 | Permission denied | Session violates agent permission |
| E015 | Invalid permission syntax | `read: 123` |
| E016 | Type mismatch | `for x in "string":` |
| E017 | Reassignment to const | `const x = ...\nx = ...` |

### 9.2 Warnings (Non-blocking)

| Code | Description | Impact |
|------|-------------|--------|
| W001 | Empty prompt | Session may not know what to do |
| W002 | Whitespace-only prompt | Same as W001 |
| W003 | Prompt exceeds 10K chars | May hit context limits |
| W004 | Missing agent prompt | Agent has no role guidance |
| W005 | Missing session context | May lack necessary data |
| W006 | Unused variable | Variable never referenced |
| W007 | Shadowed variable | Inner scope hides outer |
| W008 | Unknown skill in import | Skill may not exist |
| W009 | Overly permissive permissions | Security risk |
| W010 | Missing max on unbounded loop | Could run forever |

---

## 10. Performance & Best Practices

### 10.1 Parallelization

**DO:**
```prose
# Parallelize independent tasks
parallel:
  a = session "Task A"
  b = session "Task B"
  c = session "Task C"
```

**DON'T:**
```prose
# Sequential when parallel would work
let a = session "Task A"
let b = session "Task B"
let c = session "Task C"
```

### 10.2 Context Management

**DO:**
```prose
# Pass only what's needed
session "Analyze"
  context: { relevant_data, key_findings }
```

**DON'T:**
```prose
# Pass everything (forces summarization)
session "Analyze"
  context: [var1, var2, var3, var4, var5, ...]
```

### 10.3 Model Selection

**DO:**
```prose
# Use appropriate model for task complexity
agent simple_task:
  model: haiku  # Fast & cheap for simple tasks

agent complex_reasoning:
  model: opus   # Powerful for complex tasks
```

**DON'T:**
```prose
# Use opus for everything (expensive & slow)
agent simple_formatter:
  model: opus   # Overkill
```

### 10.4 Error Handling

**DO:**
```prose
# Handle expected failures gracefully
try:
  session "Call API"
    retry: 3
catch as err:
  session "Use cached data"
```

**DON'T:**
```prose
# Let errors propagate unhandled
session "Call API"  # Might fail, no recovery
```

### 10.5 Loop Bounds

**DO:**
```prose
# Always set max on unbounded loops
loop until **converged** (max: 100):
  session "Iterate"
```

**DON'T:**
```prose
# Unbounded without max (could run forever)
loop until **converged**:
  session "Iterate"
```

---

## 11. Advanced Patterns

### 11.1 Supervisor Pattern

```prose
agent worker:
  model: haiku

agent supervisor:
  model: opus

# Workers do tasks in parallel
parallel:
  result1 = session: worker "Task 1"
  result2 = session: worker "Task 2"
  result3 = session: worker "Task 3"

# Supervisor validates and consolidates
let validated = session: supervisor
  prompt: "Validate and consolidate worker results"
  context: { result1, result2, result3 }
```

### 11.2 Consensus Pattern

```prose
# Multiple agents vote on best approach
parallel:
  vote1 = session: agent1 "What's the best approach?"
  vote2 = session: agent2 "What's the best approach?"
  vote3 = session: agent3 "What's the best approach?"

# Consensus builder
let consensus = session "Determine consensus from votes"
  context: { vote1, vote2, vote3 }

# Execute winning approach
if **consensus is option A**:
  session "Execute option A"
elif **consensus is option B**:
  session "Execute option B"
```

### 11.3 Retry with Escalation

```prose
let success = false
let attempt = 0

loop while **not success** (max: 3) as attempt:
  try:
    if attempt == 0:
      # First try: fast model
      session "Solve problem"
        model: haiku
    elif attempt == 1:
      # Second try: better model
      session "Solve problem"
        model: sonnet
    else:
      # Last resort: best model
      session "Solve problem"
        model: opus

    success = true
  catch:
    success = false
```

### 11.4 MapReduce Pattern

```prose
# Map phase (parallel processing)
let mapped = items | pmap:
  session "Process item"
    context: item

# Shuffle/sort (if needed)
let sorted = mapped | map:
  session "Sort by key"
    context: item

# Reduce phase (aggregate)
let final = sorted | reduce(acc, item):
  session "Aggregate into result"
    context: [acc, item]
```

### 11.5 Circuit Breaker Pattern

```prose
let failures = 0
const max_failures = 3

for request in requests:
  if failures >= max_failures:
    session "Circuit open: failing fast"
    throw "Circuit breaker triggered"

  try:
    session "Process request"
      context: request
    failures = 0  # Reset on success
  catch:
    failures = failures + 1

    if failures >= max_failures:
      session "Circuit breaker opened"
```

---

## 12. Telemetry & Privacy

### 12.1 What is Collected

**Session Events:**
- Boot events (`/prose-boot`)
- Compile events (`/prose-compile`)
- Run events (`/prose-run`)
- Timestamps and duration

**Feature Usage:**
- Parallel blocks executed
- Loop iterations count
- Error handling invocations
- Pipeline operations used

**Error Patterns:**
- Error codes (E001, E002, etc.)
- Warning codes (W001, W002, etc.)
- Frequency of errors

**Environment:**
- AI assistant type (Claude Code, OpenCode, etc.)
- Model used (haiku, sonnet, opus)
- OpenProse version

### 12.2 What is NOT Collected

- Prompt content
- Code content
- Variable values
- File paths
- Personal information
- IP addresses
- User identity

### 12.3 Opt-Out

During `/prose-boot`, users are asked:

```
Enable telemetry? (yes/no)
  This helps improve OpenProse by collecting anonymous usage data.
  No personal information or code content is collected.
  You can change this later in .prose/config.json
```

**Manual Opt-Out:**
```json
// .prose/config.json
{
  "telemetry": {
    "enabled": false
  }
}
```

---

## 13. Comparison with Other Tools

### vs. LangChain / LangGraph

| Aspect | OpenProse | LangChain |
|--------|-----------|-----------|
| **Execution** | Inside AI session | Python runtime |
| **Control Flow** | Declarative with `**conditions**` | Imperative code |
| **State Management** | Conversation or file-based | External state stores |
| **Deployment** | No deployment (AI embodies VM) | Python server |
| **Learning Curve** | Minimal (reads like pseudocode) | Steep (API + concepts) |
| **Portability** | AI-agnostic | Python-specific |
| **Debugging** | Narration traces | Print statements |

### vs. CrewAI

| Aspect | OpenProse | CrewAI |
|--------|-----------|--------|
| **Orchestration** | Inside session | Outside (Python) |
| **Agent Definitions** | Templates in code | Classes |
| **Parallel Execution** | Native `parallel` block | Threading/async |
| **Conditional Logic** | `**semantic conditions**` | Boolean expressions |
| **Dependencies** | Zero | Python packages |

### vs. AutoGPT / BabyAGI

| Aspect | OpenProse | AutoGPT |
|--------|-----------|---------|
| **Autonomy** | Structured (explicit control) | Autonomous (goal-seeking) |
| **Control** | Full control over flow | Emergent behavior |
| **Predictability** | High | Low |
| **Use Case** | Known workflows | Open-ended exploration |
| **Debugging** | Clear execution trace | Hard to debug |

---

## 14. Limitations & Tradeoffs

### 14.1 Current Limitations

1. **No Traditional Functions:** Can't define functions with return values (use blocks instead)
2. **No Type System:** No static type checking (runtime only)
3. **No Module System:** Can't split programs across multiple files (yet)
4. **Single AI Platform:** Requires Claude Code or compatible assistant
5. **Beta State:** Syntax/semantics may change

### 14.2 Design Tradeoffs

**Tradeoff 1: Intelligence vs. Determinism**
- **Chosen:** Semantic `**conditions**` for flexibility
- **Cost:** Less deterministic than boolean logic
- **Mitigation:** `max:` limits on loops

**Tradeoff 2: Simplicity vs. Power**
- **Chosen:** Minimal syntax, high composability
- **Cost:** No advanced features (generics, macros, etc.)
- **Mitigation:** Extensibility via imports/skills

**Tradeoff 3: In-Session vs. External**
- **Chosen:** VM runs inside AI session
- **Cost:** Tied to AI conversation limits
- **Mitigation:** File-based state for long programs

---

## 15. Future Directions (Speculative)

### Tier 13-14 Features (Roadmap)

**Custom Functions:**
```prose
function analyze(data):
  let cleaned = session "Clean data"
    context: data
  let results = session "Analyze"
    context: cleaned
  return results
```

**Module System:**
```prose
# lib/common.prose
export block validate(data):
  session "Validate"
    context: data

# main.prose
import { validate } from "./lib/common"
do validate(user_input)
```

**Type Annotations:**
```prose
agent researcher:
  model: sonnet
  input: string
  output: { findings: string[], confidence: number }
```

**Async/Await Patterns:**
```prose
let handle = async session "Long-running task"

# Do other work...

let result = await handle
```

### Tooling

- **VS Code Extension:** Syntax highlighting, IntelliSense, debugging
- **Language Server Protocol (LSP):** IDE integration
- **Interactive Debugger:** Step through execution, inspect variables
- **Performance Profiler:** Identify bottlenecks

---

## 16. Key Takeaways

### For Developers

1. **OpenProse inverts orchestration:** The AI is the container, not the contained
2. **Structured + Intelligent:** Clear control flow with AI-evaluated conditions
3. **Zero dependencies:** No Python/JS runtime needed
4. **Portable:** `.prose` files work anywhere
5. **Start simple:** Basic workflows are trivial, complexity is additive

### For Architects

1. **New deployment model:** No servers, no state stores—just AI sessions
2. **Horizontal scaling:** Each session is independent
3. **Graceful degradation:** AI handles ambiguity intelligently
4. **Audit trails:** Narration provides execution traces
5. **Framework-agnostic:** Not locked into specific AI providers

### For Researchers

1. **Novel paradigm:** AI-embodied virtual machines
2. **The fourth wall:** Semantic conditions bridge NL and code
3. **Intelligent IoC:** Dependency injection via AI reasoning
4. **Open questions:** How far can this model scale?
5. **Extensibility:** Import system allows ecosystem growth

---

## 17. Getting Started Checklist

- [ ] Install Claude Code
- [ ] Add OpenProse plugin: `/plugin marketplace add git@github.com:openprose/prose.git`
- [ ] Install: `/plugin install open-prose@prose`
- [ ] Run onboarding: `/prose-boot`
- [ ] Try example: `/prose-run examples/01-hello-world.prose`
- [ ] Write your first program
- [ ] Read `docs.md` for syntax reference
- [ ] Read `prose.md` for VM semantics
- [ ] Explore 27+ examples
- [ ] Join community discussions

---

## 18. Resources

**Official:**
- GitHub: https://github.com/openprose/prose
- License: MIT
- Version: 0.3.1 (Beta)

**Documentation:**
- Language Spec: `skills/open-prose/docs.md`
- VM Semantics: `skills/open-prose/prose.md`
- Examples: `examples/` (31 files)

**Community:**
- Issues: https://github.com/openprose/prose/issues
- Discussions: https://github.com/openprose/prose/discussions

---

## Conclusion

OpenProse represents a fundamental rethinking of AI agent orchestration. By running **inside** the AI session rather than outside it, OpenProse achieves a unique combination of:

- **Clarity:** Structured control flow that's easy to read
- **Intelligence:** Semantic conditions that leverage AI reasoning
- **Simplicity:** Zero dependencies, plain text files
- **Portability:** Works across AI assistants
- **Power:** Parallel execution, error handling, pipelines, and more

The key insight—that an AI session is itself a Turing-complete computer—opens new possibilities for how we structure multi-agent workflows. The `**discretion markers**` provide a novel way to bridge natural language intent and structured code.

While still in beta, OpenProse offers a compelling vision for the future of AI agent programming: not as external orchestration frameworks, but as languages that AI sessions natively understand and execute.

---

**Document Version:** 1.0
**Last Updated:** January 4, 2026
**Author:** Claude (Anthropic)
**Research Depth:** Comprehensive (Full codebase analysis)
