# OUT: theme/out/tmux.conf
# @@GENERATED@@
set -g status-style "fg=@MUTED@,bg=@BG@"
set -g window-status-separator ""
# While the prefix is held, the whole status row goes blank (#, escapes a comma inside #{?})
setw -g window-status-format "#{?client_prefix,,#[fg=@MUTED@#,bg=@BG@] #I:#W }"
setw -g window-status-current-format "#{?client_prefix,,#[fg=@BG@#,bg=@ACCENT@#,bold] #I:#W }"
setw -g window-status-activity-style "fg=@AMBER@,bold"
set -g status-left "#{?client_prefix,,#[fg=@BG@ bg=@ACCENT@]#[bold] #S #[default] }"
set -g pane-border-style "fg=@SURFACE@"
set -g pane-active-border-style "fg=@ACCENT@"
set -g popup-style "fg=@FG@,bg=@BG@"
set -g popup-border-style "fg=@ACCENT@"
set -g popup-border-lines rounded
set -g mode-style "fg=@BG@,bg=@ACCENT@"
set -g display-panes-colour "@SURFACE2@"
set -g display-panes-active-colour "@ACCENT@"
set -g clock-mode-colour "@ACCENT@"
set -g copy-mode-match-style "fg=@BG@,bg=@AMBER@"
set -g copy-mode-current-match-style "fg=@BG@,bg=@ACCENT@"
set -g menu-style "fg=@FG@,bg=@CARD@"
set -g menu-selected-style "fg=@BG@,bg=@ACCENT@"
set -g menu-border-style "fg=@ACCENT@"
set -g menu-border-lines rounded
set -g message-style "fg=@ACCENT@,bg=@BG@,bold"
set -g message-command-style "fg=@VIOLET@,bg=@BG@,bold"
set -g @thumbs-bg-color '@SURFACE@'
set -g @thumbs-fg-color '@MUTED@'
set -g @thumbs-hint-bg-color '@ACCENT@'
set -g @thumbs-hint-fg-color '@BG@'
set -g @thumbs-select-fg-color '@AMBER@'
