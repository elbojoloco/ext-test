#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DIST_BRANCH="dist"

# Check if tag is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide a tag version${NC}"
    echo "Usage: npm run release <tag>"
    echo "Example: npm run release 26.2"
    exit 1
fi

TAG="$1"

# Validate tag format (year.iteration)
if ! [[ "$TAG" =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo -e "${YELLOW}Warning: Tag '$TAG' doesn't match expected format (e.g., 26.2)${NC}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if tag already exists
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo -e "${RED}Error: Tag '$TAG' already exists${NC}"
    exit 1
fi

echo -e "${YELLOW}Creating release $TAG...${NC}"

# First, deploy to dist branch
echo -e "${YELLOW}Step 1: Deploy to $DIST_BRANCH branch${NC}"
npm run deploy

# Now create tag on the dist branch
echo -e "${YELLOW}Step 2: Creating tag $TAG on $DIST_BRANCH branch${NC}"

# Get the latest commit on dist branch
DIST_COMMIT=$(git rev-parse "origin/$DIST_BRANCH")

# Create annotated tag pointing to the dist branch commit
git tag -a "$TAG" "$DIST_COMMIT" -m "Release $TAG"

# Push the tag
git push origin "$TAG"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Release $TAG complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "jsDelivr URL:"
echo -e "${YELLOW}https://cdn.jsdelivr.net/gh/elbojoloco/myextension@$TAG/ext.js${NC}"
echo ""
