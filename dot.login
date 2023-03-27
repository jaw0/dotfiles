#
# Author: Jeff Weisberg <jaw @ tcp4me.com>
# Function: csh .login

umask 022

if ( $?DEBUGGING ) exit

if( ! $?DISPLAY ) then
    if( $?RDISPLAY ) then
	setenv DISPLAY $RDISPLAY
    else
	#setenv DISPLAY :0
	setenv DISPLAY ody:0
    endif
endif

setenv OPENWINHOME	/usr/openwin
setenv TAPE		/dev/nrst0
setenv LESS		'esgPs?f%f. %lb/%L %pb\%?e?x [Next\: %x]..'
#setenv BSDSRCDIR	/home/penelope/src

switch ( $opsys )
    case "SunOS":
	setenv LD_LIBRARY_PATH	/usr/local/lib:/usr/opnet/lib:/usr/lib:/usr/X11R6/lib:/usr/openwin/lib
	breaksw
    case "NetBSD":
	setenv LD_LIBRARY_PATH	/usr/local/lib:/usr/lib:/usr/X11R6/lib:/usr/openwin/lib
	breaksw
endsw

# setenv MANPATH		/usr/X11R6/man:/usr/openwin/share/man:/usr/local/man:/usr/opnet/man:/usr/share/man
setenv MANPATH		/usr/local/share/man:/usr/pkg/man:/usr/sfw/share/man:/usr/share/man
setenv PAGER		less
setenv RNINIT		~/.rnrc
setenv WIN_NOAUTH	1
setenv AUTHORCOPY	~/mail/posted
setenv VISUAL		emacs
setenv XAPPLRESDIR	/usr/pkg/lib/X11/app-defaults/
setenv XNLSPATH		/usr/opnet/lib/X11/nls
setenv TROFF		groff
setenv TCAT		cat
setenv CVSEDITOR	vi
setenv CVS_RSH		ssh
setenv CVSROOT		:ext:tele:/home/cvs
setenv UMEDITOR		jove
setenv LLEDITOR		jove
setenv LLDATABASES	~/jeff/lines:.
setenv LLPROGRAMS	~/jeff/lines/reports
setenv LLREPORTS	~/jeff/lines/out
setenv LLARCHIVES	~/jeff/lines/out
setenv XAUTHORITY	~/.Xauthority
setenv NNTPSERVER	localhost
setenv MAIL		/var/spool/mail/`maildir $user`
setenv GIT_SSL_NO_VERIFY true


#
# Set terminal type.
# If the terminal type is unknown, ask if it's a vt100.
#

if ( `hostname` == elmo && `tty` == /dev/ttyc || `tty` == /dev/ttyd ) then
	stty parenb
endif

switch ($opsys)
    case "NetBSD":
	stty kerninfo
	stty status ^T
	unsetenv PAGER
	setenv BLOCKSIZE 1024
	unlimit openfiles
	unlimit stack
	unlimit filesize
	# setenv LC_ALL en_US.UTF-8
	breaksw

    case "Solaris":
	breaksw

    case "SunOS":
	unlimit descr
	breaksw

    case "Linux":
	# unlimit descr
	unlimit stack
	unlimit files
	breaksw

    case "Darwin":
	setenv BLOCKSIZE 1024
	breaksw
endsw

if( $opsys != Darwin && $opsys != NetBSD ) then
    switch ($term)
    	case "dialup":
    	    stty crtscts -ixon -ixoff -ixany
    	case "network":
    	case "su":
    	    set term = unknown
    	case "unknown":
    	    breaksw
	case "xterm-color":
	case "xterm-256color":
	    set xterm = "xterm-color"
	    set term  = xterm
    	default:
    	    set noglob ; eval `tset -s -Q $TERM` ; unset noglob
    endsw
endif

if ( ! $?xterm ) then
    set xterm = $term
endif

if ( $term == unknown ) then
	echo "enter terminal type"
	echo "1  sun-cmd"
	echo "2  vt100"
	echo "3  xterm"
	echo "4  PROducer"
	echo "5  GIGI"
	echo "0  other"
	echo -n " : "
	switch ( $< )
	  case "1":
	  case "s":
		set noglob ; eval `tset -s -Q sun-cmd` ; unset noglob
		breaksw
	  case "2":
	  case "v":
		set noglob ; eval `tset -s -Q vt100` ; unset noglob
		breaksw
	  case "3":
	  case "x":
		set noglob ; eval `tset -s -Q xterm` ; unset noglob
		breaksw
	  case "4":
	  case "p":
		set noglob ; eval `tset -s -Q viewpoint` ; unset noglob
		breaksw
	  case "5":
	  case "g":
		set noglob ; eval `tset -s -Q gigi` ; unset noglob
		breaksw
	  case "0":
	  case "o":
	  default:
		while ($TERM == "unknown")
			set noglob ; eval `tset -s -Q ?vt100` ; unset noglob
		end
	endsw
endif

set term = $TERM

if ($term == "sun" || $term == "vt100" || $term == "K5") stty dec
if ($term == "sun" || $term == "xterm") stty erase 
if ($term == "vt100" || $term == "K5") stty rows 24
if ($term != viewpoint && $term != gigi ) stty cs8 -istrip
#if ($term == xterm && $opsys == Solaris ) then
#    # for some reason the tab stops on solaris are not set. set them.
#    echo -n "        H        H        H        H        H        H        H        H        H        H[80D"
#endif

source ~/.cshrc.pass-2

# who/what are we on?
echo $host $uname_s $uname_r $uname_m
# uname -a|awk '{printf "%s %s %s %s ", $2, $5, $1, $3 }'
echo ""
if ( -e ~/.stuff ) cat ~/.stuff

#fortune
echo ""


if ( -f ~/.login.$opsys ) source ~/.login.$opsys
if ( -f ~/.login.$arch )  source ~/.login.$arch
if ( -f ~/.login.$host  ) source ~/.login.$host
if ( -f ~/.login.local  ) source ~/.login.local

