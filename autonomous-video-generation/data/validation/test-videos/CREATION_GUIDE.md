# Test Video Creation Guide (Day 2 - Jan 12)

**Goal**: Create 3 test videos to validate AI quality and Makar Sankranti hypothesis

**Budget**: $8 (3 videos × $2.66 each)
**Time**: 4 hours

---

## Prerequisites

### 1. fal.ai API Setup

**Sign up**: https://fal.ai
**Get API key**: Dashboard → API Keys
**Pricing**: Pay-as-you-go (no subscription needed)

**Set environment variable:**
```bash
export FAL_KEY="your-api-key-here"
```

### 2. Install fal.ai Python Client

```bash
pip install fal-client
```

### 3. Test API Connection

```python
import fal_client

# Test connection
result = fal_client.subscribe(
    "fal-ai/flux/dev",
    arguments={
        "prompt": "test image",
        "image_size": "landscape_4_3"
    }
)
print(f"Connection successful! Image URL: {result['images'][0]['url']}")
```

---

## Video 1: Traditional Rangoli (Evergreen Baseline)

### Objective
Create a classic rangoli video to establish baseline quality and test AI capability for evergreen content.

### Video Specification
- **Length**: 30 seconds (optimal for Shorts)
- **Clips**: 3 × 8-second clips + 6-second finale
- **Style**: Slow, meditative, ASMR-friendly
- **Theme**: Traditional Diwali-style rangoli (works year-round)

### Scene Breakdown

**Clip 1 (0-8s): Center Point Creation**
```python
import fal_client

clip1 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Overhead shot, close-up of hands creating the center point
        of a traditional Indian rangoli pattern on clean white floor. Female hands
        with bangles gently placing vibrant orange and yellow powder to form a
        small circular center. Soft natural lighting. Powder particles visible.
        Meditative pace. ASMR quality. 9:16 vertical format. Sharp focus on hands
        and powder.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)

print(f"Clip 1 URL: {clip1['video']['url']}")
# Save video file
import urllib.request
urllib.request.urlretrieve(clip1['video']['url'], 'traditional_clip1.mp4')
```

**Clip 2 (8-16s): Pattern Building**
```python
clip2 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Overhead shot, hands building outward from center in circular
        symmetrical pattern. Creating petal shapes with red, orange, and yellow
        colored powder. Smooth, flowing hand movements. Powder cascading gently
        through fingers. Traditional rangoli design emerging. Soft shadows. Clean
        white floor background. 9:16 vertical. Focus on the growing pattern and
        hand movements. Calming, satisfying visual.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)
urllib.request.urlretrieve(clip2['video']['url'], 'traditional_clip2.mp4')
```

**Clip 3 (16-24s): Detail Work**
```python
clip3 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Close-up overhead shot of hands adding intricate details
        to rangoli pattern. Fine lines being drawn with green and blue powder.
        Delicate finger movements creating precise decorative elements. The
        rangoli pattern is now about 50% complete, showing beautiful symmetrical
        flower-like design. Rich, vibrant colors. Satisfying precision. 9:16
        vertical. ASMR-quality footage.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)
urllib.request.urlretrieve(clip3['video']['url'], 'traditional_clip3.mp4')
```

**Finale Image (24-30s): Completed Rangoli**
```python
finale_image = fal_client.subscribe(
    "fal-ai/flux/dev",
    arguments={
        "prompt": """Overhead shot of completed traditional Indian Diwali rangoli
        on white floor. Circular mandala design, 3 feet diameter. Vibrant colors:
        center orange fading to yellow, surrounded by red petals, outer ring of
        green and blue decorative elements. Symmetrical, intricate, professional
        quality. Small diya (oil lamps) placed around the rangoli. Soft natural
        lighting casting gentle shadows. Photorealistic, sharp focus, beautiful
        composition. 9:16 aspect ratio.""",
        "image_size": "1080x1920"
    }
)
urllib.request.urlretrieve(finale_image['images'][0]['url'], 'traditional_finale.png')
```

### Assembly Instructions

Use simple video editor or ffmpeg:

```bash
# Concatenate video clips
ffmpeg -i traditional_clip1.mp4 -i traditional_clip2.mp4 -i traditional_clip3.mp4 \
  -filter_complex "[0:v][1:v][2:v]concat=n=3:v=1[v]" \
  -map "[v]" traditional_base.mp4

# Create 6-second still from finale image
ffmpeg -loop 1 -i traditional_finale.png -t 6 -vf "scale=1080:1920" \
  -c:v libx264 -pix_fmt yuv420p traditional_finale.mp4

# Combine base + finale
ffmpeg -i traditional_base.mp4 -i traditional_finale.mp4 \
  -filter_complex "[0:v][1:v]concat=n=2:v=1[v]" \
  -map "[v]" traditional_complete.mp4

# Add background music (royalty-free ASMR ambient from library)
# Add text overlay: "Traditional Rangoli Design ✨ #Shorts #Rangoli #Satisfying"
```

**Metadata:**
- Title: "Satisfying Traditional Rangoli Design 🌸 #Shorts"
- Description: "Watch this beautiful traditional rangoli pattern come to life!
  [AI-generated content] #Rangoli #Satisfying #ASMR #IndianArt #Shorts"
- Tags: rangoli, satisfying, ASMR, traditional, Indian art, shorts
- Thumbnail: Use finale image with text "Traditional Rangoli"

**Cost**: ~$2.66

---

## Video 2: Makar Sankranti Special (Seasonal Test)

### Objective
Test seasonal content hypothesis with actual festival (Jan 14). Validate if festival-specific content drives higher engagement.

### Video Specification
- **Length**: 30 seconds
- **Clips**: 3 × 8-second clips + 6-second finale
- **Style**: Vibrant, energetic (festival vibe)
- **Theme**: Kite + Rangoli (Makar Sankranti specific)
- **Publish**: January 14, 6:00 AM IST

### Scene Breakdown

**Clip 1 (0-8s): Kite Rangoli Start**
```python
clip1 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Overhead shot of hands beginning a kite-shaped rangoli
        design for Makar Sankranti festival. Drawing the outline of a colorful
        kite shape on white floor using bright yellow and orange powder. Festival
        energy, upbeat pace. Clear kite diamond shape forming. 9:16 vertical.
        Vibrant, celebratory mood. Natural lighting.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)
urllib.request.urlretrieve(clip1['video']['url'], 'sankranti_clip1.mp4')
```

**Clip 2 (8-16s): Filling with Festival Colors**
```python
clip2 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Hands filling the kite-shaped rangoli with vibrant festival
        colors. Bright pink, green, yellow, orange, and blue powder creating
        sections within the kite shape. Adding decorative patterns inside. The
        kite tail being drawn with alternating color segments. Energetic, fast-
        paced movements. Makar Sankranti celebration vibe. Overhead 9:16 shot.
        Colorful, joyful, festive.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)
urllib.request.urlretrieve(clip2['video']['url'], 'sankranti_clip2.mp4')
```

**Clip 3 (16-24s): Final Details + Sun Symbol**
```python
clip3 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Adding final touches to Makar Sankranti kite rangoli.
        Hands creating a small sun symbol above the kite using bright yellow
        and orange powder. Adding decorative swirls and festival elements around
        the kite. The design is nearly complete, very colorful and festive.
        Overhead shot, 9:16 vertical. Celebratory, vibrant, satisfying completion.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)
urllib.request.urlretrieve(clip3['video']['url'], 'sankranti_clip3.mp4')
```

**Finale Image (24-30s): Complete Festival Rangoli**
```python
finale_image = fal_client.subscribe(
    "fal-ai/flux/dev",
    arguments={
        "prompt": """Completed Makar Sankranti rangoli on white floor. Large
        colorful kite shape in center (2 feet diamond shape) filled with vibrant
        pink, green, yellow, and blue sections. Colorful kite tail extending
        downward with alternating color segments. Bright yellow and orange sun
        symbol above the kite. Decorative swirls and festival motifs around.
        Very festive, bright, joyful composition. Overhead shot, photorealistic,
        sharp focus. 9:16 aspect ratio. Makar Sankranti celebration theme.""",
        "image_size": "1080x1920"
    }
)
urllib.request.urlretrieve(finale_image['images'][0]['url'], 'sankranti_finale.png')
```

### Assembly (Same as Video 1 process)

**Metadata:**
- Title: "Makar Sankranti Kite Rangoli 🪁 #Shorts #MakarSankranti"
- Description: "Celebrating Makar Sankranti with this beautiful kite rangoli!
  Happy Uttarayan! [AI-generated content] #MakarSankranti #Rangoli #Kite
  #Uttarayan #Festival #IndianFestival #Shorts"
- Tags: makar sankranti, uttarayan, kite, rangoli, festival, indian festival,
  sankranti 2026, shorts
- Thumbnail: Finale image with text "Makar Sankranti Special 🪁"
- **PUBLISH**: January 14, 2026 at 6:00 AM IST

**Cost**: ~$2.66

---

## Video 3: Modern ASMR Rangoli (Style Test)

### Objective
Test modern, trendy style to see if it outperforms traditional. Validate younger audience appeal.

### Video Specification
- **Length**: 30 seconds
- **Clips**: 3 × 8-second clips + 6-second finale
- **Style**: Modern, fast-paced, trendy
- **Theme**: Geometric minimalist rangoli with neon colors

### Scene Breakdown

**Clip 1 (0-8s): Geometric Foundation**
```python
clip1 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Overhead shot of hands creating a modern geometric rangoli
        design. Drawing clean, sharp lines with neon pink powder to form a
        hexagonal frame on sleek grey floor. Minimalist, contemporary style.
        Fast, precise movements. Modern aesthetic. 9:16 vertical. Trendy,
        satisfying, sharp focus.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)
urllib.request.urlretrieve(clip1['video']['url'], 'modern_clip1.mp4')
```

**Clip 2 (8-16s): Neon Infill**
```python
clip2 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Hands filling the geometric hexagonal rangoli with vibrant
        neon colors: cyan, purple, neon yellow, hot pink. Creating internal
        geometric patterns - triangles, diamonds, clean lines. Modern, trendy
        color palette. Fast-paced, energetic movements. Grey floor background.
        Overhead 9:16 shot. Contemporary, Instagram-worthy aesthetic. Satisfying
        precision.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)
urllib.request.urlretrieve(clip2['video']['url'], 'modern_clip2.mp4')
```

**Clip 3 (16-24s): Final Touches**
```python
clip3 = fal_client.subscribe(
    "fal-ai/veo3.1/fast",
    arguments={
        "prompt": """Adding final modern details to geometric rangoli. Hands
        creating sharp accent lines with white powder, adding small geometric
        shapes in corners. The design is bold, colorful, minimalist, and very
        trendy. Neon colors against grey floor. Overhead shot, 9:16 vertical.
        Fast cuts, modern aesthetic, Gen-Z appeal. Satisfying completion.""",
        "duration": 8,
        "aspect_ratio": "9:16",
        "audio": False
    }
)
urllib.request.urlretrieve(clip3['video']['url'], 'modern_clip3.mp4')
```

**Finale Image (24-30s): Complete Modern Rangoli**
```python
finale_image = fal_client.subscribe(
    "fal-ai/flux/dev",
    arguments={
        "prompt": """Completed modern geometric rangoli on grey floor. Large
        hexagonal design (2 feet across) with internal geometric patterns. Neon
        colors: hot pink, cyan, purple, neon yellow, white accents. Clean lines,
        minimalist aesthetic, contemporary Indian art fusion. Overhead shot,
        perfectly symmetrical, sharp focus, trendy, Instagram-worthy. 9:16 aspect
        ratio. Modern, bold, satisfying.""",
        "image_size": "1080x1920"
    }
)
urllib.request.urlretrieve(finale_image['images'][0]['url'], 'modern_finale.png')
```

### Assembly (Same process)

**Metadata:**
- Title: "Modern Geometric Rangoli 🎨 #Shorts #Satisfying"
- Description: "Trendy geometric rangoli with neon colors! Modern Indian art ✨
  [AI-generated content] #ModernRangoli #Geometric #Satisfying #ASMR #Trending
  #Shorts"
- Tags: modern rangoli, geometric, neon, trendy, satisfying, ASMR, shorts,
  contemporary art
- Thumbnail: Finale image with text "Modern Rangoli"

**Cost**: ~$2.66

---

## Total Cost Estimate

**API Costs:**
- Video 1: 3 video clips ($2.40) + 1 image ($0.025) = $2.425
- Video 2: 3 video clips ($2.40) + 1 image ($0.025) = $2.425
- Video 3: 3 video clips ($2.40) + 1 image ($0.025) = $2.425
- **Total**: ~$7.28

**Actual with assembly overhead**: ~$8-10 (testing, retries if needed)

---

## Assembly Workflow

### Option A: Simple ffmpeg Script

Create `assemble_videos.sh`:
```bash
#!/bin/bash

# Video 1: Traditional
ffmpeg -i traditional_clip1.mp4 -i traditional_clip2.mp4 -i traditional_clip3.mp4 \
  -filter_complex "[0:v][1:v][2:v]concat=n=3:v=1[v]" -map "[v]" trad_base.mp4
ffmpeg -loop 1 -i traditional_finale.png -t 6 -vf "scale=1080:1920" \
  -c:v libx264 -pix_fmt yuv420p trad_finale.mp4
ffmpeg -i trad_base.mp4 -i trad_finale.mp4 \
  -filter_complex "[0:v][1:v]concat=n=2:v=1[v]" -map "[v]" \
  test_video_1_traditional.mp4

# Video 2: Makar Sankranti
ffmpeg -i sankranti_clip1.mp4 -i sankranti_clip2.mp4 -i sankranti_clip3.mp4 \
  -filter_complex "[0:v][1:v][2:v]concat=n=3:v=1[v]" -map "[v]" sank_base.mp4
ffmpeg -loop 1 -i sankranti_finale.png -t 6 -vf "scale=1080:1920" \
  -c:v libx264 -pix_fmt yuv420p sank_finale.mp4
ffmpeg -i sank_base.mp4 -i sank_finale.mp4 \
  -filter_complex "[0:v][1:v]concat=n=2:v=1[v]" -map "[v]" \
  test_video_2_sankranti.mp4

# Video 3: Modern
ffmpeg -i modern_clip1.mp4 -i modern_clip2.mp4 -i modern_clip3.mp4 \
  -filter_complex "[0:v][1:v][2:v]concat=n=3:v=1[v]" -map "[v]" mod_base.mp4
ffmpeg -loop 1 -i modern_finale.png -t 6 -vf "scale=1080:1920" \
  -c:v libx264 -pix_fmt yuv420p mod_finale.mp4
ffmpeg -i mod_base.mp4 -i mod_finale.mp4 \
  -filter_complex "[0:v][1:v]concat=n=2:v=1[v]" -map "[v]" \
  test_video_3_modern.mp4

echo "All videos assembled!"
```

### Option B: Use Online Video Editor (Easier)

Tools like CapCut, Canva, or InShot:
1. Import 3 clips + finale image
2. Arrange in sequence
3. Add text overlay
4. Add background music
5. Export as 1080×1920 MP4

---

## Quality Checklist

Before finalizing, verify each video:

- [ ] Resolution: 1080×1920 (9:16)
- [ ] Length: ~30 seconds
- [ ] Format: MP4
- [ ] Quality: Clear, no artifacts
- [ ] Text overlays: Readable, on-brand
- [ ] Music: Royalty-free, appropriate tone
- [ ] Title: Hook + keywords + emojis
- [ ] Description: AI disclosure included
- [ ] Tags: Relevant, searchable
- [ ] Thumbnail: Eye-catching, text overlay

---

## Upload Strategy

**Video 1 & 3**: Upload as UNLISTED (for user feedback Day 3-4)
**Video 2**: Upload as SCHEDULED for January 14, 6:00 AM IST (public)

**AI Content Disclosure** (required):
Add to description:
```
⚠️ This video contains AI-generated content created with fal.ai (Veo 3.1 Fast).
```

---

## Expected Outcomes

**Success Criteria** (for user feedback phase):
- User rating >7/10 average
- >60% would watch to completion
- At least 1 video strongly preferred
- Positive comments on quality

**If successful**: Proceed to technical validation (Week 2)
**If mixed**: Adjust prompts, regenerate weak video
**If poor**: Pivot theme or reconsider AI viability

---

## Next Steps (Day 3)

After videos created:
1. Upload unlisted (Videos 1 & 3)
2. Schedule Video 2 for Jan 14, 6 AM IST
3. Prepare user feedback survey
4. Share unlisted links with 20-30 people in target demo
5. Collect feedback (Day 3-4)

---

**Good luck with creation! Test the prompts, iterate if needed. Quality over speed.** 🎨
