#!/usr/bin/env bash
# Build and install the patched muxbar used by .config/tmux/tmux.conf.
#
# muxbar is not on crates.io and is configured by editing its own Rust source,
# so every machine needs a clone, our patch, and a cargo build. This script
# makes that idempotent.
#
#   install-muxbar.sh           build and install
#   install-muxbar.sh --check   diagnose an existing install, change nothing

set -euo pipefail

MUXBAR_COMMIT=96b5d86
MUXBAR_SRC=${MUXBAR_SRC:-"$HOME/workspace/muxbar"}
MUXBAR_REPO=https://github.com/Dlurak/muxbar.git

DOTFILES=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
GPU_RS="$DOTFILES/.config/tmux/muxbar/gpu.rs"
PATCH="$DOTFILES/.config/tmux/muxbar/local-changes.patch"

GPU_ICON=$'\U000f08ae'   # 󰢮 nf-md-expansion_card_variant

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '  \033[32mok\033[0m    %s\n' "$*"; }
warn() { printf '  \033[33mwarn\033[0m  %s\n' "$*"; }
bad()  { printf '  \033[31mfail\033[0m  %s\n' "$*"; }

# First line muxbar renders, or empty. muxbar loops forever by design.
muxbar_sample() {
    local bin=$1
    timeout 3 "$bin" 2>/dev/null | head -n 1 || true
}

check() {
    local rc=0

    say "GPU"
    if ! command -v nvidia-smi >/dev/null 2>&1; then
        warn "nvidia-smi not found - the GPU module drops out by design"
        rc=1
    elif ! nvidia-smi --query-gpu=memory.used,memory.total \
              --format=csv,noheader,nounits >/dev/null 2>&1; then
        bad "nvidia-smi present but failing - GPU module will render nothing"
        rc=1
    else
        ok "$(nvidia-smi --query-gpu=name --format=csv,noheader | head -n 1)"
    fi

    say "Source tree"
    if [ ! -d "$MUXBAR_SRC/.git" ]; then
        bad "no clone at $MUXBAR_SRC"
        rc=1
    else
        local head
        head=$(git -C "$MUXBAR_SRC" rev-parse --short HEAD)
        [ "$head" = "$MUXBAR_COMMIT" ] \
            && ok "at pinned commit $MUXBAR_COMMIT" \
            || warn "at $head, pinned is $MUXBAR_COMMIT"
        [ -f "$MUXBAR_SRC/modules/src/modules/gpu.rs" ] \
            && ok "gpu.rs present" \
            || { bad "gpu.rs missing - patch was never applied"; rc=1; }
        grep -q 'GpuMemory' "$MUXBAR_SRC/src/config.rs" 2>/dev/null \
            && ok "GpuMemory wired into config.rs" \
            || { bad "config.rs has no GpuMemory - unpatched source"; rc=1; }
    fi

    say "Binary"
    local bin
    if ! bin=$(command -v muxbar 2>/dev/null); then
        bad "muxbar not on PATH"
        return 1
    fi
    ok "found at $bin"
    case $bin in
        "$HOME/.cargo/bin/muxbar") ok "matches the path in tmux.conf" ;;
        *) warn "tmux.conf runs ~/.cargo/bin/muxbar, not this one" ; rc=1 ;;
    esac
    [ -x "$HOME/.cargo/bin/muxbar" ] || { bad "~/.cargo/bin/muxbar missing"; rc=1; }

    say "Rendered output"
    local out
    out=$(muxbar_sample "${HOME}/.cargo/bin/muxbar")
    if [ -z "$out" ]; then
        bad "produced no output"
        return 1
    fi
    if printf '%s' "$out" | grep -q 'Muxbar'; then
        bad "still renders the upstream \"Muxbar\" text - stale/unpatched binary"
        rc=1
    else
        ok "upstream \"Muxbar\" text is gone"
    fi
    if printf '%s' "$out" | grep -qF "$GPU_ICON"; then
        # icon is a literal char with no regex metachars, so plain grep -o is safe
        ok "GPU module present: $(printf '%s' "$out" \
            | grep -o "$GPU_ICON [0-9.]*%" | head -n 1)"
    else
        bad "no GPU module in output"
        rc=1
    fi

    say "tmux"
    if command -v tmux >/dev/null 2>&1 && tmux info >/dev/null 2>&1; then
        local sr
        sr=$(tmux show -gv status-right 2>/dev/null || true)
        case $sr in
            *muxbar*) ok "status-right runs muxbar" ;;
            *) warn "live status-right does not mention muxbar: ${sr:-<empty>}" ;;
        esac
        warn "if the bar still looks stale, reload: tmux kill-server"
    else
        warn "no tmux server running - nothing to verify"
    fi

    printf '\n'
    [ "$rc" -eq 0 ] \
        && say "All checks passed." \
        || say "Problems found (see fail/warn above); re-run without --check to rebuild."
    return "$rc"
}

install() {
    [ -f "$GPU_RS" ] || { bad "missing $GPU_RS"; exit 1; }
    [ -f "$PATCH" ]  || { bad "missing $PATCH"; exit 1; }
    command -v cargo >/dev/null 2>&1 || { bad "cargo not found - install Rust first"; exit 1; }

    if [ -d "$MUXBAR_SRC/.git" ]; then
        say "Reusing clone at $MUXBAR_SRC"
        git -C "$MUXBAR_SRC" fetch --quiet origin
    else
        say "Cloning into $MUXBAR_SRC"
        mkdir -p "$(dirname "$MUXBAR_SRC")"
        git clone --quiet "$MUXBAR_REPO" "$MUXBAR_SRC"
    fi

    say "Resetting to $MUXBAR_COMMIT"
    # Discards local edits to tracked files so the patch always applies to a
    # pristine tree. gpu.rs is untracked upstream, so it survives and is
    # overwritten below.
    git -C "$MUXBAR_SRC" checkout --quiet --force "$MUXBAR_COMMIT"
    git -C "$MUXBAR_SRC" checkout --quiet -- .

    say "Applying local changes"
    cp "$GPU_RS" "$MUXBAR_SRC/modules/src/modules/gpu.rs"
    git -C "$MUXBAR_SRC" apply "$PATCH"

    say "Building (cargo install --path .)"
    ( cd "$MUXBAR_SRC" && cargo install --quiet --path . )

    printf '\n'
    say "Installed. Verifying:"
    printf '\n'
    check || true
    printf '\n'
    say "Reload tmux to pick it up:  tmux kill-server"
}

case ${1:-} in
    --check|-c) check ;;
    "")         install ;;
    *)          printf 'usage: %s [--check]\n' "${0##*/}" >&2; exit 2 ;;
esac
