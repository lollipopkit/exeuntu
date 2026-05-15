# Auto-switch interactive bash sessions to fish.
if [ -n "$BASH_VERSION" ] && [ -z "$EXEUNTU_KEEP_BASH" ] && [ -z "$EXEUNTU_IN_FISH" ]; then
	case "$-" in
		*i*)
			if command -v fish >/dev/null 2>&1; then
				export EXEUNTU_IN_FISH=1
				exec fish
			fi
			;;
	esac
fi
