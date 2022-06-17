# Personal environment file for interactive bash subshells
# ~/.bashrc: executed by bash(1) for non-login shells.
# Aliases, functions, and prompts

# If not running interactively, don't do anything.
case $- in
    *i*) ;;
      *) return;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Some ideas from:
#  https://github.com/sapegin/dotfiles/blob/bash/includes/bash_prompt.bash
# Set the prompts
function bash_prompt() {
  local temp_tty="$(tty)"
  #   Chop off the first five chars of tty (ie /dev/):
  cur_tty="${temp_tty:5}"

  local COLOR1="\[\033[0;32m\]"
  local COLOR2="\[\033[0;34m\]"
  local COLOR3="\[\033[0;32m\]"
  local COLOR4="\[\033[0;33m\]"
  local COLOR5="\[\033[0;31m\]"
  local COLOR6="\[\033[47m\]"
  local COLOR7="\[\033[0;30m\]"
  local COLOR8="\[\033[0;36m\]"
  local NO_COLOR="\[\033[0m\]"

  local COLOR_USER=$NO_COLOR

  case $TERM in
      # This appears to be for Window title:
      # '\[\033]0;<WINDOW_TITLE>\007\]'
      # And this for another `title' that GNU Screen can use for its windows:
      # '\[\033k<GNU SCREEN WINDOW TITLE>\033\\\]'
      xterm*|rxvt*)
          TITLEBAR='\[\033]0;\u@\h:\w\007\]'
          ;;
      screen*)
          TITLEBAR='\[\033k\u@\h\033\\\]'
          ;;
      *)
          TITLEBAR=""
          ;;
  esac

  PROMPT_DIRTRIM=6

  # Override default virtualenv indicator in prompt
  VIRTUAL_ENV_DISABLE_PROMPT=1

  ERROR_CHAR=💥
  PROMPT_SYMBOL=@
  PYTHON_VENV=🐍

  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWSTASHSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_SHOWCOLORHINTS=1

  if [ "$EUID" -eq 0 ]; then # Change prompt colors for root user
      COLOR_USER=$COLOR5
      PROMPT_SYMBOL=💀
  fi

  PS1_PRE="$TITLEBAR"
  PS1_PRE+="${COLOR3}┌${COLOR2}──"
  PS1_POST="(${COLOR_USER}\u${COLOR3}${PROMPT_SYMBOL}${COLOR4}\h${COLOR2}:${NO_COLOR}\w${COLOR2})\${VIRTUAL_ENV:+ ${COLOR2}venv:${NO_COLOR}\$(basename \$VIRTUAL_ENV)}\${branch_clean:+ ${COLOR2}git:${COLOR3}\$branch_clean}\${branch_dirty:+ ${COLOR2}git:${COLOR5}\$branch_dirty}\n\
${COLOR3}└${COLOR2}─\${error_prompt:+${COLOR5}}\${ok_prompt:+${COLOR1}}\$${NO_COLOR} "
  PS1="${PS1_PRE}"
  PS1+="${PS1_POST}"

  _PS1="$TITLEBAR\
$COLOR3-$COLOR2-(\
$NO_COLOR\u$COLOR2@$NO_COLOR\h$COLOR2:$NO_COLOR\$NEW_PWD\
$COLOR2)-$COLOR3-\
\n\
$COLOR3-$COLOR2-(\
$NO_COLOR\D{%Y/%m/%d %H:%M:%S %Z} \$cur_tty \j +${SHLVL}\
$COLOR2)$COLOR1\\$ $COLOR2-$COLOR3-$NO_COLOR "

  PS2="$COLOR2-$COLOR3-$COLOR3-$NO_COLOR "

}

function bash_prompt_command() {
  #history -a
  #echo -e "sgr0\ncnorm\nrmso"|tput -S # What does this do?
  ## How many characters of the $PWD should be kept
  ##local pwdmaxlen=80
  #local pwdmaxlen=70
  ## Indicate that there has been dir truncation
  #local trunc_symbol="..."
  #local dir=${PWD##*/}
  #pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
  #NEW_PWD=${PWD/#$HOME/\~}
  #local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
  #if [ ${pwdoffset} -gt "0" ]
  #then
  #  NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
  #  NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
  #fi

  _ERROR=$? # First thing to do is capture $?
  if [ $_ERROR -eq 0 ]
  then
    ok_prompt=1
    error_prompt=
  else
    ok_prompt=
    error_prompt=1
  fi

  branch_clean=
  branch_dirty=
  if [[ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    # Branch name
    local branch="$(git symbolic-ref HEAD 2>/dev/null)"
    branch="${branch##refs/heads/}"

    # Working tree status (red when dirty)
    local dirty=
    # Modified files
    git diff --no-ext-diff --quiet --exit-code --ignore-submodules 2>/dev/null || dirty=1
    # Untracked files
    [ -z "$dirty" ] && test -n "$(git status --porcelain)" && dirty=1

    # Format Git info
    if [ -n "$dirty" ]; then
      branch_dirty="$branch"
      branch_clean=
    else
      branch_dirty=
      branch_clean="$branch"
    fi
  fi

  local NEWLINE_BEFORE_PROMPT=yes
  [ "$NEWLINE_BEFORE_PROMPT" = yes ] && echo
}

#PROMPT_COMMAND='__git_ps1 "\n${PS1_PRE}\$(export _ERROR=\$VIRTUAL_ENV)" "${PS1_POST}" "[\[\033[0m\]%s\[\033[0;34m\]]"'
PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

# Prevent ^C from being echoed
stty -ctlecho

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2048
HISTFILESIZE=2048

# Append rather than overwrite history on exit
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

set -o vi
