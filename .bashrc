#echo " "
#echo "#################################"
#echo "#################################"
#echo "###"
#echo "### Eric's Custom .bashrc"
#echo "###"
#echo "##################################"
#echo "##################################"
#echo " "

#TERMINAL ANSI COLORS
CLEAR="\033[0m\]"
BOLD="\033[1m\]"
BLACK="\033[30m\]"
RED="\033[31m\]"
GREEN="\033[32m\]"
YELLOW="\033[33m\]"
BLUE="\033[34m\]"
MAGENTA="\033[35m\]"
CYAN="\033[36m\]"
WHITE="\033[37m\]"
URED="\033[4;31m\]"
BRED="\033[41m\]"
BYELLOW="\033[43m\]"
BLINK="\033[5;32m\]"
UNDERLINE="\033[4m\]"
 

#######ALIASES
alias ls="ls -FGhp"
alias lm="ls -alt | less"
alias setup="emacs ~/.bashrc"
alias erichelp="more ~/.help.d/help.txt"
alias pythonhelp="more ~/.help.d/.pythonhelp"
alias wl="emacs -f wl"
alias finder="open -a Finder"
alias emacs="/opt/local/bin/emacs"

#######EXPORTS

export EDITOR="emacs"
export ECLIPSE_HOME="/Applications/Eclipse.app/Contents/Eclipse"
export PATH=$ECLIPSE_HOME:$PATH
export PATH="~/bin/":$PATH
export PATH='/opt/local/lib/mariadb/bin/':$PATH:
export PATH='/opt/local/bin/':$PATH
export CLASSPATH=$CLASSPATH:"./src/":"./"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_31.jdk/Contents/Home"
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export HISTCONTROL=ignoreboth:erasedups
export CPLUS_INCLUDE_PATH="/opt/local/include/SDL2/"":/opt/local/include/SDL2/SDL.h"
export LIBRARY_PATH="/opt/local/lib/"
export LD_LIBRARY_PATH="/opt/local/lib/"

                          

#####SETUP PROMPT
USER="\u"
MACHINE="\h"
DIRECTORY="\\w"
INDICATOR="⚡️"
BACK="\033[48;5;234m"
export PS1="エリック ${DIRECTORY}$ "
#export PS1="${BACK}${RED}エリック ${YELLOW}${DIRECTORY}${INDICATOR}${CLEAR} "

######METHODS
preview () { qlmanage -p "$*" >& /dev/null; }
find () { mdfind "kMDItemDisplayName == '$@'wc"; }

