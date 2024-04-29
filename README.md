# config

`config` is a configuration management system for Linux users. Instructions for how to realize this system are provided below. `base-config` is the instance of `config` that contains files that are most likely to be useful in any Linux instance in the domain(s) a user works in&mdash;modify as desired.

## TODO

- GTK/QT universal theme

## Dependencies

### base-config

- Zsh
- Neovim (lazy.nvim requires Neovim >= 0.8.0)

If `.local/bin/base-config/shellhistoryfilter.py` is used,

- Python

If `.local/bin/base-config/connect-to-wireless-network` is used,

- `wpa_supplicant`
- NetworkManager

### wayland-config

- wl-clipboard (xclip "equivalent")
- Sway
- Foot (installed with Sway if done via package manager)
- A few others including a `dmenu` made compatible with wayland (sway via package manager alleviates this concern)
- brightnessctl (if using laptop)

## Install a config

`.local/bin/base-config/init-any-config` and all `init-more` scripts are supposed to idempotent.

Assign `config_repo` to something like `base-config` or `wayland-config` then do

```shell
cd
git clone --depth 1 https://github.com/dl0461/"$config_repo".git
```

If `config_repo` is not `base-config`

```shell
init-any-config "$config_repo"
```

else

```shell
. "$config_repo/.local/bin/$config_repo/"init-any-config "$config_repo"
```

Now verify all dependencies are installed then logout.

## Use a config

Replace `git [commands]` with `git-"$config_repo" [commands]` to use a config repo.

## Create a config

The name of a config is of the form `*-config`.

### Shell Configuration

```shell
mkdir ~/.config/shell/"$config_repo"
```

This directory can have these files:

#### `init-more`

See `.config/shell/base-config/init-more` for an example `init-more`. This kind of script does tasks that should be done before a `zprofile` is sourced.

#### `cmdpatterns`

This file contains newline delimited Python `Lib/re` compatible regular expressions that denote what shell commands should be kept in `$XDG_STATE_HOME/zsh/histfile`.

#### `zprofile.sh`

This file can have `ssh-add` statements in it.

If `cmdpatterns` is used, this file should have this block in it:

```shell
if [ -f "$CFG/shell/$config_repo/cmdpatterns" ]; then
    shellhistoryfilter_hook() {
        shellhistoryfilter.py "$CFG/shell/$config_repo/cmdpatterns"\
            &> "$XDG_STATE_HOME/zsh-shellhistoryfilter-hook-log"
    }
    add-zsh-hook zshexit shellhistoryfilter_hook
fi
```

#### `zshrc.sh`

This file contains any tasks that should be executed in `.zshrc`.

### Unique Scripts and Binaries

```shell
mkdir ~/.local/bin/"$config_repo"
```

This directory contains any scripts specfic to `$config_repo`. It will have at least one script:

```shell
cat << EOL > ~/.local/bin/"$config_repo/git-$config_repo"
#!/usr/bin/env sh
git --git-dir="$HOME/$config_repo" "$@"
EOL
```

### File Exclusion

Create an exclude template:

```shell
cat << EOL > ~/.config/git/exclude-"$config_repo"
/*

!/.config
/.config/*

!/.config/git
/.config/git/*
!/.config/git/config
!/.config/git/hooks
!/.config/git/exclude-"$config_repo"

!/.config/shell
/.config/shell/*
!/.config/shell/"$config_repo"

!/.local
/.local/*

!/.local/bin
/.local/bin/*
!/.local/bin/"$config_repo"

!/README.md
EOL
```

After an `exclude-"$config_repo"` is edited,

```shell
init-any-config "$config_repo"
```
