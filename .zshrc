if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export PATH="/opt/local/bin:/usr/local/bin:/opt/local/sbin:/usr/local/lib:/opt/local/include:$PATH"

if [ -d "$ZDOTDIR/.func" ]; then
  fpath=($ZDOTDIR/.func $fpath)
  autoload ${fpath[1]}/*(:t)
fi

# source completion file
fpath=(~/.zsh/completions $fpath)

if [ -d "/opt/local/share/zsh/${ZSH_VERSION}/functions" ]; then
  fpath=(/opt/local/share/zsh/${ZSH_VERSION}/functions/ $fpath)
fi

if [ -d "/usr/local/share/zsh/${ZSH_VERSION}/functions" ]; then
  fpath=(/usr/local/share/zsh/${ZSH_VERSION}/functions/ $fpath)
fi

# User configuration

#export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

#alias
source $ZDOTDIR/.zshaliases

#USER zshrc
SAVEHIST=100000
HISTFILE=$ZDOTDIR/.zhistory
HISTSIZE=100000

#####prompt edit
if [ "$USER" = "root" ]
then
  pc=$RED
else
  pc=cyan
fi

#zsh-completions
if [ -e /opt/local/var/macports/software/zsh-completions ]; then
  fpath=(/opt/local/var/macports/software/zsh-completions $fpath)
fi

if [ -e /opt/local/share/zsh/${ZSH_VERSION}/functions ]; then
  fpath=(/opt/local/share/zsh/${ZSH_VERSION}/functions $fpath)
fi

#autoload functions
zle -N peco-tree-vim
bindkey "^t" peco-tree-vim

##case insensitive autocomplete
autoload -U compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi;
##case insensitive autocomplete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2
##zmv
autoload -U zmv

#ignore logout when C-d
setopt IGNORE_EOF
#neglect same command fromm saving history
setopt HIST_IGNORE_DUPS
#share history
setopt SHARE_HISTORY
#reduce blank from history
setopt HIST_REDUCE_BLANKS
#exclude history from saving in zhistory
setopt HIST_NO_STORE
#exclude command starts from blank space from saving in zhistory
setopt HIST_IGNORE_SPACE
#notify background jobs
setopt NOTIFY
#auto-cd
setopt AUTOCD
#add / to directory
setopt auto_param_slash
setopt EXTENDED_GLOB
setopt HIST_IGNORE_ALL_DUPS setopt HIST_FIND_NO_DUPS
#C-w
export WORDCHARS="*?_-.[]~=&;\!#$%^(){}<>"

#DIESTACKSIZE
DIRSTACKSIZE=10
#fignore
fignore=(.o \~)
#LISTMAX
LISTMAX=0
#READNULLCMD
READNULLCMD='less'

#keybind
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
if [ -f $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

export LESS='-i -N -R -g'
export LESSOPEN="export LESSOPEN='|lessfilter.sh %s'"

export FPATH="/opt/local/share/zsh/site-functions/:$FPATH "
if [ -f /opt/local/share/autojump/autojump.zsh ]; then
  . /opt/local/share/autojump/autojump.zsh
fi

function man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;36m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

function peco-select-history() {
local tac
if which tac > /dev/null; then
  tac="tac"
else
  tac="tail -r"
fi
BUFFER=$(\history -n 1 | \
  eval $tac | \
  peco --query "$LBUFFER")
CURSOR=$#BUFFER
zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

#zshrc zcompile
if [ $ZDOTDIR/.zshrc -nt $ZDOTDIR/.zshrc.zwc ]; then
  zcompile $ZDOTDIR/.zshrc
fi

watch=(not me)\

  # tmux auto start
is_screen_running() {
  # tscreen also uses this varariable.
  [ ! -z "$WINDOW" ]
}
is_tmux_runnning() {
  [ ! -z "$TMUX" ]
}
is_screen_or_tmux_running() {
  is_screen_running || is_tmux_runnning
}
shell_has_started_interactively() {
  [ ! -z "$PS1" ]
}
resolve_alias() {
  cmd="$1"
  while \
    whence "$cmd" >/dev/null 2>/dev/null \
    && [ "$(whence "$cmd")" != "$cmd" ]
do
  cmd=$(whence "$cmd")
done
echo "$cmd"
}

if ! is_screen_or_tmux_running && shell_has_started_interactively; then
  for cmd in tmux tscreen screen; do
    if whence $cmd >/dev/null 2>/dev/null; then
      $(resolve_alias "$cmd")
      break
    fi
  done
fi

# go Path
export GOPATH="${HOME}/tests/go"
#export PATH=$PATH:$GOPATH/bin

bindkey '^D' delete-char-or-list
bindkey -r '^[^D'

unsetopt correct_all
unsetopt correct
setopt noclobber

function ssh() {
  if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
    tmux rename-window ${@: -1} # <---- ここ
    command ssh "$@"
    tmux set-window-option automatic-rename "on" 1>/dev/null
  else
    command ssh "$@"
  fi
}
if [ -e /usr/bin/xsel ]; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
  alias tmux-copy='tmux save-buffer - | pbcopy'
fi

# virtualenv
export WORKON_HOME=$HOME/.virtualenvs
if [ -e /opt/local/bin/virtualenvwrapper.sh-2.7 ]; then
  source /opt/local/bin/virtualenvwrapper_lazy.sh-2.7
fi

# kubernetes completion
if [ type kubectl &> /dev/null ]; then
  source <(kubectl completion zsh)
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then source '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then source '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

# rust + go setting
export GOPATH="${HOME}/tests/go"
export PATH="$HOME/.cargo/bin:$GOPATH/bin:$PATH"

if [ type htop &> /dev/null ]; then alias top=htop; fi
