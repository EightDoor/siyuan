#!/bin/bash
# 同步上游代码并创建 tag 的脚本

set -e

echo "🔄 Fetching upstream..."
git fetch upstream

echo "📦 Merging upstream/master..."
git merge upstream/master -m "Merge upstream/master at $(date +%Y%m%d)"

# 获取最新的上游 tag
LATEST_TAG=$(git tag -l "v*" --sort=-version:refname | head -n1)

if [ -z "$LATEST_TAG" ]; then
    echo "❌ No tag found in upstream"
    exit 1
fi

echo "🏷️  Latest upstream tag: $LATEST_TAG"

# 检查是否已经存在对应的 -z tag
Z_TAG="${LATEST_TAG}-z"

if git rev-parse "$Z_TAG" >/dev/null 2>&1; then
    echo "⚠️  Tag $Z_TAG already exists, skipping..."
else
    echo "🏷️  Creating tag: $Z_TAG"
    git tag -a "$Z_TAG" -m "Release $Z_TAG (based on upstream $LATEST_TAG)"
fi

echo "✅ Done! Now push with:"
echo "   git push origin master"
echo "   git push origin $Z_TAG"
