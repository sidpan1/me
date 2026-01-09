# Autonomous Video Generation System

An AI-powered system that autonomously generates, publishes, and optimizes YouTube Shorts targeting Indian audiences.

## Overview

This project uses Claude Code to run an autonomous loop:
- 📹 Generate video ideas based on trends and analytics
- ✍️ Write optimized scripts for maximum retention
- 🎨 Create visual assets using AI (Veo 3, DALL-E 3)
- 🎵 Add voiceover and music (ElevenLabs, Soundverse)
- 🎬 Assemble videos programmatically (Remotion)
- 📤 Publish to YouTube Shorts automatically
- 📊 Collect and analyze performance data
- 🔄 Self-improve based on what works

**Target:** "Satisfying videos" for Indian consumers (Hindi + regional languages)
**Platform:** YouTube Shorts (5.9% engagement rate, clear monetization)
**Schedule:** Automated daily generation via GitHub Actions or cron

## Quick Start

### Prerequisites

- Node.js 18+ (for Remotion)
- Python 3.11+ (for API clients)
- Claude Code CLI
- Git & GitHub account (for automated workflows)

### 1. Clone and Setup

```bash
cd autonomous-video-generation
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

cd src/video/remotion
npm install
cd ../../..
```

### 2. Configure API Keys

Copy `config/api_keys.env.example` to `config/api_keys.env` and fill in:

```bash
ANTHROPIC_API_KEY=your_claude_api_key
VEO3_API_KEY=your_veo3_api_key  # via Kie.ai or fal.ai
ELEVENLABS_API_KEY=your_elevenlabs_key
OPENAI_API_KEY=your_openai_key  # for DALL-E 3
SOUNDVERSE_API_KEY=your_soundverse_key
YOUTUBE_CLIENT_ID=your_youtube_client_id
YOUTUBE_CLIENT_SECRET=your_youtube_client_secret
```

### 3. YouTube OAuth Setup

Run the OAuth setup script to authenticate:

```bash
python scripts/setup_oauth.py
```

This will open a browser, ask for permissions, and save your refresh token to `config/youtube_oauth.json`.

### 4. Initialize Claude Code

```bash
claude init
```

This will set up Claude Code in the project directory.

### 5. Generate Your First Video

```bash
claude /generate-video
```

Claude will walk through the entire workflow:
- Generate video ideas
- Select the best one
- Write an optimized script
- Generate assets (video clips, voiceover, music)
- Assemble with Remotion
- Upload to YouTube
- Log the video for analytics tracking

### 6. Set Up Automation (Optional)

**Option A: GitHub Actions (Recommended)**

1. Add secrets to your GitHub repository:
   - Settings → Secrets → Actions → New repository secret
   - Add all API keys from your `.env` file

2. Push the repository to GitHub

3. The workflow in `.github/workflows/daily-video-generation.yml` will run daily at 6 AM IST

**Option B: Cron (Local/Server)**

```bash
crontab -e
# Add this line:
30 0 * * * cd /path/to/autonomous-video-generation && ./scripts/daily_generation.sh
```

## Project Structure

```
autonomous-video-generation/
├── .claude/
│   ├── skills/              # Claude Code skills for video generation
│   ├── hooks/               # Lifecycle hooks
│   └── commands/            # Custom slash commands
├── src/
│   ├── generators/          # Ideation, scripting, scene planning
│   ├── api_clients/         # Veo3, ElevenLabs, DALL-E, etc.
│   ├── video/remotion/      # Programmatic video assembly
│   ├── publishing/          # YouTube upload and OAuth
│   └── analytics/           # Data collection and analysis
├── data/
│   ├── videos/              # Generated video files
│   ├── assets/              # Images, audio, clips
│   ├── analytics/           # Performance data
│   └── performance_log.json # Historical performance tracking
├── config/
│   ├── api_keys.env         # API credentials (not in git)
│   └── generation_params.yaml # Video generation settings
├── scripts/
│   ├── daily_generation.sh  # Cron script
│   └── setup_oauth.py       # YouTube OAuth helper
├── MASTER_PLAN.md           # Complete implementation guide
└── README.md                # This file
```

## Key Features

### 🎯 Optimized for Indian Audience
- Regional language support (Hindi, Tamil, Telugu, etc.)
- Cultural relevance in content selection
- 95% of Indian short-form consumption is regional (2x engagement)

### 📈 Data-Driven Optimization
- Tracks 10+ performance metrics per video
- Identifies patterns in successful content
- Automatically adjusts generation parameters
- A/B testing capabilities

### 💰 Monetization Ready
- Optimized for YouTube Partner Program requirements
- Clear path to 1,000 subs + 10M views in 90 days
- Expected ROI: Break-even in 6-9 months

### 🤖 Fully Autonomous
- Runs on schedule without human intervention
- Self-improves based on analytics
- Handles errors and retries
- Logs all operations for transparency

## Cost Breakdown

**Per Video (Medium Quality):**
- Video generation (Veo 3): $1.60
- Voiceover (ElevenLabs): $0.01
- Music (Soundverse): $0.10
- Claude API: $0.15
- **Total: ~$1.94/video**

**Monthly (30 videos):** ~$58/month
**Budget tier:** ~$40/month (using Veo 3 Fast)

## Performance Targets

**Video-Level:**
- Average View Duration: 50%+ (15+ seconds)
- Engagement Rate: 5.9%+ (YouTube Shorts benchmark)
- CTR: 8%+
- Views (first 24h): 1,000+

**Channel-Level:**
- Month 1-2: Test and refine, 500+ views/video avg
- Month 3-4: 500 subscribers, 5,000+ views/video
- Month 5-6: 1,000 subscribers, monetization enabled
- Month 12: 50k-100k subscribers, profitable

## Roadmap

- **Phase 1 (Month 1-2):** Foundation - daily uploads, data collection
- **Phase 2 (Month 3-4):** Optimization - A/B testing, theme refinement
- **Phase 3 (Month 5-6):** Monetization push - scale to 1k subs
- **Phase 4 (Month 7+):** Multi-platform expansion (Instagram Reels)
- **Phase 5 (Month 9+):** Theme diversification (food, art, crafts)
- **Phase 6 (Month 12+):** Full autonomy, multi-language, advanced AI

## Documentation

- **[MASTER_PLAN.md](MASTER_PLAN.md)**: Complete implementation guide (10,000+ words)
- **Skills Documentation**: See `.claude/skills/` for individual workflow steps
- **API Integration Guides**: See `src/api_clients/README.md`

## Support & Contributing

This is a personal autonomous project, but learnings will be documented for the community.

**Questions?** Open an issue or discussion on GitHub.

## License

MIT License - See LICENSE file for details.

---

**Built with Claude Code** 🚀
*Autonomous content creation for the AI era*
