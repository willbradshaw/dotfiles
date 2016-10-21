# bash git pairing prompt support
#     - based on git-prompt.sh @ https://github.com/git/t remote 2>/dev/nullgit/tree/master/contrib/completion

__git_pairing_prompt()
{
    # Uncomment for profiling
    #PS4='+ $(date "+%s.%N")\011 '
    #exec 3>&2 2>/tmp/bashstart.$$.log
    #set -x

    # Colours
    c_red="\033[1;31m";
    c_green="\033[1;32m";
    c_yellow="\033[1;33m";
    c_blue="\033[1;34m";
    c_white="\033[1;37m";
    c_normal="\033[0m";
    # Standard prompt info
    PREFIX="\[${c_green}\]\u@\[${c_yellow}\]\h\[${c_normal}\]:"
    PREFIX="${PREFIX}\[${c_blue}\]\w"
    SUFFIX="\$ \[${c_normal}\]"
    if [[ ! -d .git ]]; then # Not in repo
        PS1="${PREFIX}${SUFFIX}"
    else # In repo
        local d="$(pwd  2>/dev/null)"; # d = current working directory
        local b="$(git rev-parse --abbrev-ref HEAD)" # b = branch
        local s="$(git status --ignore-submodules --porcelain 2>/dev/null)"; # s = git status
        local r="$(git remote 2>/dev/null)/$b"; # r = remote
        local push_pull="$(git rev-list --left-right $r...HEAD 2>/dev/null)"; # push_pull = list of revisions
        local push_count=0
        local pull_count=0

        if [ -n "$push_pull" ]; then
            local commit
            for commit in $push_pull
            do
                case "$commit" in
                    "<"*) ((pull_count++)) ;;
                ">"*) ((push_count++))  ;;
            esac
        done
    fi

    # COMPONENTS OF PROMPT
    local b_prompt=""         # branch portion
    local ahead_r=""          # ahead of remote
    local behind_r=""         # behind remote
    local u_prompt=""         # untracked files
    local d_prompt="$d"       # directory portion
    local untracked="✶"
    local pull_arrow="▼ "
    local push_arrow="▲ "
    if [[ "$s" == *\?\?* ]]; then
        u_prompt=" ${untracked}"
    fi
    if [ "$push_count" -gt 0  ]; then
        ahead_r=" ${push_arrow}${push_count}"
    fi
    if [ "$pull_count" -gt 0  ]; then
        behind_r=" ${pull_arrow}${pull_count}"
    fi
    if [ -n "$b" ]; then
        b_prompt="[${b}${ahead_r}${behind_r}${u_prompt}]"
    fi
    if [[ -n "$s" ]]; then
        PS1="${PREFIX} \[${c_red}\]${b_prompt} ${SUFFIX}"
    else
        PS1="${PREFIX} \[${c_green}\]${b_prompt} ${SUFFIX}"
    fi
fi
# Uncomment for profiling
#set +x
#exec 2>&3 3>&-
}
