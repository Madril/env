# =======
# GLOBALS
# =======

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/tmp/startlog.$$
    setopt xtrace prompt_subst
fi

LIBRARY=$HOME/Scripts
DOTFILES=$LIBRARY/dotfiles

if [[ "$(uname)" == "Darwin" ]]; then
    platform="Darwin"
    LIBRARY=$HOME/Scripts
    DOTFILES=$LIBRARY/dotfiles
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    platform="Linux"
else
    platform="POSIX"
fi


# ===========================
# LOCALE, TERMINAL AND COLORS
# ===========================

export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

autoload -Uz colors && colors

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [[ "$color_prompt" = yes ]]; then
    case $platform in
        "Darwin")
            PS1="%{$fg_bold[cyan]%}%n@%m%{%f%}:%{$fg_bold[magenta]%}%~%{$reset_color%}%# "
            ;;
        "Linux")
            PS1="%{$fg_bold[green]%}%n@%m%{%f%}:%{$fg_bold[blue]%}%~%{$reset_color%}%# "
            ;;
    esac
else
    PS1="%n@%m:%~%# "
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case $TERM in
xterm*|rxvt*)
    precmd () {print -Pn "\e]0;%n@%m:%~%#\a"}
    ;;
*)
    ;;
esac

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LS_OPTIONS='--color=auto'

case $platform in
    "Darwin")
        export CLICOLOR=1
        export LSCOLORS="gxcxfxdacxDaDaxbadacex"
        alias grep='grep --colour=auto'
        alias fgrep='fgrep --colour=auto'
        alias egrep='egrep --colour=auto'
        ;;
    "Linux")
        export LS_COLORS="di=36;40:ln=32;40:so=35;40:pi=33;40:ex=32;40:bd=1;33;40:cd=1;33;40:su=0;41:sg=0;43:tw=0;42:ow=34;40:"
        eval "$(dircolors -b)" 
        alias ls='ls --color'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
        ;;
esac

# =================
# EDITING & HISTORY
# =================

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=10000000
HISTFILESIZE=10000000
HISTFILE=~/.zsh_history

# =================
# SHELL COMPLETION
# =================
# Use modern completion system

export FPATH=/usr/local/share/zsh-completions:$FPATH
autoload -Uz compinit && compinit -i # ignore permission differences in macOS/brew

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _extensions _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' use-cache on


zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

case $platform in
    "Darwin")
        zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,comm'
        ;;
    "Linux")
        zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
        ;;
esac

autoload -U +X bashcompinit && bashcompinit # Bash completion compatibility

# =================
# LANGUAGE RUNTIMES
# =================

# Python

# Handle tools installed with pip3 install --user (update this with every macOS release)
if [ -d $HOME/Library/Python/3.11/bin ]; then
    export PATH="$HOME/Library/Python/3.11/bin:$PATH"
fi

# brew-driven installs
if [ -d $HOME/.pyenv ]; then
    # Check ~/.zprofile for other exports
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)" 

    # Enable building pypy and others via brew
    case $platform in
        "Darwin")
        #export CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include"
        #export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix bzip2)/lib -L$(brew --prefix readline)/lib" 
        #export CFLAGS="-I/usr/local/opt/openssl@1.1/include -I/usr/local/opt/bzip2/include -I/usr/local/opt/readline/include -I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include"
        #export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib -L/usr/local/opt/bzip2/lib -L/usr/local/opt/readline/lib"
        export CFLAGS="$CFLAGS -I/opt/homebrew/include" # -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include $CFLAGS"
        export LDFLAGS="$LDFLAGS -L/opt/homebrew/lib"
        ;;
    esac
fi

if [ -d $HOME/.local/bin ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# NodeJS

# brew-driven installs
if [ -d $HOME/.nodenv ]; then
    eval "$(nodenv init -)"
    # Drop platform-specific tweaks here
    case $platform in
         "Darwin")
         ;;
    esac
fi

# Java (OpenJDK from brew)
case $platform in
    "Darwin")
    if [ -d /opt/homebrew/opt/openjdk ]; then
        export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
        export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
    fi
    ;;
esac

# Golang
export GOPATH=$HOME/go

if [ -d /usr/local/go ]; then
    export PATH=$PATH:/usr/local/go/bin
fi
export GOPATH=$LIBRARY/gocode

export PATH=$GOPATH/bin:$HOME/.local/bin:$PATH
export GOPRIVATE=*.worten.net

# NodeJS
NPM_PACKAGES=$LIBRARY/npm-packages
if [ -d $NPM_PACKAGES ]; then
    npm config set prefix $NPM_PACKAGES
    # Make private binaries take precedence
    export PATH=$NPM_PACKAGES/bin:$PATH

    # Unset manpath so we can inherit from /etc/manpath via the `manpath` command
    unset MANPATH # delete if you already modified MANPATH elsewhere in your config
    export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
fi
export NODE_PATH=$NODE_PATH:/usr/local/lib/node
export PATH=$PATH:/usr/local/share/npm/bin

# Rust
if [ -d $HOME/.cargo ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Lua
if [ -d $HOME/.luarocks ]; then
  export PATH="$HOME/.luarocks/bin:$PATH"
fi

# Generic binaries

if [ -d $HOME/.bin ]; then
  export PATH="$HOME/.bin:$PATH"
fi

# =============
# DOCKER IN WSL
# =============

case $platform in
    "Linux")
        # this assumes you have "$USER ALL=(ALL) NOPASSWD: /usr/bin/dockerd" in /etc/sudoers.d/docker
        if [ -d /mnt/c ]; then
            export LIBGL_ALWAYS_INDIRECT=1
            #export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
            if [ -z `pidof dockerd` ]; then
                echo "Starting docker daemon in background."
                sudo dockerd > /dev/null 2>&1 &
                disown
            fi
        fi
        ;;
esac

# =======
# ALIASES
# =======

export EDITOR=emacs

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

case $platform in
    "Darwin")
        alias flush-dns-cache="echo 'su - admin\nsudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'"
        alias brew="echo 'REMEMBER TO RUN HOMEBREW AS ADMIN'"
        export PATH=$PATH:/Aplications/Xcode.app/Contents/Developer/usr/bin:/Library/Developer/CommandLineTools/usr/bin
        alias code='open -a Visual\ Studio\ Code "$@"'
        alias tt='open -a Textastic "$@"'
        alias brewup='su wrtadmin -c "brew update; brew upgrade; brew cleanup -s; brew doctor"'

        # Go from brew
        export PATH=$PATH:/usr/local/opt/go/libexec/bin

        # Clipboard
        test -z "$(type -p putclip)" -a -n "$(type -p pbcopy)"  && alias putclip=pbcopy
        test -z "$(type -p getclip)" -a -n "$(type -p pbpaste)" && alias getclip=pbpaste
        ;;
    "Linux")
        alias flush-dns-cache='sudo systemd-resolve --flush-caches'
        alias resync-wsl-clock='sudo hwclock -s'
        alias resync-clock='sudo ntpdate pool.ntp.org'
        alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
        [ -x /usr/bin/keychain ] && [ -z ${DISPLAY+x} ] && eval `keychain --agents ssh --eval id_rsa --quiet -Q` 

        # Clipboard
        if [ -n "$(type -p xclip)" ]; then
            test -z "$(type -p putclip)"  && alias putclip="$(type -p xclip) -sel clip -i"
            test -z "$(type -p getclip)"  && alias getclip="$(type -p xclip) -sel clip -o"
            alias xclip='xclip -sel clip'
	    alias pbcopy='xclip -selection clipboard'
	    alias pbpaste='xclip -selection clipboard -o'
        fi
        if [ -c /dev/clipboard -a -w /dev/clipboard ]; then
            test -z "$(type -p getclip)"  &&  alias getclip="cat   /dev/clipboard"
            test -z "$(type -p putclip)"  &&  alias putclip="cat > /dev/clipboard"
        fi
        ;;
esac

unset platform

alias gcm='git checkout master'
alias gcnb='git checkout -b'
alias gc='git checkout'
alias gp='git pull'
alias gpush='git push'
alias gs='git status'
alias b64='pbpaste | base64 -D'
alias gcmp='git checkout master && git pull'

# ======
# EXTRAS
# ======

# yt-dlp -f 'bv[height=1080][ext=mp4]+ba[ext=m4a]' --embed-metadata --merge-output-format mp4 https://www.youtube.com/watch?v=1La4QzGeaaQ -o '%(id)s.mp4'


[ -e $DOTFILES/bin/z.sh ] && source $DOTFILES/bin/z.sh
[ -e $DOTFILES/man ] && export MANPATH=$MANPATH:$DOTFILES/man


if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi
