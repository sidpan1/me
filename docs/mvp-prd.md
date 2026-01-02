# Background Coding Agents Platform — MVP (v0.1)

## 1. Overview

### 1.1 Problem Statement

Enable AI coding agents to autonomously execute development tasks—accepting a coding task, running Claude Code in isolation, and committing code changes to a repository.

### 1.2 MVP Goal

**Prove the core value proposition works:** A user submits a coding task via API, the system executes it using Claude Code in an isolated container, and commits the result to GitHub.

### 1.3 Success Criteria

| Metric | Target |
|--------|--------|
| Task Success Rate | >70% |
| E2E Latency (simple task) | <10 min |
| Internal Users | 5 active users |
| Tasks Processed | 50 in first month |

---

## 2. Scope

### 2.1 Components

| Component | Implementation | Details |
|-----------|----------------|---------|
| **Task API** | `POST /tasks`, `GET /tasks/{id}` | FastAPI endpoints for task submission and status polling. Synchronous create, async execution. |
| **Task Storage** | JSON files (`/data/tasks/`) | One file per task containing status, input, output, timestamps. Survives service restart. |
| **Sandbox** | Docker container | Isolated execution environment with Claude Code CLI pre-installed. Cold start on each task. |
| **Agent** | Claude Code CLI | Runs with `--dangerously-skip-permissions` flag for autonomous operation. |
| **Templates** | `.task-templates/` in target repo | Contains init.py specification for setup. CLAUDE.md and agent.md are optional. |
| **Git Operations** | Clone → Branch → Commit → Push | Full git workflow: clone target repo, create feature branch, commit changes, push to remote. |
| **Workspace** | EFS persistent volume | Mounted per task, retains state across container restarts, enables debugging of failed tasks. |
| **Status Tracking** | QUEUED → RUNNING → COMPLETED/FAILED | Simple state machine. Orchestrator updates status based on container exit code. |

### 2.2 Functional Requirements

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| FR-1 | Create task via API | POST /tasks returns task_id and QUEUED status within 500ms |
| FR-2 | Poll task status | GET /tasks/{id} returns current status, result (if completed), or error (if failed) |
| FR-3 | Clone repository | Agent clones specified repo using provided GitHub token |
| FR-4 | Create feature branch | Agent creates new branch from specified base branch |
| FR-5 | Execute Claude Code | Agent runs Claude Code with task description, template auto-loaded |
| FR-6 | Commit changes | Agent commits all changes (excluding template files) with descriptive message |
| FR-7 | Push to remote | Agent pushes feature branch to GitHub |
| FR-8 | Persist task state | Task survives service restart, can be queried after completion |
| FR-9 | Template initialization | Platform executes `.task-templates/{name}/scripts/init.py` before Claude Code execution |
| FR-10 | Timeout handling | Tasks exceeding 30 minutes are terminated and marked FAILED |

### 2.3 Non-Functional Requirements

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-1 | API response time | < 500ms for task creation |
| NFR-2 | Task throughput | Support 10 concurrent tasks |
| NFR-3 | Execution timeout | 30 minutes max per task |
| NFR-4 | Storage durability | Task state survives service restart |
| NFR-5 | Isolation | Each task runs in separate container with no shared state |
| NFR-6 | Observability | Structured logs for debugging failed tasks |

---

## 3. Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         MVP ARCHITECTURE                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────┐     ┌──────────────────────────────────────────────────┐  │
│  │  Client  │────▶│              API Server (FastAPI)                │  │
│  │          │◀────│  • POST /tasks - create task                     │  │
│  └──────────┘     │  • GET /tasks/{id} - poll status                 │  │
│                   └─────────────────────┬────────────────────────────┘  │
│                                         │                                │
│                                         ▼                                │
│                   ┌─────────────────────────────────────────────────┐   │
│                   │              Task Orchestrator                   │   │
│                   │  • Read/write task JSON files                   │   │
│                   │  • Spawn Docker containers                      │   │
│                   │  • Monitor execution                            │   │
│                   └─────────────────────┬───────────────────────────┘   │
│                                         │                                │
│        ┌────────────────────────────────┼────────────────────────────┐  │
│        ▼                                ▼                            ▼  │
│  ┌───────────┐                   ┌───────────┐              ┌─────────┐ │
│  │ /data/    │                   │  Docker   │              │  EFS    │ │
│  │ tasks/    │                   │ Container │◀────────────▶│ Volume  │ │
│  │ *.json    │                   │ (Sandbox) │              │/workspace│ │
│  └───────────┘                   │           │              └─────────┘ │
│  Task metadata                   │ Claude    │              Code + state │
│                                  │ Code CLI  │                          │
│                                  └─────┬─────┘                          │
│                                        │                                 │
│                                        ▼                                 │
│                                  ┌───────────┐                          │
│                                  │  GitHub   │                          │
│                                  │  (Remote) │                          │
│                                  └───────────┘                          │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 4. Tech Stack

| Component | Choice | Rationale |
|-----------|--------|-----------|
| API | FastAPI (Python) | Fast to build, async-native, auto-docs |
| Task Storage | JSON files | No infra dependency, simple |
| Sandbox | Docker | Available everywhere, sufficient isolation |
| Workspace Storage | EFS | Managed, durable, multi-AZ |
| Git Provider | GitHub | Most common, good API/CLI |
| Hosting | Single EC2 or ECS | Simple deployment, supports concurrent tasks |

---

## 5. Workflow

```
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 1: TASK SUBMISSION                                                   │
│  ─────────────────────────────────────────────────────────────────────────│
│  POST /tasks                                                               │
│  {                                                                         │
│    "repo": "github.com/swiggy/order-service",                             │
│    "task": "Add rate limiting to /api/orders endpoint",                   │
│    "base_branch": "main",                                                  │
│    "new_branch": "feature/rate-limiting",                                  │
│    "task_template": "backend/feature"                                      │
│  }                                                                         │
│                                                                            │
│  → Generate task_id (UUID)                                                │
│  → Write task JSON to /data/tasks/{task_id}.json                          │
│  → Set status = QUEUED                                                     │
│  → Return { "id": task_id, "status": "QUEUED" }                           │
└────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 2: CONTAINER SPAWN                                                   │
│  ─────────────────────────────────────────────────────────────────────────│
│  • Orchestrator picks up QUEUED task                                      │
│  • Update status = RUNNING                                                │
│  • Spawn Docker container with:                                           │
│    - Environment: REPO_URL, TASK_DESCRIPTION, BASE_BRANCH, NEW_BRANCH     │
│    - Environment: GITHUB_TOKEN, ANTHROPIC_API_KEY                         │
│    - Volume mount: /data/workspaces/{task_id} → /workspace                │
│    - Timeout: 30 minutes                                                  │
└────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 3: AGENT EXECUTION (Inside Container)                                │
│  ─────────────────────────────────────────────────────────────────────────│
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │  #!/bin/bash                                                        │  │
│  │  set -e                                                             │  │
│  │                                                                      │  │
│  │  # Clone and branch                                                 │  │
│  │  git clone https://${GITHUB_TOKEN}@${REPO_URL} /workspace/repo      │  │
│  │  cd /workspace/repo                                                 │  │
│  │  git checkout ${BASE_BRANCH}                                        │  │
│  │  git checkout -b ${NEW_BRANCH}                                      │  │
│  │                                                                      │  │
│  │  # Run Claude Code                                                  │  │
│  │  claude --print --dangerously-skip-permissions \                    │  │
│  │    "${TASK_DESCRIPTION}"                                            │  │
│  │                                                                      │  │
│  │  # Commit and push                                                  │  │
│  │  git add -A                                                         │  │
│  │  git commit -m "feat: ${TASK_DESCRIPTION:0:50}" || true             │  │
│  │  git push origin ${NEW_BRANCH}                                      │  │
│  │                                                                      │  │
│  │  # Output commit SHA                                                │  │
│  │  git rev-parse HEAD > /workspace/result.txt                         │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────────┐
│  STEP 4: COMPLETION                                                        │
│  ─────────────────────────────────────────────────────────────────────────│
│  • Orchestrator detects container exit                                    │
│  • If exit code 0:                                                        │
│    - Read commit SHA from /workspace/result.txt                           │
│    - Update task JSON: status=COMPLETED, commit_sha=xxx                   │
│  • If exit code != 0:                                                     │
│    - Capture container logs                                               │
│    - Update task JSON: status=FAILED, error=logs                          │
│  • Client polls GET /tasks/{id} to get final status                       │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 6. API Specification

### 6.1 Create Task

**`POST /tasks`**

Request:
```json
{
  "repo": "github.com/swiggy/order-service",
  "task": "Add rate limiting to /api/orders endpoint",
  "base_branch": "main",
  "new_branch": "feature/rate-limiting",
  "task_template": "backend/feature"
}
```

Response:
```json
{
  "id": "task-abc-123",
  "status": "QUEUED"
}
```

| Field | Required | Description |
|-------|----------|-------------|
| `repo` | Yes | Git repository URL (without https://) |
| `task` | Yes | Natural language task description |
| `base_branch` | Yes | Branch to create new branch from |
| `new_branch` | Yes | New branch name for changes |
| `task_template` | No | Template path (default: `"default"`) |

### 6.2 Get Task Status

**`GET /tasks/{id}`**

Response (Running):
```json
{
  "id": "task-abc-123",
  "status": "RUNNING",
  "created_at": "2024-01-15T10:00:00Z",
  "updated_at": "2024-01-15T10:01:00Z"
}
```

Response (Completed):
```json
{
  "id": "task-abc-123",
  "status": "COMPLETED",
  "created_at": "2024-01-15T10:00:00Z",
  "updated_at": "2024-01-15T10:05:00Z",
  "result": {
    "commit_sha": "a1b2c3d4e5f6",
    "branch": "feature/rate-limiting"
  }
}
```

Response (Failed):
```json
{
  "id": "task-abc-123",
  "status": "FAILED",
  "created_at": "2024-01-15T10:00:00Z",
  "updated_at": "2024-01-15T10:03:00Z",
  "error": "Git push failed: permission denied"
}
```

### 6.3 Status Values

```
QUEUED ──▶ RUNNING ──▶ COMPLETED
                  └──▶ FAILED
```

---

## 7. Storage: Git vs Filesystem

### 7.1 Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     STORAGE SEPARATION                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────────────────────────┐    ┌─────────────────────────────────┐ │
│  │     GIT REPOSITORY          │    │     PERSISTENT FILESYSTEM       │ │
│  │     (Platform Code)         │    │     (Runtime Data)              │ │
│  │     ─────────────────       │    │     ──────────────────          │ │
│  │                             │    │                                 │ │
│  │  github.com/swiggy/         │    │  /data/                         │ │
│  │    coding-agents-platform/  │    │  ├── tasks/        (Task state) │ │
│  │  ├── app/                   │    │  │   └── *.json                 │ │
│  │  │   ├── main.py            │    │  └── workspaces/  (Execution)   │ │
│  │  │   ├── orchestrator.py    │    │      └── {task_id}/             │ │
│  │  │   └── models.py          │    │          ├── repo/              │ │
│  │  ├── docker/                │    │          ├── result.txt         │ │
│  │  │   ├── Dockerfile         │    │          └── logs/              │ │
│  │  │   └── execute.sh         │    │                                 │ │
│  │  ├── tests/                 │    │  Characteristics:               │ │
│  │  └── README.md              │    │  • Generated at runtime         │ │
│  │                             │    │  • Task-specific                │ │
│  │  Characteristics:           │    │  • Ephemeral (TTL-based)        │ │
│  │  • Version controlled       │    │  • Contains secrets in memory   │ │
│  │  • Shared across instances  │    │  • Mounted on EFS/EBS           │ │
│  │  • Deployed via CI/CD       │    │                                 │ │
│  │  • No runtime data          │    │                                 │ │
│  │  • No secrets               │    │                                 │ │
│  └─────────────────────────────┘    └─────────────────────────────────┘ │
│                                                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐│
│  │     TARGET REPOS (e.g., github.com/swiggy/order-service)            ││
│  │     ───────────────────────────────────────────────────────────     ││
│  │     Contains: .task-templates/ with init.py specification           ││
│  │     Owned by: Repo teams (not platform team)                        ││
│  └─────────────────────────────────────────────────────────────────────┘│
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 7.2 Git Repository (Platform Code)

**Location:** `github.com/swiggy/coding-agents-platform`

```
coding-agents-platform/
├── app/                          # API Server
│   ├── __init__.py
│   ├── main.py                   # FastAPI app, routes
│   ├── orchestrator.py           # Task queue, container spawning
│   ├── models.py                 # Pydantic schemas
│   └── storage.py                # Task JSON file operations
├── docker/                       # Container Image
│   ├── Dockerfile                # Agent container definition
│   └── execute.sh                # Execution script (runs inside container)
├── tests/                        # Test Suite
│   ├── test_api.py
│   ├── test_orchestrator.py
│   └── fixtures/
├── scripts/                      # Utilities
│   ├── build.sh
│   └── deploy.sh
├── docs/                         # Documentation
│   └── api.md
├── .github/                      # CI/CD
│   └── workflows/
│       └── deploy.yaml
├── requirements.txt
├── pyproject.toml
└── README.md
```

| Path | Purpose | Changes |
|------|---------|---------|
| `app/` | API server code | On feature development |
| `docker/` | Container image definition | On agent behavior changes |
| `tests/` | Automated tests | On code changes |
| `.github/` | CI/CD workflows | On deployment changes |

**Note:** Task templates are NOT in this repo. They are checked into each target repository in `.task-templates/`.

### 7.3 Persistent Filesystem (Runtime Data)

**Location:** `/data/` (mounted EFS volume)

```
/data/
├── tasks/                        # Task Metadata (JSON files)
│   ├── task-abc-123.json         # One file per task
│   ├── task-def-456.json
│   └── ...
└── workspaces/                   # Execution Workspaces
    ├── task-abc-123/             # One directory per task
    │   ├── repo/                 # Cloned target repository
    │   │   ├── .git/
    │   │   ├── src/
    │   │   └── ...
    │   ├── result.txt            # Commit SHA on success
    │   └── logs/
    │       └── execution.log     # Container stdout/stderr
    └── task-def-456/
        └── ...
```

| Path | Purpose | Lifecycle |
|------|---------|-----------|
| `/data/tasks/*.json` | Task state, input, output | Created on submit, updated during execution, retained indefinitely |
| `/data/workspaces/{id}/repo/` | Cloned repository + changes | Created on execution start, retained for debugging |
| `/data/workspaces/{id}/result.txt` | Commit SHA output | Created on success |
| `/data/workspaces/{id}/logs/` | Execution logs | Created during execution, retained for debugging |

### 7.4 What Goes Where (Decision Guide)

| Data Type | Storage | Rationale |
|-----------|---------|-----------|
| API server code | Git (platform repo) | Version controlled, deployed |
| Dockerfile | Git (platform repo) | Version controlled, built in CI |
| Task templates | Git (target repos) | Repo-specific, in `.task-templates/` |
| Task JSON (state) | Filesystem | Runtime-generated, task-specific |
| Cloned repo | Filesystem | Runtime-generated, large, ephemeral |
| Execution logs | Filesystem | Runtime-generated, debugging |
| GitHub token | Environment variable | Secret, never persisted |
| Anthropic API key | Environment variable | Secret, never persisted |

### 7.5 Filesystem Retention Policy

| Data | Retention | Cleanup |
|------|-----------|---------|
| Task JSON files | Indefinite | Manual cleanup or cron-based TTL
