# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
export EDITOR=vim
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#############
## HISTORY ##
#############

# don't put duplicate lines in the history. See bash(1) for more options
# export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
## history logging

HISTIGNORE="hnote*"
# Used to put notes in a history file
function hnote {
    echo "## NOTE [`date`]: $*" >> $HOME/.history/bash_history-`date +%Y%m%d`
}
# used to keep my history forever
PROMPT_COMMAND="[ -d $HOME/.history ] || mkdir -p $HOME/.history; echo : [\$(date)] $$ $HOSTNAME $USER \$OLDPWD\; \$(history 1 | sed -E 's/^[[:space:]]+[0-9]*[[:space:]]+//g') >> $HOME/.history/bash_history-\`date +%Y%m%d\`"



###############
## FUNCTIONS ##
###############

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
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

#############
## ALIASES ##
#############

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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#############################
## MACHINE-SPECIFIC CONFIG ##
#############################

if [[ "$HOSTNAME" == "wbradshaw-mpi" ]]; then # MPI laptop
    # set gtk im module to default (to make synapse work)
    export GTK_IM_MODULE=" "
    export SCRIPT_DIR="$HOME/Documents/code"
    export TMPDIR="$HOME/tmp"
    export PATH=$PATH:$SCRIPT_DIR/scripts
    export PATH=$PATH:$SCRIPT_DIR/bio-utils
    # Primify installation
    export PATH=$PATH:$SCRIPT_DIR/primify
    export PRIMIFY_CONFIG_DIR="$SCRIPT_DIR/primify/config"
    export PRIMER3_THERMOPARAMS_DIR="$SCRIPT_DIR/primer3_config"
    # CoMEv Installations
    export PATH=$PATH:$HOME/Applications/bali-phy-3.0-beta1/bin
    export PATH=$PATH:$HOME/Applications/consel/bin
    export PATH=$PATH:$HOME/Applications/FigTree_v1.4.3/bin
    export PATH=$PATH:$HOME/Applications/paml4.8/bin
    export PATH=$PATH:$HOME/Applications/pamlX1.3.1-src/bin
    export PATH=$PATH:$HOME/Applications/prank/bin
    export PATH=$PATH:$HOME/Applications/seaview/bin
    export PATH=$PATH:$HOME/Applications/Tracer_v1.6/bin
    export PATH=$PATH:$HOME/Applications/trimal/bin
    export PATH=$PATH:$HOME/Applications/beast1/bin
    export PATH=$PATH:$HOME/Applications/beast2/bin
    export PATH=$PATH:$HOME/Applications/bpp3.3a/bin
    export PATH=$PATH:$HOME/Applications/SuiteMSA-1.3.22B/bin

elif [[ "$HOSTNAME" == "cluster" ]]; then # || "$SLURM_SUBMIT_HOST" == "cluster" ]]; then # MPI cluster
    # Enable sterm etc.
    source /software/Modules/modules.rc
    export GIT_SSL_NO_VERIFY=1
    # Load standard bioinformatics tools
    module load slurm slurm_scripts primer3 Python BLAST Java FastQC jellyfish
    module load Bowtie2 SPAdes/3.6.1 quast sspace perlthreads SAMtools
    module load Trimmomatic
    export SCRIPT_DIR="$HOME/scripts"
    export PATH="$PATH:$SCRIPT_DIR:$SCRIPT_DIR/primify_:$SCRIPT_DIR/bap_:$SCRIPT_DIR/bio-utils"
    export PATH="$PATH:$HOME/programs/MaSuRCA-2.3.2-CentOS6/bin:$HOME/.Python/2.7/bin"
    # Primer3 installation
    export PRIMIFY_CONFIG_DIR="$SCRIPT_DIR/primify/config"
    # BAP installation
    export SSPACE_PATH="/software/sspace/3.0/SSPACE_Standard_v3.0.pl"
    export GF_PATH="/software/gapfiller/1.10/GapFiller.pl"
    alias sspace="/software/sspace/3.0/SSPACE_Standard_v3.0.pl"
    # Avoid filling default tmpdir
    export TMPDIR="/beegfs/common/tmp/$USER"
    # -- Improved X11 forwarding through GNU Screen (or tmux).
    # If not in screen or tmux, update the DISPLAY cache.
    # If we are, update the value of DISPLAY to be that in the cache.
    # This section is black magic as far as I'm concerned tbh
    function update-x11-forwarding
    {
        if [ -z "$STY" -a -z "$TMUX" ]; then
            echo $DISPLAY > $HOME/.display.txt
        else
            export DISPLAY=`cat $HOME/.display.txt`
        fi
    }
    # This is run before every command.
    preexec() {
        # Don't cause a preexec for PROMPT_COMMAND.
        # Beware!  This fails if PROMPT_COMMAND is a string containing more than one command.
        [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return 
        update-x11-forwarding
        # Debugging.
        #echo DISPLAY = $DISPLAY, display.txt = `cat ~/.display.txt`, STY = $STY, TMUX = $TMUX  
    }
    trap 'preexec' DEBUG;
fi

##################
## OTHER CONFIG ##
##################

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

####################
## PROMPT COMMAND ##
####################

source ~/.git-pairing-prompt.sh
PROMPT_COMMAND=__git_pairing_prompt
# After each command, save and reload history
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

##########
## TMUX ##
##########

if $(tmux ls | grep -q working); then
    tmux attach -t working
else
    tmux new -s working
fi
