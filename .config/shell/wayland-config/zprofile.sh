autoload -U add-zsh-hook

if [ -f "$CFG/shell/sway-config/cmdpatterns" ]; then
	shellhistoryfilter_hook() {
		shellhistoryfilter.py "$CFG/shell/sway-config/cmdpatterns"\
			&> "$XDG_STATE_HOME/zsh/shellhistoryfilter_hook"
	}

	add-zsh-hook zshexit shellhistoryfilter_hook
fi

if [ "$(tty)" = '/dev/tty1' ]; then
	exec sway
fi
