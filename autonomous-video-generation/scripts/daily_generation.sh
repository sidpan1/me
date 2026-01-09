#!/bin/bash
# Daily Video Generation Script
# Run via cron: 30 0 * * * /path/to/this/script.sh

set -e  # Exit on error

PROJECT_DIR="/home/user/me/autonomous-video-generation"
cd "$PROJECT_DIR"

# Log start time
echo "==================================" >> logs/daily_generation.log
echo "Starting daily generation: $(date)" >> logs/daily_generation.log

# Load environment variables
if [ -f config/api_keys.env ]; then
    export $(cat config/api_keys.env | grep -v '^#' | xargs)
fi

# Activate virtual environment
source venv/bin/activate

# Run video generation via Claude Code
echo "Executing video generation..." >> logs/daily_generation.log
claude -p "Execute /generate-video command for today's video" >> logs/daily_generation.log 2>&1

# Wait a moment for upload to complete
sleep 10

# Collect analytics from previous day's videos (24h after upload)
echo "Collecting analytics..." >> logs/daily_generation.log
python src/analytics/collector.py >> logs/daily_generation.log 2>&1 || echo "Analytics collection failed or no videos ready"

# Commit performance data to git (optional)
if [ -f data/performance_log.json ]; then
    git add data/performance_log.json
    git commit -m "Update performance data $(date +%Y-%m-%d)" >> logs/daily_generation.log 2>&1 || echo "No changes to commit"
    git push origin main >> logs/daily_generation.log 2>&1 || echo "Git push failed or not configured"
fi

echo "Daily generation complete: $(date)" >> logs/daily_generation.log
echo "==================================" >> logs/daily_generation.log
