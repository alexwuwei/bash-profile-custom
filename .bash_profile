
# get current branch in git repo
function parse_git_branch() {
  BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ! "${BRANCH}" == "" ]
  then
    STAT=`parse_git_dirty`
    echo "[${BRANCH}${STAT}]"
  else
    echo ""
  fi
}

# get current status of git repo
function parse_git_dirty {
  status=`git status 2>&1 | tee`
  dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  bits=''
  if [ "${renamed}" == "0" ]; then
    bits=">${bits}"
  fi
  if [ "${ahead}" == "0" ]; then
    bits="*${bits}"
  fi
  if [ "${newfile}" == "0" ]; then
    bits="+${bits}"
  fi
  if [ "${untracked}" == "0" ]; then
    bits="?${bits}"
  fi
  if [ "${deleted}" == "0" ]; then
    bits="x${bits}"
  fi
  if [ "${dirty}" == "0" ]; then
    bits="!${bits}"
  fi
  if [ ! "${bits}" == "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}
#colors logic

num_colors=$(tput colors)
if [ num_colors ];then
  txt_black="$(tput setaf 0)" #black
  txt_red="$(tput setaf 1)" #red
  txt_green="$(tput setaf 2)" #green
  txt_yellow="$(tput setaf 3)" #yellow
  txt_blue="$(tput setaf 4)" #blue
  txt_magenta="$(tput setaf 5)" #magenta
  txt_cyan="$(tput setaf 6)" #cyan
  txt_white="$(tput setaf 7)" #white
  txt_reset="$(tput sgr0)" #default foreground color
else
  txt_black="" #black
  txt_red="" #red
  txt_green="" #green
  txt_yellow="" #yellow
  txt_blue="" #blue
  txt_magenta="" #magenta
  txt_cyan="" #cyan
  txt_white="" #white
  txt_reset="" #default foreground color
fi

#custom functions
  #add colors to manuals
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[$txt_green\]") \
    LESS_TERMCAP_md=$(printf "\e[$txt_green\]") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
      man "$@"
}
  #goes into a dir and shows a list of contents
function cl { cd "$@" && ls -a; }
  #makes a dir and goes into it
function mk { mkdir "$@" && cd "$@"; }

# aliases
  #git helpers
alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gp='git pull origin'
alias gpu='git push origin'
alias gcb='git checkout -b'
alias gs='git status'
  #list helpers
alias lls='ls -a' #shows hidden files
alias lals='ls -la' #shows permissions and hidden files
  #dir helpers
alias cd.='cd ..' #back 1
alias cd..='cd ../..' #back 2
alias cd..='cd ../../..' #back 3
alias cd...='cd ../../..' #back 4
alias f='open -a Finder ./' #opens directory in Finder

#exports

export PS1="\[\e[34m\]\A\[\e[m\]\[\e[32m\]\w\[\e[m\]\[\e[31m\]\`parse_git_branch\`\[\e[m\j] "
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
