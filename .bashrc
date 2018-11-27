################################
## 1. CROSS-PLATFORM SETTINGS ##
################################

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#============
# FORMATTING
#============

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
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

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

############################
## 2. MPI LAPTOP SETTINGS ##
############################

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
    export PATH="$PATH:$HOME/.linuxbrew/bin"
    # added by Miniconda3 installer
    export PATH="/home/will/miniconda3/bin:$PATH"
    . /home/will/miniconda3/etc/profile.d/conda.sh
    conda activate
    # virtualenvwrapper config
    export PROJECT_HOME=~/dev
    export WORKON_HOME=~/dev/virtualenvs
fi

#############################
## 3. MPI CLUSTER SETTINGS ##
#############################

if [[ "$HOSTNAME" == "amalia" ]]; then # || "$SLURM_SUBMIT_HOST" == "cluster" ]]; then # MPI cluster
    
    if [[ -e /home/mpiage/.bashrc ]]; then  # Horrible hack to see if we're in a shifter image
        export SHIFTER="true"
        export CONTAINER="-(container)"
    else
        export SHIFTER="false"
        export CONTAINER=""
    fi
    export GIT_SSL_NO_VERIFY=1
    export TMPDIR="/beegfs/common/tmp/$USER"

    #==============
    # MODULE SETUP
    #==============

    module() { eval `/usr/bin/modulecmd bash $*`; }
    export -f module

    MODULESHOME=/usr/share/Modules
    export MODULESHOME

    if [ "${LOADEDMODULES:-}" = "" ]; then
        LOADEDMODULES=
        export LOADEDMODULES
    fi

    if [ "${MODULEPATH:-}" = "" ]; then
        MODULEPATH=`sed -n 's/[       #].*$//; /./H; $ { x; s/^\n//; s/\n/:/g; p; }' ${MODULESHOME}/init/.modulespath`
        export MODULEPATH
    fi

    if [ ${BASH_VERSINFO:-0} -ge 3 ] && [ -r ${MODULESHOME}/init/bash_completion ]; then
        . ${MODULESHOME}/init/bash_completion
    fi

    #=================
    # LOADING MODULES
    #=================

    function ml() { # Try to load modules and report results
    unset success failure errors
        for mname in $@; do
            errpath="${TMPDIR}/ml_${mname}"
            module load ${mname} 2> ${errpath}
            if [[ ! -s ${errpath} ]]; then 
                success="${success} ${mname}"
            else
                failure="${failure} ${mname}"
                errors="${errors}\n    $(cat ${errpath})"
            fi
        done
        echo "Modules loaded successfully:${success}."
        if [[ -n $failure ]]; then
            >&2 echo "Modules failed to load:${failure}."
            >&2 echo -e "Error messages:${errors}"
        echo
        fi
    }
 
    module purge
    if [[ $SHIFTER == "false" ]]; then
        source /beegfs/common/software/2017/age-bioinformatics.2017.only.rc # TODO: Update this
        ml slurm shifter blast+
    else
        unset PYTHONHOME PYTHONUSERBASE PYTHONPATH
        #export MODULEPATH=$MODF/general:$MODF/libs:$MODF/bioinformatics:/beegfs/common/software/containers/modules/modulefiles
        ml python java perl fastqc blast bowtie primer3 spades quast trimmomatic samtools
    fi
    # shifter mpiage software containers logins

    #================
    # LOCAL PROGRAMS
    #================

    # Custom scripts
    export SCRIPT_DIR="$HOME/scripts"
    export PATH="$PATH:$SCRIPT_DIR:$SCRIPT_DIR/primify_:$SCRIPT_DIR/bap_:$SCRIPT_DIR/bio-utils"

    # User-installed programs
    export PATH="$PATH:$HOME/applications/MaSuRCA-2.3.2-CentOS6/bin:$HOME/.Python/2.7/bin"
    export PATH="$PATH:$HOME/applications/igblast/bin:$HOME/applications/bioawk"
    export PATH="$PATH:$HOME/applications/jellyfish/bin"
    export PATH="$PATH:$HOME/applications/fsa-1.15.9/bin"
    export PATH="$PATH:$HOME/applications/swipe-2.0.5/bin"
    export PYTHONPATH="$PYTHONPATH:$HOME/applications/jellyfish/lib/python2.7/site-packages" # For jellyfish package

    # IGBLAST Internal Data
    export IGDATA="$HOME/applications/igblast/"
    
    # Primer3 installation
    export PRIMIFY_CONFIG_DIR="$SCRIPT_DIR/primify/config"
    
    # BAP installation
    export SSPACE_PATH="/software/sspace/3.0/SSPACE_Standard_v3.0.pl"
    export GF_PATH="/software/gapfiller/1.10/GapFiller.pl"
    alias sspace="/software/sspace/3.0/SSPACE_Standard_v3.0.pl"

    # get a fancy prompt
    export PROMPT_COMMAND='DIR=`pwd|sed -e "s!$HOME!~!"`; if [ ${#DIR} -gt 30 ]; then CurDir=..${DIR:${#DIR}-28}; else CurDir=$DIR; fi'
    export PS1="\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\$CurDir\$\[\033[00m\] "

fi

#######################
## 4. COMMAND PROMPT ##
#######################

source ${HOME}/.prompt

