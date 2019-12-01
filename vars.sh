export CLICOLOR=1
export LC_CTYPE=pt_PT.UTF-8
export LC_ALL=pt_PT.UTF-8
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='di=1;36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
export GREP_COLOR='1;33'
export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/mysql/lib/

#editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='emacsclient -nw'
else
  if [[ $TERM == "xterm" || $TERM == "xterm-color" || $TERM == "rxvt" ]]; then
    alias EDITOR='emacsclient -nw'
  else
    alias EDITOR='emacsclient -nw'
  fi
fi

export PATH=$PATH:/snap/bin
