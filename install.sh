#! /bin/bash
#====================================================================
#	install.sh
#
#	Copyright (c) 2012, Fwolf <fwolf.aide+fwolfbin@gmail.com>
#	All rights reserved.
#
#	Distributed under the MIT License.
#	http://opensource.org/licenses/mit-license
#
#	Install these conf & rc file, mostly to $HOME.
#====================================================================


# Begin
TODAY=`date +"%Y%m%d"`

# Custom $IFS to avoid space in file name
# Link: http://stackoverflow.com/questions/1574898/bash-and-filenames-with-spaces
# Link: http://www.cyberciti.biz/tips/handling-filenames-with-spaces-in-bash.html
IFSSAVE=$IFS
IFS=$'\n'


# Create symbolic link
# $1 File to link
# $2 Dest, with or without link name, will auto use original name
function LnFile {
	# Source file full path
	F_SRCE=$DIRDATA$1

	# Add dest filename
	if [[ "${2%/}" == "$2" ]]; then
		# Dest end with filename
		F_DEST=$2
	else
		# Dest end with '/', add original filename to it
		F_DEST=$2`basename $1`
	fi


	if [ -L "$F_DEST" ]; then
		# Check link dest diff
		if [ "$F_SRCE" != `readlink "$F_DEST"` ]; then
			echo $F_DEST is symbolic link and diff with $F_SRCE.
			mv "$F_DEST" "$F_DEST.bak.$TODAY"
			ln -s "$F_SRCE" "$F_DEST"
		fi
	elif [ -e "$F_DEST" ]; then
		# Rename exists file
		echo $F_DEST exists, replace it.
		mv "$F_DEST" "$F_DEST.bak.$TODAY"
		ln -s "$F_SRCE" "$F_DEST"
	else
		# Create new link
		echo Create $F_DEST as symbolic link of $F_SRCE
		ln -s "$F_SRCE" "$F_DEST"
	fi
} # end of func LnFile


# Dir where install script in, also other conf files are here.
DIRDATA=${0%/*}/
pushd . >/dev/null 2>&1
cd $DIRDATA
# Convert path to absolute
DIRDATA=`pwd`/


# Profile
if [[ "$1" == "" ]]; then
	# Use hostname as profile
	PROFILE=`hostname`
else
	PROFILE=$1
fi


# Install
LnFile bash_profile	~/.bash_profile
LnFile bashrc		~/.bashrc
LnFile ctags		~/.ctags
LnFile tmux.conf	~/.tmux.conf
LnFile vim			~/.vim
LnFile vimrc		~/.vimrc


# Install by profile if sub directory exists
if [[ -d "$DIRDATA$PROFILE" ]]; then
	LnFile $PROFILE/Xresources ~/.Xresources
fi


popd >/dev/null 2>&1

IFS=$IFSSAVE

#====================================================================
#	ChangeLog
#
#	V 1.1 / 2012-11-22 / 33397adec1
#		- Add: Profile to manage config for multi computer.
#		- Enh: File link create mechanism.
#
#	V 1.0 / 2012-10-19 / 47ff3e667a
#====================================================================

