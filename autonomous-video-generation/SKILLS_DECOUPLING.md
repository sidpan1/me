# Decoupled Analytics & Reflection Skills Architecture

## Overview

Separating analytics collection from insight generation creates a more modular, scalable system that supports multiple platforms and builds long-term domain knowledge.

---

## Current vs New Architecture

### OLD (Coupled):
```
analytics-collector skill
├── Collects YouTube data
├── Analyzes performance
├── Generates insights
└── Stored temporarily
```

**Problems:**
- Platform-specific logic mixed with insights
- Hard to add Instagram Reels later
- No long-term memory/learning
- Insights lost between sessions

### NEW (Decoupled):
```
youtube-analytics skill          instagram-analytics skill (future)
├── Collects YouTube data   ├── Collects Instagram data
├── Normalizes to schema    ├── Normalizes to schema
└── Stores in data/         └── Stores in data/

reflection skill
├── Reads normalized analytics from ALL platforms
├── Generates cross-platform insights
├── Creates hypotheses for testing
├── Builds domain knowledge base
└── Stores long-term memory in knowledge/
```

**Benefits:**
- ✅ Platform-agnostic insights
- ✅ Easy to add new platforms
- ✅ Long-term learning accumulation
- ✅ Cross-platform pattern recognition
- ✅ Persistent domain knowledge

---

## Architecture Design

### Skill 1: youtube-analytics (Platform-Specific)

**Location:** `.claude/skills/youtube-analytics/`

**Purpose:** Collect and normalize YouTube Shorts performance data

**SKILL.md Structure:**
```markdown
---
name: youtube-analytics
description: Collects performance metrics from YouTube Analytics API and normalizes to standard schema
---

## Purpose
Platform-specific analytics collection for YouTube Shorts. Handles YouTube API authentication, data retrieval, and normalization to cross-platform schema.

## What It Does
1. Authenticates with YouTube Analytics API
2. Fetches metrics for videos uploaded in last 24-48 hours
3. Retrieves: views, watch time, retention, engagement, CTR, traffic sources
4. Normalizes data to standard analytics schema
5. Stores in `data/analytics/youtube/YYYY-MM-DD.json`

## Normalized Schema
```json
{
  "platform": "youtube",
  "collected_at": "2026-01-10T10:30:00Z",
  "videos": [
    {
      "video_id": "abc123",
      "platform_id": "abc123",
      "upload_date": "2026-01-09",
      "title": "Perfect Rangoli Design",
      "theme": "satisfying_rangoli",
      "language": "hindi",
      "duration_seconds": 28,
      "metrics": {
        "views": 45000,
        "watch_time_seconds": 1134000,
        "avg_view_duration_seconds": 25.2,
        "retention_rate": 0.90,
        "likes": 2800,
        "comments": 156,
        "shares": 890,
        "saves": 430,
        "engagement_rate": 0.102,
        "ctr": 0.085,
        "impressions": 529411
      },
      "demographics": {...},
      "traffic_sources": {...}
    }
  ]
}
```

## Scripts
- `scripts/collect_youtube_analytics.py` - Main collection script
- `scripts/youtube_api_client.py` - API wrapper
- `scripts/normalize_data.py` - Schema normalization

## Usage
```bash
claude -p "Use youtube-analytics skill to collect data from last 24 hours"
```
```

**Key Features:**
- YouTube-specific API calls
- OAuth token management
- Metric calculation (engagement rate, retention, etc.)
- Platform ID mapping
- Error handling for API limits

---

### Skill 2: instagram-analytics (Future Platform)

**Location:** `.claude/skills/instagram-analytics/`

**Purpose:** Collect and normalize Instagram Reels performance data

**SKILL.md Structure:**
```markdown
---
name: instagram-analytics
description: Collects performance metrics from Instagram Graph API and normalizes to standard schema
---

## Purpose
Platform-specific analytics collection for Instagram Reels. Handles Instagram API authentication, data retrieval, and normalization to cross-platform schema.

## What It Does
1. Authenticates with Instagram Graph API
2. Fetches Reels metrics (plays, reach, engagement)
3. Normalizes to same schema as YouTube
4. Stores in `data/analytics/instagram/YYYY-MM-DD.json`

## Normalized Schema
Uses identical schema as youtube-analytics but with:
- `"platform": "instagram"`
- Instagram-specific metric mappings

## Scripts
- `scripts/collect_instagram_analytics.py`
- `scripts/instagram_api_client.py`
- `scripts/normalize_data.py`
```

**Key Features:**
- Instagram Graph API integration
- Same normalized output schema
- Business account requirement handling
- Separate data storage by platform

---

### Skill 3: reflection (Cross-Platform Insights)

**Location:** `.claude/skills/reflection/`

**Purpose:** Generate insights, hypotheses, and build long-term domain knowledge from analytics

**SKILL.md Structure:**
```markdown
---
name: reflection
description: Analyzes cross-platform performance data to generate actionable insights, hypotheses, and build long-term domain knowledge
---

## Purpose
Transform raw analytics into strategic intelligence. This skill:
- Identifies patterns across platforms
- Generates testable hypotheses
- Builds cumulative domain knowledge
- Creates optimization recommendations
- Maintains long-term memory of learnings

## What It Does

### 1. Cross-Platform Pattern Recognition
- Aggregates data from all platforms (YouTube, Instagram, etc.)
- Identifies what themes, hooks, formats perform best
- Compares platform-specific behaviors
- Detects emerging trends

### 2. Hypothesis Generation
- Creates testable predictions based on data
- Suggests A/B testing opportunities
- Proposes content variations to try
- Estimates expected outcomes

### 3. Domain Knowledge Building
- Stores proven patterns in knowledge base
- Documents "what works" insights
- Maintains library of successful hooks
- Tracks theme performance over time

### 4. Optimization Recommendations
- Suggests content adjustments
- Identifies underperforming areas
- Recommends doubling down on winners
- Provides next-week content strategy

## Data Sources
- `data/analytics/youtube/*.json` (normalized YouTube data)
- `data/analytics/instagram/*.json` (normalized Instagram data)
- `knowledge/domain_knowledge.json` (cumulative learnings)
- `knowledge/hypotheses.json` (active tests and results)

## Output Structure

### Insights Report
Stored in: `data/insights/YYYY-MM-DD.md`

```markdown
# Weekly Insights Report - January 3-9, 2026

## Performance Summary
- Total videos analyzed: 21
- Platforms: YouTube Shorts
- Best performer: "Diwali Rangoli Time-lapse" (125k views, 92% retention)
- Worst performer: "Abstract Pattern" (3.2k views, 58% retention)

## Key Patterns Identified

### 1. Hook Effectiveness
**Finding:** Videos starting with "Watch this transform" get 2.3x higher 3-second retention than "Check out this..."

**Data:**
- "Watch this": avg 3s retention = 87%
- "Check out": avg 3s retention = 38%
- Sample size: 12 videos

**Recommendation:** Use "Watch this [X] transform" hook for next batch

### 2. Theme Performance
**Finding:** Rangoli content outperforms abstract patterns by 3.1x on views

**Data:**
- Rangoli: avg 42k views, 85% retention
- Abstract: avg 13.5k views, 62% retention

**Recommendation:** Shift to 70% rangoli, 30% abstract (from current 50/50)

### 3. Timing Optimization
**Finding:** 7-9 PM IST posts get 40% more views than 12-2 PM

**Data:**
- Evening (7-9 PM): avg 48k views
- Lunch (12-2 PM): avg 34k views

**Recommendation:** Schedule all posts for 7:30 PM IST

## Hypotheses Generated

### Hypothesis 1: Seasonal Timing
**Prediction:** Publishing Diwali content 2 weeks before (vs 4 weeks) will increase peak-week views by 50%

**Test Plan:**
- For Holi 2026, publish half the content 4 weeks early, half 2 weeks early
- Compare peak-week performance
- Expected completion: March 10, 2026

### Hypothesis 2: ASMR Audio
**Prediction:** Adding natural rangoli-making sounds (powder pouring) will increase retention by 10%+

**Test Plan:**
- Create 5 videos with ASMR audio
- Create 5 videos with music only
- Same visual content, different audio
- Measure retention difference

### Hypothesis 3: Language Impact
**Prediction:** Hindi text overlays will outperform English by 25% in India

**Test Plan:**
- A/B test next 10 videos
- 5 with Hindi text, 5 with English text
- Same hook, same visuals
- Compare engagement and shares

## Domain Knowledge Updated

### Proven Patterns (Added to Knowledge Base)
1. ✅ "Watch this transform" hook = 87% 3s retention (confirmed)
2. ✅ Rangoli content = 3.1x better than abstract (new)
3. ✅ Evening posting = 40% boost (confirmed)
4. ✅ Symmetrical patterns = 15% higher shares (confirmed)

### Deprecated Patterns (Removed from Knowledge Base)
1. ❌ "Check out this" hook = underperforms (replaced)
2. ❌ Abstract patterns = low engagement (deprioritized)

## Optimization Recommendations

### Immediate Actions (Next 7 Days)
1. **Change all hooks** to "Watch this [X] transform" format
2. **Increase rangoli content** to 70% of production
3. **Shift posting time** to 7:30 PM IST exclusively
4. **Add ASMR audio** to 50% of videos (test hypothesis)

### Medium-Term (Next 30 Days)
1. Test Hindi vs English text overlays
2. Prepare Holi content 2 weeks early (test seasonal timing)
3. Create 5 more rangoli variations based on top performers

### Strategic (Next 90 Days)
1. Build template library for top 10 rangoli patterns
2. Explore regional language expansion (Tamil, Telugu)
3. Develop signature style for brand recognition
```

### Domain Knowledge Structure
Stored in: `knowledge/domain_knowledge.json`

```json
{
  "last_updated": "2026-01-10",
  "proven_patterns": {
    "hooks": [
      {
        "pattern": "Watch this [X] transform",
        "confidence": 0.95,
        "avg_3s_retention": 0.87,
        "sample_size": 12,
        "first_identified": "2026-01-03"
      }
    ],
    "themes": [
      {
        "theme": "rangoli",
        "avg_views": 42000,
        "avg_retention": 0.85,
        "engagement_rate": 0.102,
        "sample_size": 25,
        "best_performers": ["video_id_1", "video_id_2"]
      }
    ],
    "timing": [
      {
        "time_slot": "19:00-21:00 IST",
        "avg_views": 48000,
        "advantage_over_baseline": 1.40
      }
    ],
    "audio": [
      {
        "type": "ASMR_natural_sounds",
        "retention_boost": 0.12,
        "audience_feedback": "positive"
      }
    ]
  },
  "deprecated_patterns": [
    {
      "pattern": "Check out this [X]",
      "reason": "Low 3s retention (38%)",
      "deprecated_date": "2026-01-05"
    }
  ],
  "hypotheses_tested": [
    {
      "hypothesis": "Evening posting performs better",
      "result": "Confirmed - 40% improvement",
      "test_date": "2026-01-03",
      "confidence": 0.90
    }
  ],
  "content_performance_by_theme": {
    "rangoli": {"avg_views": 42000, "count": 25},
    "abstract": {"avg_views": 13500, "count": 15},
    "color_mixing": {"avg_views": 28000, "count": 8}
  }
}
```

### Hypotheses Tracking
Stored in: `knowledge/hypotheses.json`

```json
{
  "active_tests": [
    {
      "id": "H001",
      "hypothesis": "Seasonal content published 2 weeks before performs better than 4 weeks",
      "created_date": "2026-01-10",
      "test_start": "2026-02-18",
      "expected_completion": "2026-03-10",
      "status": "pending",
      "variables": {
        "control_group": "4_weeks_early",
        "test_group": "2_weeks_early"
      }
    }
  ],
  "completed_tests": [
    {
      "id": "H000",
      "hypothesis": "Evening posts outperform midday posts",
      "result": "CONFIRMED",
      "effect_size": 1.40,
      "confidence": 0.90,
      "completed_date": "2026-01-03"
    }
  ]
}
```

## Scripts
- `scripts/analyze_performance.py` - Main analysis engine
- `scripts/pattern_recognition.py` - Identifies trends
- `scripts/hypothesis_generator.py` - Creates testable predictions
- `scripts/knowledge_updater.py` - Maintains domain knowledge
- `scripts/report_generator.py` - Creates markdown insights

## Usage
```bash
# Weekly reflection
claude -p "Use reflection skill to analyze this week's performance and generate insights"

# Monthly deep dive
claude -p "Use reflection skill for monthly review with cross-platform comparison"
```
```

**Key Features:**
- Platform-agnostic analysis
- Hypothesis generation and tracking
- Domain knowledge accumulation
- Markdown reports for human review
- JSON knowledge base for machine learning

---

## Data Flow Architecture

```
┌─────────────────────┐
│   VIDEO UPLOADED    │
│   (YouTube Shorts)  │
└──────────┬──────────┘
           │
    Wait 24-48 hours
           │
           ▼
┌─────────────────────┐
│ youtube-analytics   │
│  skill activates    │
├─────────────────────┤
│ 1. Call YouTube API │
│ 2. Fetch metrics    │
│ 3. Normalize schema │
│ 4. Save to data/    │
└──────────┬──────────┘
           │
           ├──→ data/analytics/youtube/2026-01-10.json
           │
           ▼
┌─────────────────────┐
│  reflection skill   │
│   activates weekly  │
├─────────────────────┤
│ 1. Read all data/   │
│ 2. Identify patterns│
│ 3. Generate insights│
│ 4. Update knowledge │
│ 5. Create hypotheses│
└──────────┬──────────┘
           │
           ├──→ data/insights/2026-01-10.md
           ├──→ knowledge/domain_knowledge.json (updated)
           └──→ knowledge/hypotheses.json (updated)
```

---

## Benefits of Decoupling

### 1. Platform Scalability
**Before:** Adding Instagram = rewriting analytics skill

**After:** Adding Instagram = new instagram-analytics skill, reflection unchanged

### 2. Long-Term Memory
**Before:** Insights lost between sessions

**After:** Cumulative knowledge base grows over time

### 3. Cross-Platform Intelligence
**Before:** YouTube insights separate from Instagram

**After:** Reflection compares platforms, finds universal patterns

### 4. Hypothesis Testing
**Before:** Ad-hoc experimentation

**After:** Structured hypothesis tracking, results validation

### 5. Domain Expertise
**Before:** Starting from scratch each analysis

**After:** Building on proven patterns, faster iteration

---

## Directory Structure

```
autonomous-video-generation/
├── .claude/skills/
│   ├── youtube-analytics/
│   │   ├── SKILL.md
│   │   ├── scripts/
│   │   │   ├── collect_youtube_analytics.py
│   │   │   ├── youtube_api_client.py
│   │   │   └── normalize_data.py
│   │   └── references/
│   │       └── youtube-api-guide.md
│   │
│   ├── instagram-analytics/      # Future
│   │   ├── SKILL.md
│   │   └── scripts/
│   │       └── collect_instagram_analytics.py
│   │
│   └── reflection/
│       ├── SKILL.md
│       ├── scripts/
│       │   ├── analyze_performance.py
│       │   ├── pattern_recognition.py
│       │   ├── hypothesis_generator.py
│       │   ├── knowledge_updater.py
│       │   └── report_generator.py
│       ├── references/
│       │   ├── metrics-guide.md
│       │   └── pattern-library.md
│       └── assets/
│           └── report-template.md
│
├── data/
│   ├── analytics/
│   │   ├── youtube/
│   │   │   ├── 2026-01-09.json
│   │   │   ├── 2026-01-10.json
│   │   │   └── ...
│   │   └── instagram/            # Future
│   │       └── 2026-01-10.json
│   │
│   └── insights/
│       ├── 2026-01-10.md
│       └── monthly/
│           └── 2026-01.md
│
└── knowledge/                     # Long-term memory
    ├── domain_knowledge.json
    ├── hypotheses.json
    └── proven_patterns/
        ├── hooks.json
        ├── themes.json
        └── timing.json
```

---

## Workflow Integration

### Daily Workflow

**Evening (After Videos Published):**
```
1. Videos auto-publish at 7:30 PM IST
2. System waits 24 hours
```

### Next Day (Data Collection):
```
3. youtube-analytics skill activates automatically
4. Collects metrics from yesterday's videos
5. Normalizes and stores in data/analytics/youtube/
```

### Weekly (Reflection & Planning):
```
6. Every Sunday, reflection skill activates
7. Reads all analytics from past week
8. Generates insights report
9. Updates domain knowledge
10. Creates hypotheses for next week
11. Outputs optimization recommendations
```

**Sunday Planning Session:**
```
12. Human reviews insights report
13. Decides which hypotheses to test
14. Updates generation_params.yaml based on recommendations
15. Plans next week's content incorporating insights
```

---

## Automation with Hooks

### SessionStart Hook
```bash
# .claude/hooks/session-start.sh

# Check if it's Sunday (reflection day)
if [ $(date +%u) -eq 7 ]; then
    echo "📊 Sunday - Time for weekly reflection!"

    # Trigger weekly analytics collection
    claude -p "Use youtube-analytics skill to collect all data from past 7 days"

    # Generate insights
    claude -p "Use reflection skill to analyze week's performance and generate insights report"

    echo "✅ Weekly insights generated. Review data/insights/$(date +%Y-%m-%d).md"
fi
```

### Daily Analytics Collection
```yaml
# .github/workflows/daily-analytics.yml

name: Daily Analytics Collection

on:
  schedule:
    # Run at 8 PM IST daily (1 hour after video posts, 24h after previous day)
    - cron: '30 14 * * *'  # 2:30 PM UTC = 8 PM IST

jobs:
  collect-analytics:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Collect YouTube Analytics
        run: |
          claude -p "Use youtube-analytics skill to collect yesterday's metrics"

      - name: Commit analytics data
        run: |
          git add data/analytics/
          git commit -m "📊 Daily analytics $(date +%Y-%m-%d)" || echo "No new data"
          git push
```

---

## Example: Seasonal Insight from Reflection

```markdown
# Seasonal Insight - Diwali 2026

## Finding
Diwali content published 2 weeks before festival (Oct 25) significantly outperformed content published 4 weeks before (Oct 11).

## Data
| Publish Timing | Avg Views | Retention | Engagement | Peak Week Views |
|----------------|-----------|-----------|------------|-----------------|
| 4 weeks early  | 28,000    | 72%       | 6.2%       | 35,000 (25% of total) |
| 2 weeks early  | 62,000    | 84%       | 9.8%       | 54,000 (87% of total) |

## Pattern Identified
- 2-week timing: 2.2x total views, 12% higher retention, 58% higher engagement
- Content stayed "fresh" when festival arrived (within 30-day algorithm window)
- Peak views concentrated in festival week (87% vs 25%)

## Hypothesis Confirmed
✅ H001: "Seasonal content published 2 weeks before performs better than 4 weeks"

## Domain Knowledge Updated
```json
{
  "seasonal_publishing": {
    "optimal_timing": "2_weeks_before_event",
    "confidence": 0.92,
    "effect_size": 2.2,
    "sample_festival": "Diwali_2026",
    "applies_to": ["all_major_festivals"]
  }
}
```

## Recommendation for Future Festivals
- **Holi 2027**: Publish starting Feb 18 (2 weeks before Mar 4)
- **Navratri 2027**: Publish starting Sep 24 (2 weeks before Oct 8)
- **Do NOT** publish seasonal content >3 weeks before event
```

---

## Migration Path

### Phase 1: Split Current Skill (Week 1)
1. Create youtube-analytics skill from analytics-collector
2. Move platform-specific logic
3. Implement normalized schema
4. Test data collection

### Phase 2: Create Reflection Skill (Week 2)
1. Build reflection skill skeleton
2. Implement basic pattern recognition
3. Create markdown report generator
4. Test with Week 1 data

### Phase 3: Add Domain Knowledge (Week 3)
1. Design domain_knowledge.json structure
2. Implement knowledge_updater.py
3. Create hypothesis tracking system
4. Test cumulative learning

### Phase 4: Automate (Week 4)
1. Add SessionStart hook for Sunday reflection
2. Create GitHub Actions for daily collection
3. Set up automatic git commits
4. Full end-to-end testing

---

## Conclusion

Decoupling analytics and reflection provides:

✅ **Platform Scalability**: Easy to add Instagram, TikTok, etc.
✅ **Long-Term Memory**: Knowledge accumulates over time
✅ **Cross-Platform Intelligence**: Universal patterns emerge
✅ **Hypothesis Tracking**: Structured experimentation
✅ **Domain Expertise**: System gets smarter with each analysis

**Result:** An AI system that not only collects data but **learns** from it, building expertise that compounds over time—the foundation of true autonomous optimization.
