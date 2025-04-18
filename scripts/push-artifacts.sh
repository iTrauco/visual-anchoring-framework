#!/bin/sh
# Path to repos
DOWNSTREAM_REPO="$(pwd)"
MASTER_REPO="/home/trauco/Prod/private-tracking/private-master-artifacts"
REPO_NAME=$(basename "$DOWNSTREAM_REPO")
BRANCH=$(git branch --show-current)

# Create branch directory
mkdir -p "$MASTER_REPO/projects/$REPO_NAME/$BRANCH"

# Copy artifacts to master repo
cp -r "$DOWNSTREAM_REPO/artifacts/"* "$MASTER_REPO/projects/$REPO_NAME/$BRANCH/" 2>/dev/null || true

# Add branch info
echo "Branch: $BRANCH" > "$MASTER_REPO/projects/$REPO_NAME/$BRANCH/.branch-info"
echo "Last updated: $(date)" >> "$MASTER_REPO/projects/$REPO_NAME/$BRANCH/.branch-info"
echo "Repo: $REPO_NAME" >> "$MASTER_REPO/projects/$REPO_NAME/$BRANCH/.branch-info"

# Commit and push changes to master repo
cd "$MASTER_REPO" || exit
MASTER_BRANCH=$(git branch --show-current)
git add "projects/$REPO_NAME/$BRANCH/"
git diff --staged --quiet || (git commit -m "Sync artifacts from $REPO_NAME ($BRANCH branch)" && git push origin "$MASTER_BRANCH")
