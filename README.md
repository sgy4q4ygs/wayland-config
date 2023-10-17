# `*-config`

`*-config` repos are a manifestation of a pattern for user configuration on Linux. There is one repo that contains files used by any instance; it is called `base-config`. Replace `git [commands]` with `git-<*-config repo name> [commands]` to use a `*-config` repo.

This `README.md` is present in all `*-config` repos.

## Dependencies

- Zsh
- Neovim
- Python

## Installation of a `*-config` repo

Assign `config_repo=base-config` (or another repo like `wayland-config`) then do

```shell
cd
git clone --depth 1 https://github.com/dl0461/"$config_repo".git
. "$config_repo"/.local/bin/"$config_repo"/init-any-config "$config_repo"
mv "$config_repo"/.* . && rmdir "$config_repo"
```

, now logout.

## Create a `*-config` repo

### Shell Configuration

```shell
mkdir ~/.config/shell/"$config_repo"
```

This directory can have these files:

- `init-more`

See `.config/shell/base-config/init-more` for an example `init-more`. This kind of script does tasks that should be done before a `zprofile` is sourced.

- `cmdpatterns`

This file contains newline delimited `Lib/re` compatible regular expressions that denote what shell commands should be kept in `$XDG_STATE_HOME/zsh/histfile`.

- `zprofile.sh`

This file can have `ssh-add` statements in it.

If `cmdpatterns` is used, this file should have this block in it:

```shell
if [ -f "$CFG/shell/<*-config repo name>/cmdpatterns" ]; then
    shellhistoryfilter_hook() {
        shellhistoryfilter.py "$CFG/shell/<*-config repo name>/cmdpatterns"\
            &> "$XDG_STATE_HOME/zsh-shellhistoryfilter-hook-log"
    }
    add-zsh-hook zshexit shellhistoryfilter_hook
fi
```

- `zshrc.sh`

This file contains any tasks that should be executed in `.zshrc`.

### Unique Scripts and Binaries

```shell
mkdir ~/.local/bin/"$config_repo"
```

This directory contains any scripts specfic to `$config_repo`. It will have at least one script:

```shell
cat << EOL > ~/.local/bin/"$config_repo"/git-"$config_repo"
#!/usr/bin/env sh
git --git-dir="$HOME"/"$config_repo" "$@"
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
!/.config/git/exclude-<*-config repo name>

!/.config/shell
/.config/shell/*
!/.config/shell/<*-config repo name>

!/.local
/.local/*

!/.local/bin
/.local/bin/*
!/.local/bin/<*-config repo name>

!/README.md
EOL
```

After an `exclude-"$config_repo"` is edited,

```shell
init-any-config "$config_repo"
```
