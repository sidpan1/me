# Phase 0: Validation Sprint

**Purpose**: Validate core assumptions before $700+ commitment to full system

**Timeline**: 2 weeks
**Budget**: $50-100
**Time Commitment**: 10-15 hours
**Decision**: GO/NO-GO/PIVOT

---

## Week 1: Market & Content Validation

### Day 1-2: Competitive Analysis (4 hours, $0)

**Objective**: Understand the rangoli content landscape

**Tasks:**
1. Find top 20 rangoli Shorts on YouTube
   - Search: "rangoli", "rangoli design", "satisfying rangoli"
   - Filter: Shorts, uploaded last 6 months
   - Track: Views, likes, comments, channel size

2. Analyze performance patterns
   ```
   For each video, record:
   - Views in first 48 hours (estimate from upload date)
   - Total views
   - Engagement rate (likes + comments / views)
   - Channel subscriber count
   - Video length
   - Style (traditional, modern, ASMR, festival-specific)
   ```

3. Calculate benchmarks
   - Average views per video
   - Average engagement rate
   - Best performing style/theme
   - Subscriber conversion pattern

4. Competitive density check
   - How many active rangoli creators?
   - How often do they post?
   - Quality level (professional, amateur, AI?)
   - Market saturation assessment

**Deliverable**: `data/market-analysis.md` with findings

**Success Criteria**:
- ✅ Top videos average >100k views
- ✅ Engagement rates >4%
- ✅ Less than 10 highly active competitors
- ✅ Clear gap for AI-generated content

**Warning Signs**:
- ⚠️ Top videos <50k views (low demand)
- ⚠️ Engagement <2% (weak niche)
- ⚠️ 20+ active competitors (saturated)

---

### Day 3: Search Volume & Trend Analysis (2 hours, $0)

**Objective**: Validate audience demand and seasonality

**Tasks:**
1. Google Trends research
   - "rangoli" search volume (India, last 2 years)
   - Compare: "rangoli", "kolam", "mehendi", "mandala"
   - Identify seasonal spikes (validate festival hypothesis)

2. YouTube search volume
   - YouTube autocomplete for "rangoli..."
   - Related searches
   - Suggested content patterns

3. Social media check
   - Instagram #rangoli hashtag volume
   - Pinterest "rangoli" search popularity
   - TikTok equivalent (if accessible)

**Deliverable**: `data/demand-analysis.md`

**Success Criteria**:
- ✅ Clear seasonal spikes during festivals
- ✅ Consistent baseline search volume
- ✅ Growing or stable trend (not declining)

**Warning Signs**:
- ⚠️ Declining search trend
- ⚠️ No clear seasonal patterns
- ⚠️ Low overall search volume

---

### Day 4-5: Create Test Videos (4 hours, $8-12)

**Objective**: Validate fal.ai quality and AI content viability

**Test Video 1: Traditional Rangoli**
```python
# Prompt for Veo 3.1 Fast
prompt = """
Overhead shot of hands creating a traditional Indian rangoli pattern
on the floor using colored powder. Start with the center point and
gradually build outward in symmetrical circular patterns. Vibrant
colors: red, yellow, orange, green. Clean white floor background.
Smooth, satisfying movements. ASMR quality. 9:16 vertical format.
"""
duration = 8 seconds
```

**Test Video 2: Modern Rangoli**
```python
prompt = """
Close-up of creating a modern geometric rangoli design with neon colors.
Fast-paced, energetic. Hands moving quickly, filling patterns. Trendy
color palette: pink, purple, cyan, yellow. Contemporary music vibes.
9:16 vertical.
"""
duration = 8 seconds
```

**Test Video 3: Festival ASMR Rangoli**
```python
prompt = """
Slow-motion ASMR-style Diwali rangoli creation. Extreme close-up of
colored powder being poured through fingers to create intricate patterns.
Focus on the satisfying sound and visual of powder cascading. Warm
festival colors: gold, orange, red. 9:16 vertical. Calming, meditative.
"""
duration = 8 seconds
```

**Assembly:**
- Use simple video editor or Remotion
- Add text overlay: "Satisfying Rangoli Design #Shorts"
- Background music (royalty-free ASMR or traditional)
- 30-second total length

**Deliverable**: 3 complete 30-second Shorts, unlisted on YouTube

**Cost**: ~$2.66 × 3 = $8 (if using fal.ai as planned)

---

### Day 6: Gather Initial Feedback (2 hours, $0)

**Objective**: Get qualitative feedback before public publishing

**Tasks:**
1. Share unlisted videos with 20-30 people
   - Target demographic: Indian, 18-35, social media users
   - Ask specific questions:
     - Would you watch this video completely?
     - Would you like/comment/share?
     - Does it look AI-generated? (perception test)
     - Which of the 3 do you prefer?

2. Tools:
   - WhatsApp groups
   - Reddit r/India or relevant communities
   - Friends/family in target demo
   - Discord/Telegram groups

3. Collect feedback
   - Quantitative: "Rate 1-10 how likely you'd engage"
   - Qualitative: Open feedback on quality, appeal, style

**Deliverable**: `data/user-feedback.md`

**Success Criteria**:
- ✅ Average rating >7/10
- ✅ >60% would watch to completion
- ✅ Positive comments on quality
- ✅ At least 1 video strongly preferred

**Warning Signs**:
- ⚠️ Average rating <5/10
- ⚠️ Complaints about AI quality/"looks fake"
- ⚠️ Low completion intent

---

### Day 7: Week 1 Analysis (2 hours, $0)

**Objective**: Synthesize findings and make initial decision

**Tasks:**
1. Consolidate data
   - Market analysis results
   - Demand validation results
   - Test video feedback

2. Calculate viability score
   ```
   Market Score (0-10):
   - Demand: High (3), Medium (2), Low (1)
   - Competition: Low (3), Medium (2), High (1)
   - Engagement benchmarks: >5% (4), 3-5% (2), <3% (1)

   Content Score (0-10):
   - User feedback: >7/10 (5), 5-7/10 (3), <5/10 (1)
   - AI quality perception: Good (3), Okay (2), Poor (1)
   - Completion intent: >70% (2), 50-70% (1), <50% (0)

   Total Score: /20

   18-20: Strong GO
   14-17: Moderate GO (with adjustments)
   10-13: PIVOT (test different theme)
   <10: NO-GO (fundamental issues)
   ```

3. Document decision
   - What did we learn?
   - What needs adjustment?
   - Proceed, pivot, or stop?

**Deliverable**: `WEEK1_DECISION.md`

---

## Week 2: Technical Validation

### Day 8-9: API Integration Testing (3 hours, $10-20)

**Objective**: Validate technical feasibility before building full system

**Tasks:**

1. **Test fal.ai programmatically**
   ```python
   import fal_client

   # Test video generation
   result = fal_client.subscribe(
       "fal-ai/veo3.1/fast",
       arguments={
           "prompt": "Your rangoli prompt",
           "duration": 8,
           "aspect_ratio": "9:16",
       }
   )

   # Track:
   # - Generation time
   # - Success rate
   # - Output quality
   # - Actual cost
   ```

2. **Test FLUX image generation**
   ```python
   # For thumbnails or static scenes
   image = fal_client.subscribe(
       "fal-ai/flux/dev",
       arguments={
           "prompt": "Colorful rangoli pattern overhead view",
           "image_size": "1080x1920"
       }
   )
   ```

3. **Test ElevenLabs voice**
   ```python
   # For voiceover if needed
   audio = fal_client.subscribe(
       "fal-ai/elevenlabs/tts",
       arguments={
           "text": "देखिए यह सुंदर रंगोली डिजाइन",  # Hindi
           "voice": "hindi_male_1"
       }
   )
   ```

4. **Measure performance**
   - Average generation time per asset
   - Success/failure rate
   - Retry logic needed?
   - Quality consistency

**Deliverable**:
- `scripts/test_fal_integration.py`
- `data/api-performance.md`

**Success Criteria**:
- ✅ 95%+ success rate
- ✅ <5 min generation time per video
- ✅ Consistent quality output
- ✅ Cost within 10% of projection ($2.66)

---

### Day 10-11: YouTube API Testing (3 hours, $0)

**Objective**: Validate upload automation works

**Tasks:**

1. **Set up YouTube OAuth 2.0**
   - Create Google Cloud project
   - Enable YouTube Data API v3
   - Generate OAuth credentials
   - Test authentication flow

2. **Test video upload**
   ```python
   from googleapiclient.discovery import build
   from google.oauth2.credentials import Credentials

   # Upload test video
   youtube = build('youtube', 'v3', credentials=creds)

   request = youtube.videos().insert(
       part="snippet,status",
       body={
           "snippet": {
               "title": "Test Rangoli Design #Shorts",
               "description": "AI-generated...",
               "tags": ["rangoli", "satisfying", "shorts"],
               "categoryId": "22"  # People & Blogs
           },
           "status": {
               "privacyStatus": "unlisted"  # Test unlisted first
           }
       },
       media_body="test_video.mp4"
   )
   ```

3. **Test metadata optimization**
   - Title variations
   - Description with disclosure
   - Tags and hashtags
   - Thumbnail upload

4. **Test analytics retrieval**
   - Can we pull metrics programmatically?
   - What data is available?
   - Delay in data availability?

**Deliverable**:
- `scripts/test_youtube_upload.py`
- `config/youtube_oauth.json` (template)
- `data/upload-test-results.md`

**Success Criteria**:
- ✅ OAuth flow works smoothly
- ✅ Upload succeeds without errors
- ✅ Metadata applied correctly
- ✅ Analytics API accessible

---

### Day 12: Build Minimal Viable Pipeline (4 hours, $3)

**Objective**: Create 1 complete video end-to-end, fully automated

**Tasks:**

1. **Simple idea generator**
   ```python
   # Just a template for now, not full Claude Code skill
   def generate_idea():
       themes = [
           "Traditional Diwali rangoli",
           "Modern geometric rangoli",
           "Floral rangoli design",
           "Festival kolam pattern"
       ]
       return random.choice(themes)
   ```

2. **Asset generation pipeline**
   ```python
   def generate_video_assets(idea):
       # Generate video clips with fal.ai
       clips = generate_video_clips(idea)
       # Generate thumbnail
       thumbnail = generate_thumbnail(idea)
       # Generate music/audio (if needed)
       return clips, thumbnail
   ```

3. **Simple assembly**
   - Concatenate clips
   - Add text overlay
   - Add music
   - Export as MP4

4. **Upload to YouTube**
   - Automated upload with metadata
   - Set as unlisted
   - Track upload success

**Deliverable**:
- 1 complete video created fully programmatically
- `scripts/mvp_pipeline.py`

**Success Criteria**:
- ✅ End-to-end automation works
- ✅ No manual intervention needed
- ✅ Output quality matches test videos
- ✅ Total time <30 minutes

---

### Day 13: Publish Real Test (2 hours, $0)

**Objective**: Publish 1 video publicly and track initial performance

**Tasks:**

1. **Select best video from Week 1 or new MVP video**

2. **Optimize for publishing**
   - Best title from A/B ideas
   - Optimized description with AI disclosure
   - Strategic tags and hashtags
   - Eye-catching thumbnail

3. **Publish as public Short**
   - Set as public
   - Note exact publish time
   - Set up tracking spreadsheet

4. **Initial promotion**
   - Share on personal social media (optional)
   - Post in relevant communities (optional)
   - Or let it be purely organic

5. **Track 48-hour performance**
   ```
   Hour 1: ___ views, ___ engagement
   Hour 6: ___ views, ___ engagement
   Hour 24: ___ views, ___ engagement
   Hour 48: ___ views, ___ engagement

   Retention rate: ___%
   Engagement rate: ___%
   CTR: ___%
   ```

**Deliverable**: `data/first-video-performance.md`

**Success Criteria** (48-hour metrics):
- ✅ 500+ views (decent organic reach)
- ✅ 60%+ retention
- ✅ 5%+ engagement rate
- ✅ Positive comments (if any)

**Warning Signs**:
- ⚠️ <100 views (poor distribution)
- ⚠️ <40% retention (not engaging)
- ⚠️ <2% engagement (weak content)
- ⚠️ Negative comments about quality

---

### Day 14: Final Decision (2 hours, $0)

**Objective**: Make GO/NO-GO/PIVOT decision with full data

**Tasks:**

1. **Consolidate all validation data**
   - Week 1: Market + content validation
   - Week 2: Technical + performance validation

2. **Calculate final score**
   ```
   Market Validation (0-30):
   - Competitive analysis: ___/10
   - Demand validation: ___/10
   - User feedback: ___/10

   Technical Validation (0-30):
   - API integration: ___/10
   - YouTube automation: ___/10
   - MVP pipeline: ___/10

   Performance Validation (0-40):
   - First video views: ___/15
   - Retention rate: ___/10
   - Engagement rate: ___/10
   - Cost accuracy: ___/5

   TOTAL: ___/100

   80-100: Strong GO - Execute full plan
   60-79: Moderate GO - Execute with adjustments
   40-59: PIVOT - Change theme or approach
   <40: NO-GO - Fundamental issues, stop or major rethink
   ```

3. **Document decision**
   ```markdown
   # Validation Sprint Results

   ## Score: __/100

   ## Decision: GO / PIVOT / NO-GO

   ## Key Learnings:
   - What worked:
   - What didn't work:
   - Surprises:

   ## Adjustments Needed:
   - Theme:
   - Style:
   - Frequency:
   - Budget:

   ## Next Steps:
   If GO:
   - Build skill 1: ___
   - Timeline adjustment: ___
   - Budget adjustment: ___

   If PIVOT:
   - New theme to test: ___
   - Validation approach: ___

   If NO-GO:
   - Reason:
   - Alternative considered:
   - Lessons learned:
   ```

**Deliverable**: `VALIDATION_DECISION.md` (final report)

---

## Decision Framework

### GO Criteria (Proceed to Full Execution)

**Must have ALL of these:**
- ✅ Validation score >60/100
- ✅ At least one test video >60% retention
- ✅ Technical pipeline works end-to-end
- ✅ Cost within 20% of projection
- ✅ No major technical blockers

**Strong GO (>80/100):**
- Proceed with original aggressive timeline
- Budget: $700 for 3-month plan
- Confidence: High

**Moderate GO (60-79/100):**
- Proceed with conservative timeline
- Budget: $550 for 6-month plan
- Make noted adjustments
- Confidence: Medium

---

### PIVOT Criteria (Change Theme/Approach)

**If any of these:**
- ⚠️ Validation score 40-59/100
- ⚠️ Rangoli niche appears saturated
- ⚠️ Retention consistently <50%
- ⚠️ Better opportunity identified during research

**Pivot Options:**
1. Different satisfying theme (mehendi, clay art, mandala)
2. Different cultural content (cooking, crafts)
3. Different format (educational, storytelling)
4. Different language (focus on specific region)

**Pivot Process:**
- Run mini-validation (3-5 days, $20)
- Test new theme with 1-2 videos
- Compare to rangoli results
- Make final decision

---

### NO-GO Criteria (Stop or Major Rethink)

**If any of these:**
- ❌ Validation score <40/100
- ❌ All test videos <40% retention
- ❌ Engagement consistently <2%
- ❌ Major technical blockers (API issues, YouTube restrictions)
- ❌ Cost 2x+ projection
- ❌ Niche fundamentally flawed (no demand or oversaturated)

**Options if NO-GO:**
1. **Stop entirely**
   - Lessons learned documented
   - Minimal loss ($50-100 validation cost)
   - Time saved (avoided $700 investment in wrong direction)

2. **Major rethink**
   - Different platform (Instagram, TikTok)
   - Different content type (not short-form)
   - Different approach (manual vs AI)
   - Different business model (SaaS vs own channel)

---

## Budget Tracking

### Validation Sprint Budget

| Item | Cost | Status |
|------|------|--------|
| Test videos (3×$2.66) | $8 | |
| API testing | $10-20 | |
| MVP pipeline video | $3 | |
| Market research | $0 | |
| Technical setup | $0 | |
| **TOTAL** | **$21-31** | |

**Contingency**: +$20-70 for unexpected costs → **$50-100 max**

---

## Success Definition

**This validation sprint is successful if:**
1. We learn whether rangoli + AI = viable business (YES or NO is both success)
2. We avoid investing $700 in unvalidated assumptions
3. We have clear data to make GO/NO-GO/PIVOT decision
4. We identify specific adjustments needed if proceeding
5. We build working proof of concept (if GO)

**This validation sprint fails if:**
1. We don't gather sufficient data to decide
2. We skip steps to rush to execution
3. We ignore warning signs in the data
4. We proceed without clear success criteria

---

## Timeline Summary

```
Week 1: Market & Content Validation
├─ Day 1-2: Competitive analysis (4h)
├─ Day 3: Demand validation (2h)
├─ Day 4-5: Create 3 test videos (4h, $8)
├─ Day 6: User feedback (2h)
└─ Day 7: Week 1 analysis (2h)

Week 2: Technical Validation
├─ Day 8-9: API integration testing (3h, $10-20)
├─ Day 10-11: YouTube API testing (3h)
├─ Day 12: MVP pipeline (4h, $3)
├─ Day 13: Publish real test (2h)
└─ Day 14: Final decision (2h)

Total: 28 hours, $21-31
```

---

## Next Actions After Validation

### If GO:
→ Proceed to **Week 3: Build Core Skills** as outlined in revised master plan
→ Adjust budget/timeline based on validation learnings
→ Implement incrementally with continued measurement

### If PIVOT:
→ Run mini-validation on new theme (3-5 days)
→ Compare results
→ Make final decision

### If NO-GO:
→ Document lessons learned
→ Consider alternative business models
→ Celebrate avoiding $700 loss on wrong path

---

**The validation sprint is the missing 20% that makes this plan execution-ready.**
