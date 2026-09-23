#!/usr/bin/env bash

# tmux-resurrect uses switch-client for active positions. During a detached
# cold start there is no client yet, so apply those selections server-side.
configured_resurrect_dir="$(tmux show-option -gqv @resurrect-dir)"
if [ -n "$configured_resurrect_dir" ]; then
    configured_resurrect_dir="$(printf '%s\n' "$configured_resurrect_dir" |
        sed "s,\$HOME,$HOME,g; s,\$HOSTNAME,$(hostname),g; s,~,$HOME,g")"
    resurrect_last="$configured_resurrect_dir/last"
elif [ -d "$HOME/.tmux/resurrect" ]; then
    resurrect_last="$HOME/.tmux/resurrect/last"
else
    resurrect_last="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect/last"
fi

if [ -f "$resurrect_last" ]; then
    # Restore each window's active pane first.
    awk -F '\t' '$1 == "pane" && $9 == 1 { print $2 "\t" $3 "\t" $6 }' "$resurrect_last" |
        while IFS=$'\t' read -r session_name window_index pane_index; do
            tmux select-pane -t "${session_name}:${window_index}.${pane_index}" 2>/dev/null || true
        done

    # Leave each session on its saved active window.
    awk -F '\t' '$1 == "window" && $5 == 1 { print $2 "\t" $3 }' "$resurrect_last" |
        while IFS=$'\t' read -r session_name window_index; do
            tmux select-window -t "${session_name}:${window_index}" 2>/dev/null || true
        done
fi

# Release ta/tb after all saved selections have been applied.
tmux wait-for -S codex-resurrect-restored
