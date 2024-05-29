autoload -U add-zsh-hook

export PATH="$PATH:$HOME/.dotnet/tools"

if [ -f "$CFG/shell/sway-config/cmdpatterns" ]; then
	shellhistoryfilter_hook() {
		shellhistoryfilter.py "$CFG/shell/sway-config/cmdpatterns"\
			&> "$XDG_STATE_HOME/zsh-shellhistoryfilter-hook-log"
	}
	add-zsh-hook zshexit shellhistoryfilter_hook
fi

if which sway && [ "$(tty)" = '/dev/tty1' ]; then
# screen casting
# systemctl --user show-environment
# should show: XDG_CURRENT_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway
    systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
	exec sway &> "$XDG_STATE_HOME/sway-log"
fi
