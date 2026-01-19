#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DIST_BRANCH="dist"
DIST_DIR="dist"

echo -e "${YELLOW}Building project...${NC}"
npm run build

# Check if dist directory exists and has files
if [ ! -d "$DIST_DIR" ] || [ -z "$(ls -A $DIST_DIR)" ]; then
    echo -e "${RED}Error: dist directory is empty or doesn't exist${NC}"
    exit 1
fi

echo -e "${YELLOW}Deploying to $DIST_BRANCH branch...${NC}"

# Save current branch name
CURRENT_BRANCH=$(git branch --show-current)

# Create a temporary directory for the dist files
TEMP_DIR=$(mktemp -d)
cp -r "$DIST_DIR"/* "$TEMP_DIR/"

# Check if dist branch exists
if git show-ref --verify --quiet "refs/heads/$DIST_BRANCH"; then
    git checkout "$DIST_BRANCH"
else
    # Create orphan branch if it doesn't exist
    git checkout --orphan "$DIST_BRANCH"
    git rm -rf . 2>/dev/null || true
fi

# Remove all files except .git
find . -maxdepth 1 ! -name '.git' ! -name '.' -exec rm -rf {} +

# Copy dist files to root
cp -r "$TEMP_DIR"/* .

# Clean up temp directory
rm -rf "$TEMP_DIR"

# Add and commit
git add -A
if git diff --cached --quiet; then
    echo -e "${YELLOW}No changes to deploy${NC}"
else
    COMMIT_MSG="Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -m "$COMMIT_MSG"
    echo -e "${GREEN}Committed: $COMMIT_MSG${NC}"
fi

# Push to remote
git push -u origin "$DIST_BRANCH"
echo -e "${GREEN}Pushed to origin/$DIST_BRANCH${NC}"

# Switch back to original branch
git checkout "$CURRENT_BRANCH"

echo -e "${GREEN}Deploy complete!${NC}"
