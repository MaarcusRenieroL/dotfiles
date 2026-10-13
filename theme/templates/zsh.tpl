# OUT: theme/out/zsh.zsh
# @@GENERATED@@
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-} --color=bg:@BG@,bg+:@SURFACE@,fg:@MUTED@,fg+:@FG@,hl:@ACCENT@,hl+:@ACCENT_BRIGHT@,info:@MUTED@,prompt:@ACCENT@,pointer:@ACCENT@,marker:@AMBER@,spinner:@ACCENT@,header:@MUTED@,border:@SURFACE2@"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=@OVERLAY@"
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=@ACCENT@'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=@ACCENT@'
ZSH_HIGHLIGHT_STYLES[alias]='fg=@ACCENT@'
ZSH_HIGHLIGHT_STYLES[function]='fg=@ACCENT@'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=@ACCENT@,underline'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=@ACCENT@'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=@RED@'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=@VIOLET@'
ZSH_HIGHLIGHT_STYLES[path]='fg=@FG@,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=@AMBER@'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=@AMBER@'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=@AMBER@'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=@MUTED@'
ZSH_HIGHLIGHT_STYLES[comment]='fg=@COMMENT@'

export EZA_COLORS="di=38;2;@ACCENT_RGB@:ln=38;2;@CYAN_RGB@:ex=38;2;@VIOLET_RGB@:so=38;2;@AMBER_RGB@:uu=38;2;@MUTED_RGB@:gu=38;2;@MUTED_RGB@:da=38;2;@COMMENT_RGB@:sn=38;2;@BLUE_RGB@:sb=38;2;@BLUE_RGB@:ur=38;2;@FG_RGB@:uw=38;2;@AMBER_RGB@:ux=38;2;@ACCENT_RGB@:gr=38;2;@FG_RGB@:gw=38;2;@AMBER_RGB@:gx=38;2;@ACCENT_RGB@:tr=38;2;@FG_RGB@:tw=38;2;@AMBER_RGB@:tx=38;2;@ACCENT_RGB@:xx=38;2;@OVERLAY_RGB@:lc=38;2;@RED_RGB@:lm=38;2;@RED_RGB@:ga=38;2;@ACCENT_RGB@:gm=38;2;@AMBER_RGB@:gd=38;2;@RED_RGB@:gv=38;2;@VIOLET_RGB@:gt=38;2;@BLUE_RGB@"

zstyle ':fzf-tab:*' fzf-flags --color=bg:@BG@,bg+:@SURFACE@,fg:@MUTED@,fg+:@FG@,hl:@ACCENT@,hl+:@ACCENT_BRIGHT@,prompt:@ACCENT@,pointer:@ACCENT@,border:@ACCENT@ --border=rounded
