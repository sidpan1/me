# Quick Start Guide - Autonomous Video Generation

This guide will get you from zero to your first generated video in under 1 hour.

## Step-by-Step Setup

### Step 1: Get Your API Keys (15 minutes)

You'll need accounts and API keys for these services:

#### 1. Anthropic (Claude)
- Go to: https://console.anthropic.com/
- Sign up and navigate to API Keys
- Create a new key
- **Cost:** Pay-as-you-go, ~$0.15 per video

#### 2. Google Veo 3 (via Kie.ai - Easiest Option)
- Go to: https://kie.ai/
- Sign up for an account
- Navigate to API section
- Get your API key
- **Cost:** $0.40 per 8-second clip (Veo 3 Fast)

**Alternative:** Use fal.ai or official Vertex AI (more complex setup)

#### 3. ElevenLabs (Voice)
- Go to: https://elevenlabs.io/
- Sign up (free tier available: 10k chars/month)
- Get API key from Profile → API Keys
- **Cost:** Free tier sufficient for testing, $5/mo for production

#### 4. OpenAI (DALL-E 3 for images)
- Go to: https://platform.openai.com/
- Sign up and add payment method
- Create API key
- **Cost:** ~$0.04-0.12 per image

#### 5. Soundverse (Music)
- Go to: https://www.soundverse.ai/
- Sign up for account
- Get API access (check their API documentation)
- **Cost:** TBD (check their pricing page)

**Alternative for Music:** Use royalty-free music libraries initially (Epidemic Sound, Artlist)

#### 6. YouTube (OAuth for uploads)
- Go to: https://console.cloud.google.com/
- Create a new project
- Enable "YouTube Data API v3"
- Create OAuth 2.0 credentials (Desktop app)
- Download client secrets JSON
- **Cost:** Free

### Step 2: Install Dependencies (10 minutes)

```bash
# Navigate to project directory
cd autonomous-video-generation

# Python setup
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install Python packages
pip install -r requirements.txt

# Node.js setup (for Remotion)
cd src/video/remotion
npm install
cd ../../..
```

**What gets installed:**
- Python: `google-api-python-client`, `requests`, `anthropic`, `elevenlabs`, etc.
- Node: `remotion`, `react`, video rendering dependencies

### Step 3: Configure Environment (5 minutes)

Create `config/api_keys.env`:

```bash
# Copy the example file
cp config/api_keys.env.example config/api_keys.env

# Edit with your favorite editor
nano config/api_keys.env  # or vim, code, etc.
```

Fill in your API keys:

```bash
# Anthropic
ANTHROPIC_API_KEY=sk-ant-xxxxx

# Video Generation
VEO3_API_KEY=kie_xxxxx
VEO3_PROVIDER=kie  # or "fal" or "vertex"

# Voice
ELEVENLABS_API_KEY=xxxxx

# Images
OPENAI_API_KEY=sk-xxxxx

# Music
SOUNDVERSE_API_KEY=xxxxx

# YouTube (we'll set this up next)
YOUTUBE_CLIENT_ID=xxxxx.apps.googleusercontent.com
YOUTUBE_CLIENT_SECRET=xxxxx
```

### Step 4: YouTube Authentication (10 minutes)

This is the most complex part, but we've automated it:

```bash
# Run the OAuth setup script
python scripts/setup_oauth.py
```

**What happens:**
1. Script opens your browser
2. You log in to Google
3. You authorize the app to upload videos
4. Script saves your refresh token to `config/youtube_oauth.json`

**Troubleshooting:**
- Make sure you enabled YouTube Data API v3 in Google Cloud Console
- Ensure OAuth consent screen is configured
- Add yourself as a test user if app is in testing mode

### Step 5: Generate Your First Video! (20 minutes)

```bash
# Make sure you're in the project directory
cd autonomous-video-generation

# Activate virtual environment if not already active
source venv/bin/activate

# Initialize Claude Code (first time only)
claude init

# Run the video generation workflow
claude -p "Generate one satisfying video for Indian audience using the complete workflow: idea generation, scripting, asset creation, assembly, and upload to YouTube"
```

**What Claude will do:**
1. Generate a video idea (e.g., "Perfect domino chain reaction")
2. Write an optimized script with precise timing
3. Generate visual assets:
   - Call Veo 3 API to create video clips
   - Call ElevenLabs for voiceover (if needed)
   - Get background music
4. Create a Remotion project and assemble the video
5. Render the final MP4
6. Upload to YouTube Shorts
7. Log the video for future analytics

**Time:** 15-20 minutes for first generation (mostly API processing)

### Step 6: Check Your Video!

1. Go to YouTube Studio: https://studio.youtube.com/
2. Navigate to Content
3. Find your newly uploaded Short
4. Check:
   - Video quality (1080x1920, vertical)
   - Audio levels
   - Text overlays
   - Retention curve (after 24-48 hours)

### Step 7: Set Up Daily Automation (10 minutes)

#### Option A: GitHub Actions (Easiest)

```bash
# Initialize git if not already done
git init
git add .
git commit -m "Initial commit - Autonomous video generation system"

# Create GitHub repository (via gh CLI or web interface)
gh repo create autonomous-video-generation --private --source=. --push

# Add secrets to GitHub
gh secret set ANTHROPIC_API_KEY < (echo "your_key_here")
gh secret set VEO3_API_KEY < (echo "your_key_here")
# ... repeat for all API keys
```

**Or via GitHub web interface:**
1. Go to your repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add each API key from your `.env` file

The workflow in `.github/workflows/daily-video-generation.yml` will now run daily at 6 AM IST.

#### Option B: Cron (Local/Server)

```bash
# Make the script executable
chmod +x scripts/daily_generation.sh

# Edit crontab
crontab -e

# Add this line (runs at 6 AM IST = 00:30 UTC)
30 0 * * * cd /full/path/to/autonomous-video-generation && ./scripts/daily_generation.sh >> logs/cron.log 2>&1
```

### Step 8: Monitor Performance (Ongoing)

After 24 hours, collect analytics:

```bash
python src/analytics/collector.py
```

Check `data/performance_log.json` to see:
- Views, watch time, retention
- Engagement rate, CTR
- Performance score

Claude will use this data to improve future videos!

---

## Troubleshooting Common Issues

### "API key invalid" error
- Double-check you copied the entire key
- Ensure no extra spaces in `.env` file
- Verify the API key is active in the provider's dashboard

### "YouTube upload failed"
- Check OAuth token is valid: `python scripts/setup_oauth.py` (re-authenticate)
- Ensure YouTube Data API v3 is enabled
- Verify quota limits (50 uploads/day default)

### "Remotion render failed"
- Ensure Node.js 18+ is installed: `node --version`
- Check all dependencies installed: `cd src/video/remotion && npm install`
- Try manual render: `npx remotion preview` to debug

### "Veo 3 generation taking too long"
- Each 8-second clip takes 2-5 minutes to generate
- This is normal - Veo 3 is compute-intensive
- Use Veo 3 Fast ($0.40) instead of Quality ($2.00) for faster generation

### "Out of API credits"
- Check your balance on each platform
- Start with free tiers (ElevenLabs has 10k chars free)
- Use budget mode initially (see MASTER_PLAN.md for cost optimization)

---

## Next Steps

### Day 1: First Video
- ✅ Generate and upload first video
- ✅ Verify it appears in YouTube Studio
- ✅ Check video quality and format

### Day 2-7: Daily Generation
- Set up automation (GitHub Actions or cron)
- Generate 1 video per day
- Monitor uploads are successful

### Week 2: Analyze & Optimize
- Collect analytics data
- Identify which video performed best
- Ask Claude: "Analyze performance_log.json and suggest optimizations"
- Implement improvements

### Week 3-4: Scale
- Increase to 2 videos/day (if budget allows)
- Test A/B variations (different hooks, themes)
- Refine targeting based on data

### Month 2+: Growth Phase
- Follow the roadmap in MASTER_PLAN.md
- Expand themes based on what works
- Work toward monetization threshold (1k subs + 10M views)

---

## Cost for First Week

**Setup (One-time):**
- API account creation: $0
- Initial testing: ~$5-10

**7 Videos (Daily):**
- 7 videos × $1.94 = **~$13.58**

**Total Week 1:** ~$18-23

**Recommended:** Start with $50 budget to comfortably test for 3-4 weeks.

---

## Getting Help

**Technical Issues:**
- Check `logs/` directory for error messages
- Review MASTER_PLAN.md for detailed documentation
- GitHub Issues (if repository is public)

**Claude Code Questions:**
- Claude Code docs: https://code.claude.com/docs
- Ask Claude directly: "How do I [specific task]?"

**Video Strategy:**
- Analyze competitor content manually
- Use YouTube trends: https://www.youtube.com/feed/trending
- Focus on Indian trending Shorts

---

## Success Checklist

- [ ] All API keys obtained and configured
- [ ] YouTube OAuth set up and working
- [ ] First video generated successfully
- [ ] Video uploaded to YouTube
- [ ] Automation configured (GitHub Actions or cron)
- [ ] Analytics collection tested
- [ ] Performance log tracking working
- [ ] Ready for daily autonomous generation!

**You're now running an autonomous content creation system!** 🎉

The system will:
- Generate videos daily
- Upload automatically
- Collect performance data
- Improve over time based on what works

Your job: Monitor weekly, guide strategy, celebrate milestones.

---

*Need help? Review MASTER_PLAN.md for comprehensive details on every step.*
