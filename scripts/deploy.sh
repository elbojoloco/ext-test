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

# Get the remote URL
REMOTE_URL=$(git remote get-url origin)

# Store the absolute path to dist
ORIGINAL_DIR=$(pwd)
DIST_ABSOLUTE="$ORIGINAL_DIR/$DIST_DIR"

# Create a temporary directory for git operations
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

cd "$TEMP_DIR"
git init -q

# Check if dist branch exists on remote
if git ls-remote --heads "$REMOTE_URL" "$DIST_BRANCH" | grep -q "$DIST_BRANCH"; then
    # Fetch and checkout the existing branch
    git fetch -q "$REMOTE_URL" "$DIST_BRANCH"
    git checkout -q -b "$DIST_BRANCH" FETCH_HEAD
    
    # Remove old files (except .git)
    find . -maxdepth 1 ! -name '.git' ! -name '.' -exec rm -rf {} +
else
    # Create new orphan branch
    git checkout -q --orphan "$DIST_BRANCH"
fi

# Now copy dist files
cp -r "$DIST_ABSOLUTE"/* .

# Add and commit
git add -A
if git diff --cached --quiet; then
    echo -e "${YELLOW}No changes to deploy${NC}"
else
    COMMIT_MSG="Deploy: $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -q -m "$COMMIT_MSG"
    echo -e "${GREEN}Committed: $COMMIT_MSG${NC}"
    
    # Push to remote
    git push -f "$REMOTE_URL" "$DIST_BRANCH"
    echo -e "${GREEN}Pushed to origin/$DIST_BRANCH${NC}"
fi

echo -e "${GREEN}Deploy complete!${NC}"
