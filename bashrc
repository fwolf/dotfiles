
####################
# Bash setting
####################


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Lang environment, same with /etc/environment
#LANG="en_US.UTF-8"
#LANGUAGE="en_US:en_GB:en"
#LC_CTYPE="zh_CN.UTF-8"



# When shell exits, append to history file instead of overwriting it
shopt -s histappend

# Don't put duplicate lines in the history. See bash(1) for more options
# 忽略命令行历史的重复命令和以空格开头的命令
export HISTCONTROL=ignoreboth

# Add timestamp to history
export HISTTIMEFORMAT='[%F %T] '

# Extend history size
export HISTSIZE=10000
export HISTFILESIZE=50000

# Save but NOT reload the history after each command finishes
export PROMPT_COMMAND='
    history -a
    $PROMPT_COMMAND
'

# Write/read history instant, with modifier for adding tty
# 1. Got total line number
# 2. Line number minus 1 to the comment line
# 3. Build sed replace string
# 4. Do replace using sed
#export PROMPT_COMMAND='
#    history -a;\
##   history -n;\
#    TTY=`wc -l $HISTFILE | awk "{print \\$1}"`;\
#    let "TTY -= 1";\
#    TTY=$TTY"s/$/ "`tty | sed -e "s|/dev/||" -e "s|/|_|"`"/";\
#    sed -i -e "$TTY" $HISTFILE;\
#'



# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Numlock
if [ -x /usr/bin/setleds ]; then
    for tty in /dev/tty{1..6}; do
        /usr/bin/setleds -D +num < /dev/tty > /dev/null 2>&1
    done
fi

# Path
export PATH=/usr/local/bin\
:/usr/local/sbin\
:$PATH\
:~/bin\
:~/bin.private\
:~/bin.public\
:~/.local/bin\
:~/.cargo/bin\
:/usr/lib/mutt

# For Fava plugins
export PYTHONPATH=~/dev/bean/plugins\
:~/dev/bean/plugins/autobean\
:$PYTHONPATH

# Terminal type hack
case "$TERM" in
    rxvt-unicode-256color)
        TERM=rxvt-unicode
        ;;
    screen-256color)
        TERM=xterm-color
        ;;
esac

case "$TERM" in
    xterm*|rxvt*)
        # Extra ?
        TERM=xterm-256color
        ;;
    *)
        ;;
esac


####################
# Prompt
####################


# Solve PS1 wrap problem
#
# For dynamic PS1, there must use \$(function) or \$(other statement) in PS1
# define statement. But:
#
# 1. Escape color delimiter \[ and \] must be used DIRECTLY in PS1, use it in
# a function will be useless and get raw string.
#
# 2. Bash prompt length compute will ignore contents between \[ and \], so we
# need these delimiter around all escape color code, and no actual output
# content between delimiter, or bash will got wired wrap problem.
#
# Now, if we want to output colorful content in function, will got problem.
#
# Result: use multi-line \$(check and generate statement), include all things
# which function will do. Also for clean code, escape color is defined with
# delimiter.
#
# @link http://stackoverflow.com/questions/1133031
# @link http://mywiki.wooledge.org/BashFAQ/053
# @link http://stackoverflow.com/questions/6592077


# Define colors
C_CLEAR="\[$(tput sgr0)\]"        # "\033[00m"
C_GREEN="\[$(tput setaf 2)\]"     # "\033[1;32m"
C_YELLOW="\[$(tput setaf 3)\]"    # "\033[0;33m"
C_BLUE="\[$(tput setaf 4)\]"      # "\033[1;34m"
C_BRIGHT="\[$(tput bold)\]"


# Base prompt

# Debian chroot ?
if [ -z "$DEBIAN_CHROOT" ] && [ -r /etc/debian_chroot ]; then
    DEBIAN_CHROOT=$(cat /etc/debian_chroot)
fi

PS1="${DEBIAN_CHROOT:+($DEBIAN_CHROOT)}$C_GREEN$C_BRIGHT\u@\h$C_CLEAR:$C_BLUE$C_BRIGHT\w"


# Add SCM branch info if suitable
PS1=$PS1"\$(
    SCM_BRANCH=''

    if hash git 2>/dev/null && [ -e \"\${PWD}/.git\" ]; then
        SCM_BRANCH=\$(git symbolic-ref HEAD 2>/dev/null | cut -d'/' -f 3)
    elif hash hg 2>/dev/null && [ -d \"\${PWD}/.hg/store\" ]; then
        SCM_BRANCH=\$(hg branch)
    fi

    if [ \"\" != \"\$SCM_BRANCH\" ]; then
        echo -ne \"$C_CLEAR[$C_YELLOW\$SCM_BRANCH$C_CLEAR]\"
    fi
)"


# Prompt tail, clear color
PS1=$PS1"$C_CLEAR\$ "


# Fix PS1 not show problem on old version bash(pre 4.0), actual reason is
# unknown yet.
if [ "4" -gt "${BASH_VERSION%%.*}" ]; then
    PROMPT_COMMAND=$PROMPT_COMMAND'echo -ne ""'
fi


# Git PS
# https://github.com/tualatrix/dotfiles/blob/master/.bashrc_extra
#PS1='`a=$?;if [ $a -ne 0 ]; then echo -n -e "\[\e[01;32;41m\]{$a}"; fi`\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W`B=$(git branch 2>/dev/null | sed -e "/^ /d" -e "s/* \(.*\)/\1/"); if [ "$B" != "" ]; then S="git"; elif [ -e .bzr ]; then S=bzr; elif [ -e .hg ]; then S="hg"; elif [ -e .svn ]; then S="svn"; else S=""; fi; if [ "$S" != "" ]; then if [ "$B" != "" ]; then M=$S:$B; else M=$S; fi; fi; [[ "$M" != "" ]] && echo -n -e "\[\e[33;40m\]($M)\[\033[01;32m\]\[\e[00m\]"`\[\033[01;34m\] $ \[\e[00m\]'


####################
# Alias
####################


# Bash
alias ..='cd ../'
alias ...='cd ../../'


# Dstat
alias dstat='dstat -cdlmnprsy'


# Git
# Normal with lines changed
alias gitlog='git log --date=iso --pretty=medium --stat --color'
# Short, oneline with branch and tag info
alias gitlog1='git log --abbrev-commit --pretty=oneline --graph --decorate'
# Oneline, graph, with author, time and hash
#alias gitlog2='git log --graph --pretty=format":%s %Cgreen%an, %ar %Cred(%h)%Creset"'
# %cr = committer date, change when rebase
alias gitlog2='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
# %ar = author date, solid
alias gitlog2='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --abbrev-commit'


# Ls
# Enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    export CLICOLOR=YES
    if [ "Darwin" == $(uname) ]; then
        export LSCOLORS="Gxfxcxdxbxegedabagacad"
    else
        eval "`dircolors -b`"
        alias ls='ls --color=auto'
    fi
fi
# Some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'


# Mount
alias mount='mount | column -t'


# Others
alias rdesktop='rdesktop -z -x m -a 16 -P'


# Pacman
if [ -x /usr/bin/pacman-color ]; then
    alias pacman='pacman-color'
fi


####################
# Misc
####################


# Libtrash setting
if [ -f /usr/lib/libtrash/libtrash.so ]; then
    export LD_PRELOAD=/usr/lib/libtrash/libtrash.so
    alias TrashOn='export TRASH_OFF=NO'
    alias TrashOff='export TRASH_OFF=YES'
fi
# Execute TrashOff instant after set alias will fail, but why ?
if [ -f /usr/lib/libtrash/libtrash.so ]; then
    TrashOff
fi


# Manpage colorlize
# http://linuxtoy.org/archives/color-manpages.html
# Use VIm as man pager
vman() {
    export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
        vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
            -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
            -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

    # invoke man page
    man $1

    # we muse unset the PAGER, so regular man pager is used afterwards
    unset PAGER
}

