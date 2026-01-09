# Generate Video Command

Execute the complete autonomous video generation workflow.

## Steps:

1. Load configuration from `config/generation_params.yaml`
2. Activate the `idea-generator` skill to create video concepts
3. Select the best idea based on trend alignment and production feasibility
4. Activate the `script-writer` skill to create optimized script
5. Activate the `scene-planner` skill to break down into visual scenes
6. Generate assets:
   - Video clips via Veo 3 API
   - Voiceover via ElevenLabs (if needed)
   - Background music via Soundverse
   - Sound effects from library
7. Activate the `remotion-assembler` skill to create video composition
8. Render video with Remotion
9. Upload to YouTube using publishing scripts
10. Log video metadata and upload details for analytics

Output the video ID and YouTube URL when complete.
