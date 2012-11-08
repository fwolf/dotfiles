#! /bin/bash
#====================================================================
#	install.sh
#
#	Copyright (c) 2012, Fwolf <fwolf.aide+fwolfbin@gmail.com>
#	All rights reserved.
#	Distributed under the MIT License.
#	http://opensource.org/licenses/mit-license
#
#	Install these conf & rc file, mostly to $HOME.
#
#	V 0.01, since 2012-10-19, hash: .
#====================================================================


# Begin
TODAY=`date +"%Y%m%d"`

# Custom $IFS to avoid space in file name
# Link: http://stackoverflow.com/questions/1574898/bash-and-filenames-with-spaces
# Link: http://www.cyberciti.biz/tips/handling-filenames-with-spaces-in-bash.html
IFSSAVE=$IFS
IFS=$'\n'


# Add '.' prefix and ln -s to $HOME
function LnToHomeWithDot {
	# Source file full path
	F_SRCE=$DIRDATA$1
	# Source file relative path from $HOME
	F_SRCE=${F_SRCE##$HOME/}

	# Dest file name, with dot
	F_DEST=.$1

	cd $HOME
	if [ -L "$F_DEST" ]; then
		# Check link dest
		if [ "$F_SRCE" != `readlink "$F_DEST"` ]; then
			echo $F_DEST is symbolic link and diff with $F_SRCE.
			mv "$F_DEST" "$F_DEST.bak.$TODAY"
			ln -s "$F_SRCE" "$F_DEST"
		fi
	elif [ -e "$F_DEST" ]; then
		echo $F_DEST exists, replace it.
		mv "$F_DEST" "$F_DEST.bak.$TODAY"
		ln -s "$F_SRCE" "$F_DEST"
	else
		echo Create $F_DEST as symbolic link of $F_SRCE
		ln -s "$F_SRCE" "$F_DEST"
	fi
} # end of func LnToHomeWithDot


# Dir where install script in, also other conf files are here.
DIRDATA=${0%/*}/
pushd . >/dev/null 2>&1
cd $DIRDATA
# Convert path to absolute
DIRDATA=`pwd`/


# Install
LnToHomeWithDot ctags
LnToHomeWithDot tmux.conf
LnToHomeWithDot vim
LnToHomeWithDot vimrc
LnToHomeWithDot Xresources


popd >/dev/null 2>&1

IFS=$IFSSAVE

