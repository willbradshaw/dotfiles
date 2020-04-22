#############################
## CROSS-PLATFORM SETTINGS ##
#############################

#============
# FORMATTING
#============

# Activate readline settings

# Set character encodings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Set default text editor
export EDITOR=vim

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

#Make less (man pages) be colourful
export LESS_TERMCAP_mb=$(printf "\e[1;37m")
export LESS_TERMCAP_md=$(printf "\e[1;37m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;30m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[0;36m")


if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


#=========
# HISTORY
#=========

# Configure history
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
HISTIGNORE="hnote*"
HISTDIR="${HOME}/.history"
mkdir -p ${HISTDIR}

# Used to put notes in a history file
function hnote {
    echo "## NOTE [`date`]: $*" >> $HOME/.history/bash_history-`date +%Y%m%d`
}

# see .prompt for history commands in PROMPT_COMMAND

#=========
# ALIASES
#=========

# Automatic dates (for naming and finding files)
alias today="date +%Y-%m-%d"
alias yesterday="date -d'yesterday' +%Y-%m-%d"
alias tomorrow="date -d'tomorrow' +%Y-%m-%d"

# enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Standard utilities
alias d="du -hs *"
alias mkdir="mkdir -p -v"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias x="xmodmap ~/.Xmodmap"
alias get="sudo apt install"
alias rl="readlink -f"
alias cal="cal -m"

# Git commands
alias gs="git status "
alias gc="git commit "
alias gca="git commit -a "
alias gcm="git commit -m "
alias gcam="git commit -am "
alias gd="git diff"
alias ga="git add"
alias gaa="git add --all"
alias gps="git push"
alias gpl="git pull"
alias g="git"
alias grv="git remote -v"

#==============
# DECOMPRESSION
#==============

function extract()      # Handy Extract Program.
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            #*.zip)       unzip $1        ;;
            *.zip)       7z x $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#==============
# COUNTDOWN
#==============
set bell-style visible
function countdown(){
    date1=$((`date +%s` + $1));
    echo; echo;
    while [ "$date1" -ge `date +%s` ]; do
    echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
    sleep 0.1
    done
    echo; echo; echo;
    printf '\e[?5h'  # Turn on reverse video
    sleep 0.1
    printf '\e[?5l'  # Turn on normal video
    }

#####################
## LAPTOP SETTINGS ##
#####################

if [[ "$HOSTNAME" == "apomorph" ]]; then # Dell XPS13
    export TMPDIR="/tmp"
    export PATH="$HOME/.miniconda/bin:$PATH"
    . ${HOME}/.miniconda/etc/profile.d/conda.sh
    conda activate
    # virtualenvwrapper config
    export PROJECT_HOME=~/dev
    export WORKON_HOME=~/dev/virtualenvs
    # Compose key
    export GTK_IM_MODULE="xim"
fi


##########################
## INTERACTIVE SETTINGS ##
##########################

# If not running interactively, don't do anything
# WARNING: Removing this code block will break remote file transfer operations
# if anything below it prints to stdout
case $- in
    *i*) ;;
      *) return;;
esac

#======
# TMUX
#======

if [[ -n $(which tmux) ]]; then 
    if $(tmux ls | grep -q working); then
        tmux attach -t working
    else
        tmux new -s working
    fi
else
    echo "Failed to load tmux: program unavailable."
fi

#================
# COMMAND PROMPT
#================

source ${HOME}/.prompt
