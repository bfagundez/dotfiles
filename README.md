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
git clone https://github.com/Dlurak/muxbar.git ~/workspace/muxbar
cd ~/workspace/muxbar
git checkout 96b5d86                                    # base this config was built on
cp ~/workspace/dotfiles/.config/tmux/muxbar/gpu.rs modules/src/modules/gpu.rs
git apply ~/workspace/dotfiles/.config/tmux/muxbar/local-changes.patch
cargo install --path .                                  # installs to ~/.cargo/bin/muxbar
```

`local-changes.patch` + `gpu.rs` are my customizations on top of upstream: drops the
"Muxbar" text module, adds a GPU memory module, and wires up its icon. Without them
you get upstream's default modules; without muxbar entirely, `status-right` is blank
but tmux is otherwise fine.

### Other external bits

- `` ` `` + `g` opens `~/workspace/tmux-agent-dashboard/bin/dashboard`. Personal tool,
  not in this repo — the binding just errors if the path is missing.
- The omarchy-only keybinding popup (`omarchy-menu-tmux-keybindings`) is stripped from
  this copy so the config is portable. All bindings carry `-N` descriptions, so
  `` ` `` + `?` still lists them via tmux's own built-in binding.
