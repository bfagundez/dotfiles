#!/bin/bash
# smart-worktree.sh - Intelligently creates windows in existing tmux or new sessions

set -e

# Configuration
WORKTREE_PATH="$1"
BRANCH="${2:-HEAD}"
WINDOW_NAME="${3:-$(basename "$WORKTREE_PATH" 2>/dev/null || echo "dev")}"
SOURCE_PATH="$(pwd)"

if [ -z "$WORKTREE_PATH" ]; then
    echo "Usage: $0 <worktree-path> [branch] [window-name]"
    echo "Example: $0 ../feature-xyz feature/xyz xyz"
    exit 1
fi

# Detect if we're inside tmux
IN_TMUX=false
CURRENT_SESSION=""
if [ -n "$TMUX" ]; then
    IN_TMUX=true
    CURRENT_SESSION=$(tmux display-message -p '#S')
    echo "🔍 Detected tmux session: $CURRENT_SESSION"
fi

echo "🚀 Setting up worktree..."

# 1. Create worktree
if [ ! -d "$WORKTREE_PATH" ]; then
    echo "📁 Creating worktree at: $WORKTREE_PATH"
    
    # Check if branch exists
    if git show-ref --verify --quiet "refs/heads/$BRANCH" 2>/dev/null; then
        # Branch exists, use it
        git worktree add "$WORKTREE_PATH" "$BRANCH"
    elif git show-ref --verify --quiet "refs/remotes/origin/$BRANCH" 2>/dev/null; then
        # Remote branch exists, create local branch from it
        git worktree add "$WORKTREE_PATH" "$BRANCH"
    else
        # Branch doesn't exist, create it from current HEAD
        echo "   🌿 Branch '$BRANCH' doesn't exist, creating it..."
        git worktree add -b "$BRANCH" "$WORKTREE_PATH" HEAD
    fi
else
    echo "📁 Using existing worktree: $WORKTREE_PATH"
fi

# 2. Copy .env files
echo "📋 Copying .env files..."
find "$SOURCE_PATH" -maxdepth 3 -name ".env*" -type f 2>/dev/null | while read -r env_file; do
    relative_path="${env_file#$SOURCE_PATH/}"
    target_dir="$WORKTREE_PATH/$(dirname "$relative_path")"
    target_file="$WORKTREE_PATH/$relative_path"
    if [ ! -f "$target_file" ]; then
        mkdir -p "$target_dir"
        cp "$env_file" "$target_file"
        echo "   ✓ Copied $relative_path"
    fi
done

# 3. Install dependencies
cd "$WORKTREE_PATH"

echo "📦 Installing dependencies..."
yarn install
(cd upmetrics_client && yarn install)
(cd upmetrics_api && yarn install)
(cd upmetrics_api && bundle install)

if [ -f "upmetrics_api/config/application.rb" ]; then
    echo "🔧 Updating Rails application.rb..."
    REQUIRE_LINE="require 'resolv-replace'"
    
    # Check if the require already exists
    if ! grep -q "$REQUIRE_LINE" upmetrics_api/config/application.rb; then
        # Insert after frozen_string_literal and before require_relative 'boot'
        # macOS compatible sed (uses -i '' for in-place editing without backup)
        sed -i '' "/^# frozen_string_literal:/a\\
\\
$REQUIRE_LINE
" upmetrics_api/config/application.rb
        echo "   ✓ Added require 'resolv-replace' to upmetrics_api/config/application.rb"
    else
        echo "   ✓ require 'resolv-replace' already exists in application.rb"
    fi
fi

# 4. Setup tmux window or session
if [ "$IN_TMUX" = true ]; then
     echo "🖥️  Creating new window in current session..."
    
    # Check if window already exists
    if tmux list-windows -t "$CURRENT_SESSION" | grep -q "^[0-9]*: $WINDOW_NAME"; then
        echo "   ⚠️  Window '$WINDOW_NAME' exists, recreating..."
        tmux kill-window -t "$CURRENT_SESSION:$WINDOW_NAME"
    fi
    
    # Find the next available window index
    NEXT_INDEX=$(tmux list-windows -t "$CURRENT_SESSION" -F "#{window_index}" | sort -n | tail -1)
    NEXT_INDEX=$((NEXT_INDEX + 1))
    
    # Create new window at the next available index
    tmux new-window -t "$CURRENT_SESSION:$NEXT_INDEX" -n "$WINDOW_NAME" -c "$WORKTREE_PATH"
    
    # Split into panes (60% vim, 40% bottom for services)
    tmux split-window -v -t "$CURRENT_SESSION:$NEXT_INDEX" -c "$WORKTREE_PATH" -p 40
    tmux split-window -h -t "$CURRENT_SESSION:$NEXT_INDEX.1" -c "$WORKTREE_PATH"
    
    # Send commands to panes
    tmux send-keys -t "$CURRENT_SESSION:$NEXT_INDEX.0" "vim ." Enter
    tmux send-keys -t "$CURRENT_SESSION:$NEXT_INDEX.1" "cd upmetrics_client && export $(grep -v '^#' .env | xargs) && yarn dev" Enter
    tmux send-keys -t "$CURRENT_SESSION:$NEXT_INDEX.2" "cd upmetrics_api && bin/rails s" Enter
    
    # Focus on vim pane
    tmux select-pane -t "$CURRENT_SESSION:$NEXT_INDEX.0"
    
    # Switch to the new window
    tmux select-window -t "$CURRENT_SESSION:$NEXT_INDEX"
    
    echo "✅ Window '$WINDOW_NAME' created in session '$CURRENT_SESSION' at index $NEXT_INDEX"
    echo ""
    echo "📝 Quick commands:"
    echo "   Switch to window:  Ctrl+b, w (then select)"
    echo "   Direct jump:       Ctrl+b, :select-window -t $WINDOW_NAME"
    echo "   Next/Prev window:  Ctrl+b, n/p"
    
else
    echo "🖥️  Creating new tmux session: $WINDOW_NAME"
    
    # Not in tmux, create a new session
    SESSION_NAME="wt-$WINDOW_NAME"
    
    # Kill existing session if it exists
    tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
    
    # Create new session with layout
    tmux new-session -d -s "$SESSION_NAME" -n "dev" -c "$WORKTREE_PATH"
    tmux split-window -v -t "$SESSION_NAME:dev" -c "$WORKTREE_PATH" -p 40
    tmux split-window -h -t "$SESSION_NAME:dev.1" -c "$WORKTREE_PATH"
    
    # Send commands to panes
    tmux send-keys -t "$SESSION_NAME:dev.0" "vim ." Enter
    tmux send-keys -t "$SESSION_NAME:dev.1" "yarn dev:client" Enter
    tmux send-keys -t "$SESSION_NAME:dev.2" "yarn dev:api" Enter
    
    # Focus on vim pane
    tmux select-pane -t "$SESSION_NAME:dev.0"
    
    echo "✅ Session '$SESSION_NAME' created!"
    echo ""
    echo "📝 To attach: tmux attach -t $SESSION_NAME"
    
    # Ask to attach
    read -p "Attach to session now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        tmux attach -t "$SESSION_NAME"
    fi
fi
