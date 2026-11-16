#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
    echo "Usage: ./Tools/switch-version.sh <branch-name>"
    echo "Example: ./Tools/switch-version.sh orqa-copter-4.6"
    exit 1
fi

TARGET_BRANCH="$1"

# 1. Switch branch (stops automatically if you have conflicting uncommitted edits)
git checkout "$TARGET_BRANCH"

# 2. Sync and clean submodules
./Tools/gittools/submodule-sync.sh
git submodule foreach --recursive git clean -ffd

# 3. Remove leftover modules/littlefs if switching to a branch that doesn't track it (like 4.5)
if [ -d "modules/littlefs" ] && ! git ls-files --error-unmatch modules/littlefs >/dev/null 2>&1; then
    rm -rf modules/littlefs
fi

# 4. Clean Waf build artifacts
./waf distclean

echo "Switched to $TARGET_BRANCH. Next run: ./waf configure --board <board_name> && ./waf copter"
