#
# Author: Jeff Weisberg <jaw @ tcp4me.com>
# Date modified: almost every day :-)
# Function: csh startup

#
# Set up path, skip the rest for non-interactive shells.
#

if( $?DEBUGGING ) exit

set uname_s = `env PATH=/bin:/usr/bin:/usr/local/bin uname -s`
set uname_m = `env PATH=/bin:/usr/bin:/usr/local/bin uname -m`
set uname_r = `env PATH=/bin:/usr/bin:/usr/local/bin uname -r`
set arch = $uname_m
# set opnet   = `[ -f /usr/opnet/script/opnetpath ] && /usr/opnet/script/opnetpath || echo /usr/opnet`

set path = ( ~/bin )
set path = ( $path /usr/pkg/script /usr/local/script )
set path = ( $path /sw/bin /usr/pkg/bin /usr/local/bin{,/image,/gnu,/X} )

set path = ( $path /usr/X11R6/bin /usr/X11R7/bin /usr/openwin/bin{,/xview} )
set path = ( $path /usr/ccs/bin /opt/gnu/bin )
set path = ( $path /usr/local/lang )
set path = ( $path /usr/bin /bin )
set path = ( $path /usr/local/etc /usr/etc /etc /usr/hosts )
set path = ( $path /usr/local/bin/games /usr/games /usr/local/bin/xhack )
set path = ( $path /usr/lib{,/acct,/uucp} )

set path = ( $path /sw/sbin /usr/pkg/sbin /usr/local/sbin )
set path = ( $path /usr/local/pgsql/bin )
set path = ( $path /usr/sfw/sbin /usr/sfw/bin )
set path = ( $path /usr/sbin /sbin )

set path = ( $path /usr/ucb )

set path = ( $path ~/sysadm )

# for liveramp
set path = ($path  /usr/local/mysql/bin /usr/local/mysql/support-files )
# for arbor
set path = ($path /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin /usr/local/go/bin )

set path = ($path /usr/local/cross-arm-720/bin )


limit coredumpsize 0

if ( ! $?prompt || ! $?term ) then
	setenv OPENWINHOME	/usr/openwin
	setenv XAPPLRESDIR	/usr/openwin/lib/app-defaults/
	setenv LD_LIBRARY_PATH	/usr/X11R6/lib:/usr/local/lib:/usr/lib:/usr/openwin/lib
	setenv XAUTHORITY	~/.Xauthority
	exit
endif

#
# Set shell variables.

set filec
set fignore = 	( .o % .BAK .bak .old \~ ,v )
set history = 	400

maildir >&/dev/null || alias maildir echo
set mail = 	(120 /var/spool/mail/`maildir $user`)
set odir = 	$HOME
set devtty = 	`tty | sed -e s-/dev/-- -e s/tty// -e s/nsole// -e "s/ a//" -e s-ts/-- `

set hostname = `hostname`
switch ($hostname)
    case "*.adcopy-inc.com":
        # with datacenter in prompt
        set host = `hostname | sed 's/\.adcopy-inc.com//'`
        breaksw
    default:
        set host = `hostname | sed 's/\..*//'`
        breaksw
endsw

set opsys =	$uname_s
if( $opsys == SunOS && `echo $uname_r | sed 's/\..*//'` == 5 ) then
    set opsys = Solaris
endif

set cdpath = ( /home/penelope /home/penelope2 ~ /home )

# Command-line aliases

# a ps for every occasion!
alias	psw		"ps axuww | less"
alias	psg		"ps axuw | grep \!* | grep -v grep"
alias   psm 		"ps cgxlw"
alias	pst		"ps axu | head"

alias	las		"last -10"
alias	ls		"ls -FC"
alias	ll		"ls -Fal"
alias   lm		"ll \!* |more"
alias	ff		"find . -name \!* -print"
alias	c		"_cdt; clear"
alias	j		jobs -l
alias   r		more
alias 	s		less
alias	pwd		'echo $cwd'
alias	f		"finger -m"
alias	k		"kill"
alias 	k9		"kill -9"
alias	rm		"rm -i"
alias	cp		"cp -i"
alias	mv		"mv -i"
alias	sc		"source ~$user/.cshrc"
alias	his		"history |sort -dub +1 |sort -nrb +0 | less"
alias   tree 		"find . -type d -print"
alias	z		zcat

alias 	refresh		echo
alias 	_cdt		echo
alias   cdt		cdt

if ( `whoami` == root ) then
    set percent = '#'
else
    set percent = '%'
endif
set prompt = 	"$host-$devtty-`whoami` \!$percent "

#cd enhancements: .. will go up a symlink where you came from; , for toggling
alias   _onentry        'if ( -f .on-entry && -o .on-entry ) source .on-entry'
alias   _onexit         'if ( -f .on-exit  && -o .on-exit  ) source .on-exit'

alias   cd		'_onexit;set odir = "$cwd";""cd \!*;_cdt;echo $cwd;_onentry'
alias   ..		'_onexit;set odir = "$cwd";set tmp = "$cwd:h";""cd "$tmp";_cdt;echo $cwd;_onentry'
alias   ,		'_onexit;set tmp = "$cwd";""cd "$odir";set odir = "$tmp";_cdt;echo $cwd;_onentry'
alias   \?,		'echo $odir'
alias   pu		'set odir = "$cwd";pushd \!*;_cdt;_onentry'
alias   po		'_onexit;set odir = "$cwd";popd; _cdt'

# more alii

alias md        mkdir
alias rd        "rm -r \!*"
alias m         make
alias xl        xloadimage
alias xls       xloadimage stdin
alias mq	"sendmail -bp"
alias \!	his
alias y		"echo You Dumkopf\!"
alias advent	adventure
alias uc	uncompress
alias dt	'date +"%r %a %d %h 20%y"'
alias pg	ping -vlR
alias up	uptime
alias act       acctcom -bh
alias sc	source ~/.cshrc

alias tip     /home/magoo/jaw/bin/tip-rolm

# ok, ok, so I can't type...
alias maikl	mail
alias masil	mail
alias mailk	mail
alias mali	mail
alias maik	mail
alias msil	mail
alias la	ls
alias ld 	ls
alias lsd	ls
alias lsa	ls
alias ccd	cd
alias cdd	cd
alias dc	cd
alias xd	cd
alias xs	cd
alias td	dt
alias mn	man
alias ma	man

alias uu	uuwhere -e
alias look	fdb.awk
alias phone	'look \!* |egrep %\(P\|N\)'
alias me	emacs
alias em	emacs
alias eq        emacs -Q -nw
#alias gv	ghostview
alias rn	trn
alias rlogin	'rlogin \!* -D RDISPLAY=$RDISPLAY'
alias sc2	source ~/.cshrc.pass-2
alias ud	unsetenv DISPLAY
alias rsh	ssh
alias rlogin	slogin

alias usermaint	user-maint.pl
# alias whois	whois -h whois.internic.net
alias vgrind	vgrind -d ~/mcr/vgrindefs
alias note	'vi ~\!*/.opnet-admin/Notes'
alias expire-now	'echo /usr/local/news/bin/news.daily delayrm expireover norotate nostat nologs norenumber nomail | suex su news'
alias newslog	'tail -f /usr/local/news/history'
# alias newslog	'tail -f /var/adm/news-log | awk '"'"'{print $4,$5,$6}'"'"
alias mht	'mail -H|tail'
alias g		egrep
alias l		ls
alias n		newuser
alias h		head
alias t		tail
alias null	'cat >/dev/null'
alias pd	perl -de 0
alias um	usermaint
alias lz	'll \!*|sort +4 -n'
alias radb	rawhois
alias arin	'\whois -h whois.arin.net'
alias rrarin	'\whois -h rr.arin.net'
alias rs	'req -show \!$ | less'
alias te	traceroute
alias rr	'raw_read `grephistory -l \!* | sed'" 's/.*	//'"'` |less'
alias nt	'grep "ME time" newslog|tail \!*|newstime'
alias fx	'fax2ps \!* >/tmp/fax$$.ps && gv /tmp/fax$$.ps'
alias boy	'nroff -man \!* |less'
# alias npanxx	'~/projects/tel-exch/byexchno -Lp'
# alias npanxx	~/projects/tel-exch/bin/td_showinfo
alias exit	'echo You Dumkopf\!'
# alias ckts	'dq -sep " " -all -print id:10 l.status:9 l.e.router:11 l.e.port:5 l.l.ckt.us:17 l.l.dlci.us:4 | sort +1'
alias ckts	'dq -sep : -all -print id l.status l.e.router l.e.port l.l.ckt.us l.l.dlci.us | sort -t: +0 | sort -t: +1 -2 | pfmt -n -F: "~-10A ~9A ~11A ~5A ~(~-17@A~) ~4A"'
alias ppp	suex startppp
alias mkiso	suex mkisofs -v -R -f -l -allow-multidot -relaxed-filenames -allow-lowercase -graft-points
alias q         'quote -qbr \!* |more -r'

# alias print	gs -dNOPAUSE -dBATCH -q -sDEVICE=stcolor -sOutputFile=/dev/unlpt0 /usr/local/share/ghostscript/6.50/lib/stcolor-jw.ps
# see ~/jeff/notes/gs-stp
# alias print	gs -sDEVICE=stp -sModel=escp2-780 -sQuality=360sw -sMediaType=Inkjet -sPaperSize=Letter -sDither=Adaptive -dImageType=1 -dNOPAUSE -dBATCH -q -sOutputFile=/dev/unlpt0

alias cleanprinter escputil -r /dev/ulpt0 -u -c
alias inklevel  escputil -r /dev/ulpt0 -u -i
alias volume	'suex mixerctl -w inputs.dac=\!*,\!*'
#alias x		'setenv DISPLAY rfc1178:0; cd ../src/NetBSD-cvs/src/sys/dev/usb; (em ulpt.c&)'
#alias y		'setenv DISPLAY rfc1178:0; cd ../src/NetBSD-cvs/src/sys/arch/i386/compile/PENELOPE'
alias it		translate -i
alias de		translate -g
alias fr		translate -f
alias IT		translate -I
alias DE		translate -G
alias FR		translate -F
alias port      	'webgrab http://www.iana.org/assignments/port-numbers | g'
alias te6		traceroute6
alias cvsup		'cvs up -d \!* |& g -v "^cvs update:"'
alias srch		'find . -type f -print |xargs grep -s'
alias itsync	   	'rsync -av --size-only --exclude=/Podcasts "/Users/jaw/Music/iTunes/iTunes Music/" athena:/home/mp3'
alias snmptrans	        snmptranslate -IR -Td -On

#alias newdots		"scp 'home.tcp4me.com:{.login*,.logout*,.cshrc*}' ~"
alias newdots		"cd ~/dotfiles ; git pull"

if( $?tcsh ) then
    bindkey '\e' complete-word
    bindkey '^W' backward-delete-word
    set wordchars = \`~!\#\$%\^\*\(\)_-+=\{\}\[\]\|:\'\",./\?
    unset addsuffix
    unset autologout
endif

if ( ! $?PASS2 )          source ~/.cshrc.pass-2
if ( -f ~/.cshrc.$opsys ) source ~/.cshrc.$opsys
if ( -f ~/.cshrc.$arch )  source ~/.cshrc.$arch
if ( -f ~/.cshrc.$host  ) source ~/.cshrc.$host
if ( -f ~/.cshrc.local )  source ~/.cshrc.local

###################################################################
# the following line (_cdt) *must* be at the end
_cdt

