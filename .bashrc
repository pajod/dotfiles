# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace

# append to the history file, don't overwrite it
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s histappend checkjobs mailwarn checkwinsize

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=10000

# make less search case-insensitive, do not write .lesshist
export LESS=-i
export LESSHISTFILE=/dev/null

# keep .bash_history clean
export HISTIGNORE='&:bg:fg:ll:h:date'
export HISTCONTROL=ignoreboth:erasedups

# auto logout after n seconds of inactivity
bashpid_tmp=$$
bashppid=$(ps -p $bashpid_tmp -o ppid= 2>/dev/null)
bashpcmd=$(ps -p $bashppid -o command= 2>/dev/null)
if [ "$bashpcmd" == "mc" ] ; then
    # if in mc, disable, as shell will be accessible anyways
    export TMOUT=0
else
    # 20 min
    export TMOUT=1200
fi
unset bashpid_tmp bashppid bashpcmd

# meaningful <tab><tab> output
set visible-stats on

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
   color_prompt=
fi


if [ "$color_prompt" = yes ]; then
    # regular colors
    txtred='\e[0;31m' # Red
    txtgrn='\e[0;32m' # Green
    txtblu='\e[0;34m' # Blue
    txtpur='\e[0;35m' # Purple
    txtcyn='\e[0;36m' # Cyan
    txtwht='\e[0;37m' # White
    # bold colors
    bldred='\e[1;31m' # Red
    bldgrn='\e[1;32m' # Green
    bldblu='\e[1;34m' # Blue
    bldpur='\e[1;35m' # Purple
    bldcyn='\e[1;36m' # Cyan
    bldwht='\e[1;37m' # White
    txtrst='\e[0m'    # Text Reset
    if [ "$(id -u)" = "0" ]; then
        color_user="$bldred"
        mark_user="#"
    else
        color_user="$bldgrn"
        mark_user="\$"
    fi
    # print date as probably first line
    echo -ne "$bldcyn"
    date
    echo -ne "$txtrst"
    PS1="${debian_chroot:+($debian_chroot)}\[$color_user\]\u\[$txtrst\]@\[$bldblu\]\h \[$txtrst\]: \[$bldcyn\]\w\[$txtrst\] \[$color_user\]$mark_user\[$txtrst\] "
else
    if [ "$(id -u)" = "0" ]; then
        mark_user=" !#"
    else
        mark_user=" !\$"
    fi
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\w$mark_user "
fi
unset color_prompt color_user mark_user

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  echo -n "Bash completions.. "
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
  echo "done."
fi

# Report the status of terminated background jobs immediately,
# rather than before the  next  primary prompt.
# This is effective only when job control is enabled.
set -o notify

# upon file create grant no write permissions for group, nothing for others
umask 0027

# force proper encoding
# note: C-style collation can be surprising at times
#export LC_ALL=C.UTF-8
#export LANG=C.UTF-8
#export LANGUAGE=C.UTF-8
export LC_ALL=de_DE.UTF-8
export LANG=de_DE.UTF-8
export LANGUAGE=de_DE.UTF-8
PATH=~/bin:~/sbin:$PATH:.
cd ~
#test -f bin/activate && source bin/activate

####################

function isdef() { eval test -n \"\${$1+1}\"; }
function online() { ping -c1 -w2 example.com > /dev/null 2>&1; }

###### show Url information
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# Modified by Silviu Silaghi (http://docs.opensourcesolutions.ro)
function url-info()
{
doms=$@
if [ $# -eq 0 ]; then
echo -e "No domain given\nTry $0 domain.com domain2.org anyotherdomain.net"
fi
for i in $doms; do
_ip=$(host $i|grep 'has address'|awk {'print $4'})
if [ "$_ip" == "" ]; then
echo -e "\nERROR: $i DNS error or not a valid domain\n"
continue
fi
ip=`echo ${_ip[*]}|tr " " "|"`
echo -e "\nInformation for domain: $i [ $ip ]\nQuerying individual IPs"
 for j in ${_ip[*]}; do
echo -e "\n$j results:"
whois $j |egrep -w 'netname:|descr:|country:'
done
done
}

###### convert binaries
# copyright 2007 - 2010 Christopher Bratusek
function bin2all() { if [[ $1 ]]; then echo -e "binary $1 = octal $(bin2oct $1) \n binary $1 = decimal $(bin2dec $1) \n binary $1 = hexadecimal $(bin2hex $1) \n binary $1 = base32 $(bin2b32 $1) \n binary $1 = base64 $(bin2b64 $1) \n binary $1 = ascii $(bin2asc $1)" ; fi } ;
function bin2asc() { if [[ $1 ]]; then echo -e "\0$(printf %o $((2#$1)))"; fi } ; function bin2b64() { if [[ $1 ]]; then echo "obase=64 ; ibase=2 ; $1" | bc; fi } ; function bin2b32() { if [[ $1 ]]; then echo "obase=32 ; ibase=2 ; $1 " | bc; fi } ; function bin2dec() { if [[ $1 ]]; then echo $((2#$1)); fi } ; function bin2hex() { if [[ $1 ]]; then echo "obase=16 ; ibase=2 ; $1" | bc;  fi } ; function bin2oct() { if [[ $1 ]]; then echo "obase=8 ; ibase=2 ; $1" | bc; fi } ;
###### temperature conversion Copyright 2007 - 2010 Christopher Bratusek
function cel2fah() { if [[ $1 ]]; then echo "scale=2; $1 * 1.8  + 32" | bc; fi } ; function cel2kel() { if [[ $1 ]]; then echo "scale=2; $1 + 237.15" | bc; fi } ; function fah2cel() { if [[ $1 ]]; then echo "scale=2 ; ( $1 - 32  ) / 1.8" | bc; fi } ; function fah2kel() { if [[ $1 ]]; then echo "scale=2; ( $1 + 459.67 ) / 1.8 " | bc; fi } ; function kel2cel() { if [[ $1 ]]; then echo "scale=2; $1 - 273.15" | bc; fi } ; function kel2fah() { if [[ $1 ]]; then echo "scale=2; $1 * 1.8 - 459,67" | bc; fi } ;
function isdef() { eval test -n \"\${$1+1}\"; }

# print some useful info, potentially colored
echo -e "${txtgrn}Hostname:${txtrst} $(hostname -f)"
echo -e "${txtgrn}UTF-8 chars:${txtrst} uuml \U00fc, euro \U20ac, sz \U00df, radio \U2622"
echo -e "${txtgrn}IP:${txtrst} $(ip addr | grep ' inet6* ' | awk '{print $2}' | cut -f1 -d'/' | awk '{printf "%s, ", $1}')"
echo -e "${txtgrn}Memory:${txtrst} $(LC_ALL=C free -oh | grep Mem | awk '{printf "%s free /%s total", $3, $2}' )"
