# fal.ai Integration Guide - Simplified AI API Access

## Executive Summary

**fal.ai eliminates the complexity of managing multiple AI providers** by offering 600+ models through a single API. For the autonomous video generation MVP, this means:

✅ **One API key** instead of 5+
✅ **One SDK** instead of multiple integrations
✅ **One bill** instead of tracking multiple invoices
✅ **Lower total cost** than individual providers
✅ **Faster development** - focus on content, not API management

---

## Why fal.ai for MVP

### Complexity Reduction

**WITHOUT fal.ai (Original Plan):**
```
API Integrations Needed:
1. Google Vertex AI (Veo 3) - Complex OAuth, GCP setup
2. OpenAI (DALL-E 3) - Separate API key, rate limits
3. ElevenLabs (Voice) - Another API key, billing
4. Soundverse (Music) - Yet another integration
5. (Future) Runway, Kling, etc. - More complexity

Total: 5+ API keys, 5+ billing accounts, 5+ error handling systems
```

**WITH fal.ai:**
```
Single Integration:
- fal.ai API key
- Unified SDK (@fal-ai/client)
- Single billing dashboard

Total: 1 API key, 1 billing account, 1 error handling system
```

**Development Time Saved:** 40-60% less integration work

### Cost Comparison

| Component | Direct Provider | fal.ai | Savings/Cost |
|-----------|----------------|--------|--------------|
| **Veo 3.1 Fast (10s)** | $2.50 | $1.00-1.50 | **-40-60%** ✅ |
| **FLUX [dev] Image** | $0.04 (via OpenAI) | $0.025 | **-38%** ✅ |
| **ElevenLabs Voice** | Direct access | Same pricing | No change |
| **Background Music** | Soundverse | fal.ai options | Comparable |
| **Infrastructure** | Self-managed | Managed (99.99% uptime) | **Value add** ✅ |

**Per-Video Cost with fal.ai:**
- Video (10s Veo 3.1 Fast): $1.00-1.50
- Images (5 frames, FLUX): $0.13
- Voice (30s, ElevenLabs): $0.01
- Music (30s, Sonauto): $0.05
- **Total: ~$1.19-1.69/video** (vs $1.94 original estimate)

**Savings: ~25-40% cost reduction** ✅

### Models Available

**Video Generation:**
- ✅ Veo 3.1 Fast ($0.10/sec, audio off)
- ✅ Veo 3.1 Standard ($0.20/sec, audio off)
- ✅ LTX Video 2.0 Pro ($0.06-0.24/sec)
- ✅ Kling 2.6 Pro (advanced cinematic)

**Image Generation:**
- ✅ FLUX [dev] ($0.025/image) - **RECOMMENDED**
- ✅ FLUX 1.1 Pro (same price, higher quality)
- ✅ Stable Diffusion XL (budget option)
- ✅ Nano Banana Pro (Google's latest)
- ❌ DALL-E (OpenAI exclusive) - Use FLUX instead

**Voice/Audio:**
- ✅ ElevenLabs TTS Turbo v2.5 (low latency)
- ✅ ElevenLabs Multilingual v2 (29 languages)
- ✅ Speech-to-text, audio isolation

**Music:**
- ✅ Sonauto V2 (commercial-use rights) - **RECOMMENDED**
- ✅ ElevenLabs Music
- ✅ MiniMax Music (Hailuo AI)
- ✅ CassetteAI (fast generation)

---

## Integration Architecture

### Skill Structure with fal.ai

**asset-generator Skill (Updated):**

```
.claude/skills/asset-generator/
├── SKILL.md
├── scripts/
│   ├── generate_assets.py           # Main orchestrator
│   ├── api_clients/
│   │   └── fal_client.py            # SINGLE unified client
│   ├── video_generator.py           # Uses fal for Veo 3.1
│   ├── image_generator.py           # Uses fal for FLUX
│   ├── voice_generator.py           # Uses fal for ElevenLabs
│   └── music_generator.py           # Uses fal for Sonauto
└── references/
    └── fal-api-docs.md
```

**Before (Multiple Clients):**
```python
from veo3_client import Veo3Client
from openai import OpenAI
from elevenlabs import ElevenLabs
from soundverse import Soundverse

veo = Veo3Client(api_key=VEO3_KEY)
dalle = OpenAI(api_key=OPENAI_KEY)
voice = ElevenLabs(api_key=ELEVENLABS_KEY)
music = Soundverse(api_key=SOUNDVERSE_KEY)
```

**After (Single Client):**
```python
import fal_client

# One client for everything
fal_client.api_key = FAL_KEY
```

---

## Code Examples

### Video Generation (Veo 3.1 Fast)

```python
import fal_client

def generate_video_clip(prompt: str, duration: int = 8):
    """Generate video using Veo 3.1 Fast via fal.ai"""

    result = fal_client.subscribe(
        "fal-ai/veo3.1/fast",
        arguments={
            "prompt": prompt,
            "duration": duration,
            "aspect_ratio": "9:16",  # Vertical for Shorts
            "audio": False  # Save cost, add music separately
        }
    )

    video_url = result["video"]["url"]
    return download_file(video_url, f"scene_{uuid.uuid4()}.mp4")

# Usage
clip = generate_video_clip(
    "A satisfying time-lapse of intricate rangoli pattern being created with colorful powder",
    duration=8
)
```

**Cost:** 8 seconds × $0.10/sec = **$0.80 per clip**

---

### Image Generation (FLUX [dev])

```python
def generate_image(prompt: str, resolution="1080x1920"):
    """Generate high-quality image using FLUX via fal.ai"""

    result = fal_client.subscribe(
        "fal-ai/flux/dev",
        arguments={
            "prompt": prompt,
            "image_size": resolution,
            "num_inference_steps": 28,  # Good quality/speed balance
            "guidance_scale": 3.5
        }
    )

    image_url = result["images"][0]["url"]
    return download_file(image_url, f"frame_{uuid.uuid4()}.png")

# Usage
frame = generate_image(
    "High-resolution photo of colorful rangoli pattern with intricate geometric designs, overhead view, vibrant colors"
)
```

**Cost:** $0.025 per image (normalized to 1MP)

---

### Voice Generation (ElevenLabs via fal.ai)

```python
def generate_voiceover(text: str, language="hi"):
    """Generate voice narration using ElevenLabs via fal.ai"""

    result = fal_client.subscribe(
        "fal-ai/elevenlabs/tts/turbo-v2.5",
        arguments={
            "text": text,
            "language": language,
            "voice_id": "21m00Tcm4TlvDq8ikWAM",  # Example voice
            "output_format": "mp3_44100_128"
        }
    )

    audio_url = result["audio_url"]
    return download_file(audio_url, f"voice_{uuid.uuid4()}.mp3")

# Usage (Hindi narration)
audio = generate_voiceover(
    "यह दिवाली रंगोली डिज़ाइन पाँच रंगों से बना है",
    language="hi"
)
```

**Cost:** Based on character count, ~$0.005-0.01 per 30-second narration

---

### Music Generation (Sonauto V2)

```python
def generate_background_music(description: str, duration: int = 30):
    """Generate royalty-free music using Sonauto via fal.ai"""

    result = fal_client.subscribe(
        "fal-ai/sonauto-v2",
        arguments={
            "prompt": description,
            "duration": duration,
            "genre": "ambient",
            "mood": "calm"
        }
    )

    music_url = result["audio_url"]
    return download_file(music_url, f"music_{uuid.uuid4()}.mp3")

# Usage
music = generate_background_music(
    "Calm, meditative Indian classical music with sitar and tabla, peaceful atmosphere",
    duration=30
)
```

**Cost:** ~$0.05-0.10 per 30-second track

---

## Complete Video Generation Workflow

```python
# scripts/generate_assets.py

import fal_client
from pathlib import Path

class AssetGenerator:
    def __init__(self, fal_api_key: str):
        fal_client.api_key = fal_api_key

    def generate_complete_video_assets(self, script: dict):
        """Generate all assets for one video using fal.ai"""

        assets = {
            "video_clips": [],
            "images": [],
            "voiceover": None,
            "music": None
        }

        # 1. Generate video clips for each scene
        for scene in script["scenes"]:
            clip = fal_client.subscribe(
                "fal-ai/veo3.1/fast",
                arguments={
                    "prompt": scene["description"],
                    "duration": scene["duration"],
                    "aspect_ratio": "9:16",
                    "audio": False
                }
            )
            assets["video_clips"].append(clip["video"]["url"])

        # 2. Generate thumbnail/frame images if needed
        if script.get("needs_thumbnail"):
            image = fal_client.subscribe(
                "fal-ai/flux/dev",
                arguments={
                    "prompt": script["thumbnail_prompt"],
                    "image_size": "1080x1920"
                }
            )
            assets["images"].append(image["images"][0]["url"])

        # 3. Generate voiceover if script has narration
        if script.get("narration"):
            voice = fal_client.subscribe(
                "fal-ai/elevenlabs/tts/turbo-v2.5",
                arguments={
                    "text": script["narration"],
                    "language": script.get("language", "hi"),
                    "output_format": "mp3_44100_128"
                }
            )
            assets["voiceover"] = voice["audio_url"]

        # 4. Generate background music
        music = fal_client.subscribe(
            "fal-ai/sonauto-v2",
            arguments={
                "prompt": script["music_description"],
                "duration": script["duration"]
            }
        )
        assets["music"] = music["audio_url"]

        return assets

# Usage
generator = AssetGenerator(fal_api_key=FAL_KEY)

script = {
    "duration": 28,
    "scenes": [
        {"description": "Rangoli pattern start", "duration": 8},
        {"description": "Pattern developing", "duration": 10},
        {"description": "Final reveal", "duration": 10}
    ],
    "music_description": "Calm Indian classical sitar music",
    "language": "hi"
}

assets = generator.generate_complete_video_assets(script)
```

---

## Cost Breakdown (fal.ai vs Original)

### Per-Video Cost Comparison

**Original Estimate (Multiple Providers):**
```
Veo 3 (4 clips × 8s):      $6.40 (at $0.50/sec via Kie.ai)
DALL-E 3 (2 images):       $0.08
ElevenLabs voice:          $0.01
Soundverse music:          $0.10
Claude API:                $0.15
────────────────────────
Total:                     $6.74/video
```

**With fal.ai (Optimized):**
```
Veo 3.1 Fast (3 clips × 8s): $2.40 (at $0.10/sec)
FLUX dev (2 images):         $0.05
ElevenLabs voice:            $0.01
Sonauto music:               $0.05
Claude API:                  $0.15
────────────────────────
Total:                       $2.66/video
```

**Savings: $4.08/video (61% reduction)** 🎉

### Monthly Cost (90 Videos in Month 3)

**Original:**
- 90 videos × $6.74 = **$606/month**

**With fal.ai:**
- 90 videos × $2.66 = **$239/month**

**Monthly Savings: $367 (61% reduction)**

### 90-Day Aggressive Timeline Cost

**Original:**
- 249 videos × $6.74 = **$1,678**

**With fal.ai:**
- 249 videos × $2.66 = **$662**

**Total Savings: $1,016 (61% reduction)** 🎉

---

## Setup Guide

### 1. Get fal.ai API Key

```bash
# Sign up at fal.ai
Visit: https://fal.ai/

# Generate API key
Dashboard → API Keys → Create New Key

# Set environment variable
export FAL_KEY="your_fal_api_key_here"
```

### 2. Install SDK

**Python:**
```bash
pip install fal-client
```

**JavaScript/TypeScript:**
```bash
npm install @fal-ai/client
```

### 3. Configure in Project

**Update `config/api_keys.env`:**
```bash
# SIMPLIFIED - Only 2 keys needed now!
ANTHROPIC_API_KEY=sk-ant-xxxxx
FAL_KEY=xxxxx

# REMOVED (now via fal.ai):
# VEO3_API_KEY (was via Kie.ai)
# OPENAI_API_KEY (was for DALL-E)
# SOUNDVERSE_API_KEY
# (ElevenLabs still accessible via fal.ai)
```

**Update `requirements.txt`:**
```
anthropic>=0.18.0
fal-client>=0.4.0  # ADDED
python-dotenv>=1.0.0

# REMOVED:
# openai (was for DALL-E)
# elevenlabs (now via fal.ai)
```

### 4. Test Integration

```python
# scripts/test_fal_integration.py

import fal_client
import os

fal_client.api_key = os.getenv("FAL_KEY")

# Test video generation
print("Testing Veo 3.1 Fast...")
video_result = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": "A simple test video",
        "duration": 3
    }
)
print(f"✅ Video generated: {video_result['video']['url']}")

# Test image generation
print("Testing FLUX [dev]...")
image_result = fal_client.subscribe(
    "fal-ai/flux/dev",
    arguments={
        "prompt": "A colorful test pattern"
    }
)
print(f"✅ Image generated: {image_result['images'][0]['url']}")

print("\n🎉 fal.ai integration working!")
```

---

## Error Handling

```python
import fal_client
from fal_client.exceptions import FalAPIError
import time

def generate_with_retry(model: str, arguments: dict, max_retries=3):
    """Generate with exponential backoff retry logic"""

    for attempt in range(max_retries):
        try:
            result = fal_client.subscribe(model, arguments=arguments)
            return result

        except FalAPIError as e:
            if attempt < max_retries - 1:
                wait_time = 2 ** attempt  # Exponential backoff: 1s, 2s, 4s
                print(f"⚠️ Error: {e}. Retrying in {wait_time}s...")
                time.sleep(wait_time)
            else:
                print(f"❌ Failed after {max_retries} attempts")
                raise

# Usage
result = generate_with_retry(
    "fal-ai/veo3.1/fast",
    {"prompt": "...", "duration": 8}
)
```

---

## Rate Limits & Scaling

**Default Limits:**
- 10 concurrent tasks per user
- Sufficient for MVP (generating 3 videos/day)

**For Production (>10 concurrent):**
- Contact fal.ai for enterprise rate limits
- Upgrade available for higher volume

**Our Usage:**
- Batch production: 21 videos on Sunday
- Can process 10 concurrent, then next batch
- 21 videos ÷ 10 concurrent = 3 batches
- Total time: ~15-20 minutes (vs hours with sequential)

---

## Migration Checklist

### Phase 1: Setup (1 hour)
- [ ] Sign up for fal.ai account
- [ ] Generate API key
- [ ] Install fal-client package
- [ ] Update environment variables
- [ ] Test basic integration

### Phase 2: Update Skills (2-3 hours)
- [ ] Modify asset-generator skill
- [ ] Replace multiple API clients with fal_client
- [ ] Update video generation to use Veo 3.1 Fast
- [ ] Update image generation to use FLUX [dev]
- [ ] Update voice generation to use ElevenLabs via fal
- [ ] Update music generation to use Sonauto
- [ ] Test each component

### Phase 3: Integration Testing (1-2 hours)
- [ ] Generate test video end-to-end
- [ ] Verify all assets generated correctly
- [ ] Check video quality, audio sync
- [ ] Confirm costs align with estimates
- [ ] Load test with 5 concurrent videos

### Phase 4: Production (30 minutes)
- [ ] Update GitHub Actions secrets (FAL_KEY)
- [ ] Remove old API keys from secrets
- [ ] Deploy to production
- [ ] Monitor first batch generation

**Total Migration Time: 4-7 hours** (vs weeks integrating 5+ providers)

---

## Monitoring & Optimization

### Cost Tracking

**fal.ai provides:**
- Unified billing dashboard
- Per-model usage breakdown
- Cost trends over time
- Usage API for programmatic access

**Access Pricing API:**
```python
import requests

response = requests.get(
    "https://api.fal.ai/v1/models/pricing",
    headers={"Authorization": f"Key {FAL_KEY}"}
)
pricing = response.json()
```

### Performance Monitoring

**fal.ai Infrastructure:**
- 99.99% uptime SLA
- <100ms API latency
- Up to 400% faster inference than competitors
- Distributed GPU network

**Our Monitoring:**
- Track generation times per model
- Monitor success/failure rates
- Alert on cost anomalies
- Weekly cost review

---

## Conclusion

### Benefits Summary

✅ **Simplified Integration**: 1 API key vs 5+
✅ **Cost Savings**: 61% reduction ($2.66 vs $6.74/video)
✅ **Faster Development**: 40-60% less integration time
✅ **Better Infrastructure**: 99.99% uptime, managed
✅ **Unified Billing**: Single dashboard, one invoice
✅ **Scalability**: Easy to add new models
✅ **Performance**: Up to 400% faster inference

### Updated Economics

**90-Day Aggressive Timeline with fal.ai:**
- 249 videos × $2.66 = $662 (vs $1,678 original)
- **Savings: $1,016**

**Monthly Production (90 videos):**
- $239/month (vs $606 original)
- **Savings: $367/month**

**First Year (550 videos):**
- $1,463 (vs $3,707 original)
- **Savings: $2,244/year**

### Recommendation

**Use fal.ai for MVP and beyond.** The cost savings (61%), development time reduction (40-60%), and simplified infrastructure make it the clear choice. You can always migrate to direct APIs later if specific needs arise, but fal.ai provides everything needed for autonomous video generation at scale.

---

**Ready to integrate? Follow the Setup Guide above and start generating in <1 hour!** 🚀
