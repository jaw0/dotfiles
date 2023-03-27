# -*- mode: shell-script -*-
# Author: Jeff Weisberg <jaw @ tcp4me.com>
# Created: 2012-Dec-13 21:15 (EST)
# Function: bashrc

XPATH=$PATH
PATH=~/bin
PATH=$PATH:/usr/local/cross-arm-720/bin
PATH=$PATH:/usr/pkg/bin:/usr/local/bin
PATH=$PATH:/usr/X11R6/bin:/usr/X11R7/bin
PATH=$PATH:/usr/bin:/bin
PATH=$PATH:/usr/pkg/sbin:/usr/local/sbin:/opt/homebrew/bin
PATH=$PATH:/usr/sbin:/sbin
PATH=$PATH:$XPATH
export PATH

alias psw="ps axuww | less"
alias las="last -10"
alias ls="ls -FC"
alias ll="ls -Falh"
alias lz="ls -FalhSr"
alias c=clear
alias j="jobs -l"
alias s=less
alias his="history |sort -dub -k2 |sort -nrb | less"
alias md=mkdir
alias rd="rm -r"
alias m=make
alias \!=his
alias dt='date +"%r %a %d %h 20%y"'
alias up=uptime
alias em=emacs
alias eq="emacs -Q -nw"
alias g=egrep
alias l=ls
alias h=head
alias t=tail
alias null='cat >/dev/null'
alias pd="perl -de 0"
alias te=traceroute
alias te6=traceroute6
alias srch='find . -type d -name .git -prune -o -type f -print0 |xargs -0 grep -s'
alias z=zcat
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias ssh="ssh -Y"

alias ddsql="psql -h sql1-deduce.postgres.database.azure.com dddb dduser@sql1-deduce.postgres.database.azure.com"
alias itsync='rsync -av --size-only --exclude=/Podcasts "/Users/jaw/Music/Music/Media.localized/Music/" ithena:/home/mp3'


psg(){ ps axuww | grep $* | grep -v grep; }
ff(){ find . -name "$@" -print; }
q(){ quote -qbr $* | more -r; }


################################################################

_cd(){
  if [ "$*" = "" ]; then
    builtin cd
  else
    builtin cd "$@"
  fi
}

cd(){ odir="$PWD"; _cd "$@"; echo $PWD; }
dotdot(){ odir="$PWD"; tmp=$(dirname "$PWD"); builtin cd "$tmp"; echo $PWD; }
comma(){  tmp="$PWD"; builtin cd "$odir"; odir="$tmp"; echo $PWD; }
alias ,=comma
alias ..=dotdot
alias ...="cd ../.."
alias ....="cd ../../.."

################################################################

LESS='esgPs?f%f. %lb/%L %pb\%?e?x [Next\: %x]..'	; export LESS
MANPATH=/usr/local/share/man:/usr/pkg/man:/usr/sfw/share/man:/usr/share/man	; export MANPATH
PAGER=less	; export PAGER
VISUAL=emacs	; export VISUAL

HISTFILE=""

export BASH_SILENCE_DEPRECATION_WARNING=1
export CLICOLOR=1 # enable color on mac

################################################################

opsys=`uname -s`                                # OsName
opver=`uname -s`_`uname -r | sed 's/\..*//'`	# OsName_7
hostname=`hostname`
host=`hostname | sed 's/\..*//' | sed s/vagrant-.*/vagrant/`
termtty=`tty | sed 's/.dev.//' | sed 's/tty//'`

################################################################

case $TERM in
    tramp)
        PS1="$ "
        ;;

    dumb)
	if [ $EUID -eq 0 ]; then
            PS1='$host-\l-\u \!# '
        else
            PS1='$host-\l-\u \!% '
        fi
        ;;

    wsvt*)
        # netbsd console (no utf-8)
	if [ $EUID -eq 0 ]; then
	    PS1='\[\e[1;31m\]$host-\l-\u \[\e[1;34m\][\W]\[\e[1;31m\] \!#\[\e[0m\] '
	else
	    PS1='\[\e[1;35m\]$host-\l-\u \[\e[1;34m\][\W]\[\e[1;35m\] \!%\[\e[0m\] '
	fi
        ;;

    eterm*|dumb-emacs*)
        # emacs terminal
        export PAGER=cat
        export GIT_PAGER=cat

	if [ $EUID -eq 0 ]; then
	    # red + blue(directory)
	    PS1='\[\e[1;31m\]$host-\l-\u \[\e[1;34m\][\W]\[\e[1;31m\] \!▶\[\e[0m\] '
	else
	    # purple + blue(directory)
	    PS1='\[\e[1;35m\]$host-\l-\u \[\e[1;34m\][\W]\[\e[1;35m\] \!▶\[\e[0m\] '
	fi
        ;;

    *)
        PROMPT_COMMAND='echo -n "]2;${host} : ${PWD}"'

	if [ $EUID -eq 0 ]; then
	    # red
	    PS1='\[\e[1;31m\]$host-\l-\u \!#▶ \[\e[0m\]'
	else
	    # purple
	    PS1='\[\e[1;35m\]$host-\l-\u \!▶ \[\e[0m\]'
	fi
        ;;
esac

################################################################

[ -f ~/.bashrc.$opsys ] && . ~/.bashrc.$opsys
[ -f ~/.bashrc.$opver ] && . ~/.bashrc.$opver
[ -f ~/.bashrc.$host  ] && . ~/.bashrc.$host
[ -f ~/.bashrc.local  ] && . ~/.bashrc.local

