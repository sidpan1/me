# Autonomous Video Generation System - Master Plan

## Vision

An autonomous system powered by Claude Code that generates, publishes, analyzes, and self-improves short-form video content (YouTube Shorts) targeting Indian audiences. The system runs daily with built-in analytics feedback loops for continuous improvement.

**Target**: YouTube Shorts → Indian consumers → Satisfying videos (starting with rangoli theme)
**Goal**: Monetization (1,000 subs + 10M views) in 90-120 days
**Approach**: Full AI automation with seasonal revenue strategy

---

## Strategic Decisions

### 1. Platform: YouTube Shorts

**Why YouTube Shorts over Instagram Reels:**
- 5.9% engagement rate vs 1.2% for Reels
- ₹15-₹50 RPM with 45% creator revenue share
- Better API access and automation support
- 600M+ users in India

📊 **See**: [research/platform/youtube-shorts-analysis.md](research/platform/youtube-shorts-analysis.md)

### 2. Content Theme: Satisfying Videos + Rangoli

**Initial Focus:**
- Satisfying/attention-grabbing videos for Indian market
- Rangoli art (perfect niche = cultural + satisfying + seasonal)
- Hindi + regional languages (95% of consumption)

**Why This Works:**
- 40% higher engagement with cultural authenticity
- ASMR elements (powder pouring, pattern creation)
- Multi-festival applicability (5-7 major festivals/year)
- Search-optimized content

### 3. Monetization Strategy: Seasonal Revenue Leverage

**Base Strategy:**
- 40-45% evergreen content (consistent baseline)
- 30-35% trending content (algorithm boost)
- **20-25% seasonal content (49-63% revenue boost)**

**Major Revenue Opportunities (2026):**
- Diwali (Nov 8): ₹2-3 lakh potential
- Holi (Mar 4): ₹1-1.5 lakh potential
- Navratri (Oct 9-17): ₹1-1.5 lakh potential
- Ganesh Chaturthi (Sep 14): ₹80k-1.2 lakh potential

**Annual festival revenue**: ₹7.9-12.1 lakh ($9.5k-$14.5k)

📊 **See**: [research/monetization/seasonal-revenue.md](research/monetization/seasonal-revenue.md)

### 4. Content Longevity Reality Check

**September 2025 Algorithm Shift:**
- 85% of views in first 48 hours
- 30-day content cliff (sharp drop-off)
- "Create once, earn forever" model ended
- Requires **ongoing production** for sustained revenue

**Adaptation Strategy:**
- Treat Shorts as traffic funnel, not passive income
- Diversify revenue (long-form, affiliate, products)
- Leverage seasonal spikes for predictable revenue
- Focus on high-retention quality over volume

📊 **See**: [research/monetization/content-longevity.md](research/monetization/content-longevity.md)

### 5. Timeline: Aggressive 90-120 Day Approach

**Why AI enables faster monetization:**
- 10x production speed vs manual creation
- Faster iteration and testing
- No creator burnout
- More data for algorithm learning
- Higher probability of viral hits (law of large numbers)

**90-Day Plan:**
- Month 1: 69 Shorts (scale 1/day → 3/day), 300-500 subs target
- Month 2: 90 Shorts (consistent 3/day), 700-1,200 subs target
- Month 3: 90 Shorts (optimized), **1,000+ subs ✅ MONETIZED**

**Success Probability:**
- 90 days: 30-40% (aggressive, top 10% of creators)
- 120 days: 60-70% (realistic)
- 180 days: 90%+ (conservative backup)

📊 **See**: [research/monetization/timeline-strategy.md](research/monetization/timeline-strategy.md)

### 6. Technical Stack: fal.ai Aggregator

**Single API provider instead of 5+:**
- **Video**: Veo 3.1 Fast ($0.80/clip, 8 seconds)
- **Images**: FLUX [dev] ($0.025/image)
- **Voice**: ElevenLabs TTS ($0.006/150 chars)
- **Music**: Sonauto V2 ($0.05/track)

**Cost**: $2.66/video (vs $1.94 multi-provider)
**Trade-off**: +37% cost but superior quality + operational simplicity

**Benefits:**
- Single API key, unified SDK
- 99.99% uptime SLA
- Simplified error handling
- Faster Veo 3.1 Fast variant (2x speed)

📊 **See**: [research/technical/api-aggregation.md](research/technical/api-aggregation.md)

### 7. Analytics Architecture: Decoupled Platform + Insights

**Two-skill approach:**

**youtube-analytics** (platform-specific):
- Collects YouTube metrics via API
- Normalizes to standardized schema
- Stores in `data/analytics/youtube/`

**reflection** (cross-platform insights):
- Aggregates normalized analytics
- Identifies proven patterns → saves to `knowledge/`
- Generates testable hypotheses
- Builds long-term domain knowledge

**Why this matters:**
- Multi-platform ready (Instagram/TikTok future)
- Long-term memory accumulation
- Cross-platform pattern recognition
- Hypothesis-driven optimization

📊 **See**: [research/technical/analytics-architecture.md](research/technical/analytics-architecture.md)

---

## Financial Projections

### Investment Required

**Aggressive (3-month) Timeline:**
- Video generation: $662 (249 Shorts × $2.66)
- Time: 180 hours (15 hours/week × 12 weeks)
- **Total**: ~$700

**Conservative (6-month) Timeline:**
- Video generation: $479 (180 Shorts × $2.66)
- Time: 240 hours (10 hours/week × 24 weeks)
- **Total**: ~$550

### Expected Returns (First Year)

**Aggressive Scenario (90-day monetization):**
- Base evergreen revenue: ₹51 lakh ($61.5k)
- **+ Seasonal strategy**: ₹58.9-63.1 lakh ($71k-$76k)
- **ROI**: 10,140-10,860% or **101-109x**

**Conservative Scenario (6-month monetization):**
- Base evergreen revenue: ₹30 lakh ($36k)
- **+ Seasonal strategy**: ₹34-36 lakh ($41k-$43k)
- **ROI**: 7,409-7,864% or **74-79x**

**Break-even:**
- Aggressive: ~148,000 views/month with seasonal strategy
- Conservative: ~221,000 views/month base
- Typically achieved 1-2 months post-monetization

---

## Execution Roadmap

### Phase 1: Foundation (Month 1)

**Goal**: Test and scale to 3 Shorts/day

**Activities:**
- Set up Claude Code skills infrastructure
- Configure fal.ai API integration
- Test video generation workflow
- Publish 69 Shorts (scale 1/day → 3/day)
- Establish baseline metrics

**Success Metrics:**
- 300-500 subscribers
- 500k-1M total views
- 1-2 viral hits (>100k views)
- 70%+ retention rate on best-performing videos
- Identify 3-5 winning hook patterns

**Deliverables:**
- Working autonomous generation pipeline
- Initial analytics baseline
- Proven content formats

### Phase 2: Optimization (Month 2)

**Goal**: Scale consistently while optimizing

**Activities:**
- 90 Shorts (3/day consistently)
- 50% proven formats + 50% experimental
- Weekly reflection skill runs → build knowledge base
- Implement series format for retention
- Test seasonal content (if festivals align)

**Success Metrics:**
- 700-1,200 total subscribers
- 3-5M cumulative views
- 3-5 viral hits
- Proven pattern library (10+ validated hooks/themes)
- 5+ tested hypotheses

**Deliverables:**
- Refined content strategy
- Growing knowledge base
- Validated seasonal templates (if applicable)

### Phase 3: Monetization Push (Month 3)

**Goal**: Achieve 1,000 subs + 10M views in 90-day window

**Activities:**
- 90 Shorts (3/day, 100% optimized formats)
- Peak timing optimization (6-9 PM IST)
- First-hour engagement tactics (reply to all comments)
- Binge-worthy series for watch time
- Subscriber conversion optimization

**Success Metrics:**
- **1,000+ subscribers ✅**
- **10-15M views in 90-day window ✅**
- **Monetization approved ✅**
- 80%+ retention rate on best content
- Established publishing rhythm

**Deliverables:**
- Monetized channel
- Sustainable content engine
- Comprehensive knowledge base

### Phase 4: Revenue Scaling (Months 4-6)

**Goal**: Maximize revenue and establish seasonal cadence

**Activities:**
- Maintain 2-3 Shorts/day
- Execute seasonal campaigns (align with festivals)
- Build long-form funnel (top 10 Shorts → extended versions)
- Explore affiliate/product opportunities
- Refine based on revenue data

**Success Metrics:**
- ₹30k-50k/month revenue (base)
- +49-63% boost during festival periods
- Long-form conversion: 10% of Shorts viewers
- Subscriber growth: 200+/week

**Deliverables:**
- Revenue diversification started
- Seasonal campaign playbooks
- Scaled content operation

### Phase 5: Multi-Platform Expansion (Months 7-12)

**Goal**: Replicate success on Instagram Reels

**Activities:**
- Cross-post top-performing YouTube Shorts
- Create instagram-analytics skill (reuse reflection skill)
- Test platform-specific optimizations
- Build unified analytics dashboard

**Success Metrics:**
- Instagram: 500+ followers
- Cross-platform reach: 2M+ monthly views
- Revenue: ₹50k-80k/month across platforms

**Deliverables:**
- Multi-platform presence
- Cross-platform knowledge base
- Diversified revenue streams

---

## Success Metrics & KPIs

### Video-Level Metrics

**Must-Track (Per Video):**
- **Retention Rate**: Target 60%+ (70%+ for viral potential)
- **Engagement Rate**: Target 5.9%+ (likes + comments + shares / views)
- **CTR**: Target 8%+ (clicks / impressions)
- **Average View Duration**: Target 50%+ of video length

**Secondary:**
- Views in first 24 hours (target: 1,000+)
- Likes/view ratio (target: 4%+)
- Comments (target: 10+)
- Shares (target: 20+)

### Channel-Level Metrics

**Growth Indicators:**
- Subscriber growth rate (target: 50+/week initially, 200+/week post-monetization)
- Total watch time (track weekly trend)
- Monthly views (target: 50k Month 1 → 500k+ Month 3 → 1M+ Month 6)
- Subscriber conversion rate (target: 5%+ subs/views ratio)

**Monetization Progress:**
- Path to 1,000 subs (track daily)
- Path to 10M views in 90-day window (track cumulative)
- Revenue per 1,000 views (RPM) post-monetization

### System Performance Metrics

**Operational:**
- Generation success rate (target: 95%+)
- Average generation time (target: <30 min/video)
- Upload success rate (target: 100%)
- Cost per video (track and optimize)

**Quality:**
- Videos meeting retention target (target: 70%+)
- Videos exceeding engagement benchmark (target: 50%+)
- Viral videos >100k views (target: 1-2/month by Month 3)

---

## Claude Code Skills Architecture

### Skill Organization Principle

**Self-contained bundles** following progressive disclosure:
```
skill-name/
├── SKILL.md              # Entry point with workflow
├── scripts/              # Executable code
├── references/           # Detailed docs (on-demand)
└── assets/               # Templates and outputs
```

📊 **See**: [research/technical/skills-structure.md](research/technical/skills-structure.md)

### Required Skills

**Content Generation Skills:**
1. **idea-generator** - Trend analysis, concept creation, theme selection
2. **script-writer** - Hook optimization, ASMR scripting, Hindi/regional language
3. **scene-planner** - Storyboarding, timing, visual composition
4. **asset-generator** - fal.ai integration (Veo 3.1, FLUX, ElevenLabs, Sonauto)
5. **video-assembler** - Remotion-based programmatic assembly

**Publishing & Analytics Skills:**
6. **youtube-publisher** - OAuth, upload, metadata optimization, SEO
7. **youtube-analytics** - Metrics collection, normalization, storage
8. **reflection** - Cross-platform insights, pattern recognition, hypothesis testing

**Configuration:**
- Environment variables (fal.ai API key, YouTube OAuth)
- Generation parameters (duration, resolution, language, theme)
- Publishing schedule (timing, frequency, batch size)

---

## Risk Mitigation

### Content Policy Compliance

**YouTube AI Content Policies (2026):**
- ✅ Disclose AI-generated content in description
- ✅ Maintain human creative oversight (theme selection, approval)
- ✅ Ensure content variety (avoid repetitive patterns)
- ✅ Use licensed music/audio only
- ❌ Never fully automate without review (at least initially)

**July 2025 Policy**: Mass-produced AI content gets 5.44x traffic decrease

**How We Avoid Penalties:**
- Quality over quantity (70%+ retention standard)
- Human creative input (theme selection, concept approval)
- Variety in execution (20+ satisfying video types)
- AI disclosure (transparency builds trust)
- Engagement focus (reply to comments within first hour)

### Technical Risks

**API Failures:**
- Implement retry logic with exponential backoff
- fal.ai provides 99.99% uptime SLA
- Log all errors for debugging

**Rate Limits:**
- Batch production (21 videos on Sunday for the week)
- Spread generation across hours
- Monitor API quotas

**Quality Degradation:**
- Automated quality checks (resolution, duration, format validation)
- Retention rate monitoring (auto-flag <50% retention)
- Weekly spot-checks

### Business Risks

**Monetization Delays:**
- Focus on subscriber growth early (engagement tactics)
- 90/120/180-day fallback timelines
- Build email list or community for direct engagement

**Cost Overruns:**
- Set monthly budget caps ($80/month conservative, $240/month aggressive)
- Monitor cost-per-view metric
- Optimize video length and clip count

**Content Saturation:**
- Diversify themes after initial success
- Test new formats (educational, storytelling)
- Leverage seasonal variety (5-7 festival types)

---

## Next Steps

### Immediate Actions (Week 1)

1. **Set up infrastructure:**
   - Create `.claude/skills/` directory structure
   - Configure fal.ai API access
   - Set up YouTube OAuth 2.0

2. **Build core skills:**
   - idea-generator (start with rangoli theme templates)
   - asset-generator (fal.ai integration)
   - youtube-publisher (upload + metadata)

3. **Test workflow:**
   - Generate 1 test video end-to-end
   - Validate quality (retention simulation)
   - Publish privately, verify upload

### Week 2-4: Ramp to Production

4. **Complete skill suite:**
   - script-writer, scene-planner, video-assembler
   - youtube-analytics, reflection

5. **Begin publishing:**
   - Week 2: 1 Short/day (7 total)
   - Week 3: 2 Shorts/day (14 total)
   - Week 4: 3 Shorts/day (21 total)

6. **Establish analytics:**
   - Daily metrics collection
   - Weekly reflection runs
   - Build initial knowledge base

### Month 2+: Scale and Optimize

7. **Execute roadmap** as outlined in Phase 1-5 above
8. **Iterate based on data** from reflection skill
9. **Prepare for seasonal campaigns** (check festival calendar)

---

## Documentation Structure

```
docs/
├── MASTER_PLAN.md (this file)
└── research/
    ├── platform/
    │   └── youtube-shorts-analysis.md
    ├── monetization/
    │   ├── content-longevity.md
    │   ├── timeline-strategy.md
    │   └── seasonal-revenue.md
    └── technical/
        ├── api-aggregation.md
        ├── skills-structure.md
        └── analytics-architecture.md
```

**Research documents** contain detailed analysis and rationale for strategic decisions. Reference them as needed, but this master plan is the primary execution guide.

---

## Key Principles for Execution

1. **Quality over quantity**: 70%+ retention is non-negotiable
2. **Data-driven iteration**: Let reflection skill guide optimization
3. **Seasonal leverage**: Plan 2-3 weeks ahead for festivals
4. **Progressive disclosure**: Load research docs only when needed
5. **Human oversight**: Review before publish (at least initially)
6. **Engagement priority**: First hour after upload is critical
7. **Long-term memory**: Build knowledge base continuously

---

**Status**: Planning complete. Ready for implementation.
**Next**: Create `.claude/skills/` structure and build first skill (idea-generator).
