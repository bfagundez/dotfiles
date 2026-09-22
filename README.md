# dotfiles
Configuration files

## tmux

Config lives at `.config/tmux/tmux.conf`. Prefix is the backtick (`` ` ``), not `C-b`.
Requires tmux 3.3+ (`display-popup`, `allow-passthrough`); built against 3.7.

### Setup on a new machine

```sh
ln -s ~/workspace/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
```

Reload inside tmux with `` ` `` then `q`.

### Status line (muxbar)

The right side of the status bar is [muxbar](https://github.com/Dlurak/muxbar), a
Rust status line. It is *not* on crates.io and it is configured by editing its own
Rust source, so it has to be built from a clone:

```sh
./scripts/install-muxbar.sh
```

It is idempotent, so it is also the fix when a machine has drifted. To diagnose
without changing anything:

```sh
./scripts/install-muxbar.sh --check
```

The script does the following by hand-equivalent steps:

```sh
git clone https://github.com/Dlurak/muxbar.git ~/workspace/muxbar
cd ~/workspace/muxbar
git checkout 96b5d86                                    # base this config was built on
cp ~/workspace/dotfiles/.config/tmux/muxbar/gpu.rs modules/src/modules/gpu.rs
cp ~/workspace/dotfiles/.config/tmux/muxbar/disk.rs modules/src/modules/disk.rs
git apply ~/workspace/dotfiles/.config/tmux/muxbar/local-changes.patch
cargo install --path .                                  # installs to ~/.cargo/bin/muxbar
```

If the bar still shows a scrolling "Muxbar" after installing, tmux is holding the
old binary: `tmux kill-server`. The GPU module renders only where `nvidia-smi`
works, and its icon needs a Nerd Font in the terminal.

`local-changes.patch` + `gpu.rs` + `disk.rs` are my customizations on top of upstream:
drops the "Muxbar" text module, adds GPU memory and disk-free modules, and wires up
their icons. Without them
you get upstream's default modules; without muxbar entirely, `status-right` is blank
but tmux is otherwise fine.

### Other external bits

The omarchy-only keybinding popup (`omarchy-menu-tmux-keybindings`) is stripped from
this copy so the config is portable. All bindings carry `-N` descriptions, so
`` ` `` + `?` still lists them via tmux's own built-in binding.
