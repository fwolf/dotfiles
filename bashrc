
####################
# Bash setting
####################


# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate lines in the history. See bash(1) for more options
# 忽略命令行历史的重复命令
export HISTCONTROL=ignoredups
# Add timestamp to history
export HISTTIMEFORMAT='%F %T '
# Extend history size
export HISTSIZE=50000
export HISTFILESIZE=50000

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
export PATH=$PATH\
:~/bin\
:~/bin.private\
:~/bin.public\
:/usr/lib/mutt/


####################
# Prompt
####################


# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

# Comment in the above and uncomment this below for a color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac


# Git PS
# http://github.com/tualatrix/configs/blob/7bcdd4bd8e062f0b94f8bd91f4cd312749604ff1/bashrc
#PS1='`a=$?;if [ $a -ne 0 ]; then echo -n -e "\[\e[01;32;41m\]{$a}"; fi`\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\W`[[ -d .git ]] && echo -n -e "\[\e[33;40m\](branch:$(git branch | sed -e "/^ /d" -e "s/* \(.*\)/\1/"))\[\033[01;32m\]\[\e[00m\]"`\[\033[01;34m\] $ \[\e[00m\]'


####################
# Alias
####################


# Dstat
alias dstat='dstat -cdlmnprsy'


# Git
alias gitlog="git log --date=iso --pretty=medium --stat --color"


# Ls
# Enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi
# Some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'


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
vman () {
	export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
		vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
			-c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
			-c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

	# invoke man page
	man $1

	# we muse unset the PAGER, so regular man pager is used afterwards
	unset PAGER
}

