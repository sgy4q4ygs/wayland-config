autoload -U add-zsh-hook

if [ -f "$CFG/shell/sway-config/cmdpatterns" ]; then
	shellhistoryfilter_hook() {
		shellhistoryfilter.py "$CFG/shell/sway-config/cmdpatterns"\
			&> "$XDG_STATE_HOME/zsh-shellhistoryfilter-hook-log"
	}
	add-zsh-hook zshexit shellhistoryfilter_hook
fi

if [ "$(tty)" = '/dev/tty1' ]; then
	exec sway &> "$XDG_STATE_HOME/sway-log"
fi
