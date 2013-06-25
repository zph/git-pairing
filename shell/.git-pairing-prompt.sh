# bash git pairing prompt support
#     - based on git-prompt.sh @ https://github.com/git/git/tree/master/contrib/completion

__git_pairing_prompt ()
{
  local os=`uname 2>/dev/null`
  case "$os" in
  "MINGW"*|"CYGWIN"*)
    local untracked="*"
    local pull_arrow="-"
    local push_arrow="+"
    ;;
  "Darwin"*)
    local untracked="✶"
    local pull_arrow="▼ "
    local push_arrow="▲ "
    ;;
  "Linux"*|"GNU"*|"FreeBSD"*)
    local untracked="✶"
    local pull_arrow="▼ "
    local push_arrow="▲ "
    ;;
  esac

  local d="$(pwd  2>/dev/null)"; # d = current working directory
  local tb="$(git symbolic-ref HEAD 2>/dev/null)";
  local b="${tb##refs/heads/}"; # b = branch
  local p="$(git config --get user.initials 2>/dev/null)"; # p = pair initials
  local s="$(git status --ignore-submodules --porcelain 2>/dev/null)"; # s = git status
  local r="$(git remote 2>/dev/null)/$b"; # r = remote
  local push_pull="$(git rev-list --left-right $r...HEAD 2>/dev/null)"; # push_pull = list of revisions
  local push_count=0
  local pull_count=0

  if [ -n "$push_pull" ]; then
	  local commit
	  for commit in $push_pull
	  do
		  case "$commit" in
		  "<"*) ((pull_count++)) ;;
		  ">"*) ((push_count++))  ;;
		  esac
	  done
  fi

  # COMPONENTS OF PROMPT
  local b_prompt=""         # branch portion
  local p_prompt=""         # pairing partner initials
  local ahead_r=""          # ahead of remote
  local behind_r=""         # behind remote
  local u_prompt=""         # untracked files
  local d_prompt="$d"       # directory portion

  if [[ "$s" == *\?\?* ]]; then
    u_prompt=" ${untracked}"
  fi
  if [ -n "$p" ]; then
    p_prompt="[${p}]"
  fi
  if [ "$push_count" -gt 0  ]; then
    ahead_r=" ${push_arrow}${push_count}"
  fi
  if [ "$pull_count" -gt 0  ]; then
    behind_r=" ${pull_arrow}${pull_count}"
  fi
  if [ -n "$b" ]; then
    b_prompt="[${b}${ahead_r}${behind_r}${u_prompt}]"
  fi
  if [ -n "$s" ]; then
     PS1="${d_prompt} \[${c_red}\]${b_prompt}\[${c_yellow}\]${p_prompt}\[${c_clear}\] "
  else
     PS1="${d_prompt} \[${c_green}\]${b_prompt}\[${c_yellow}\]${p_prompt}\[${c_clear}\] "

  fi
}

# Color codes to use:
# http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# Likewise, you could always alter your terminal preferences color scheme

# color text on normal background, do not escape color codes here
# escape around whole prompt in PS1
c_red=$(tput setaf 1);
c_green=$(tput setaf 2);
c_yellow=$(tput setaf 3);
c_clear=$(tput sgr0);
# white text on color background
#c_clear () { printf '\e[m'"$*"; }
#c_green () { printf '\e[42;1;37m'"$*"'\e[m'; }
#c_yellow () { printf '\e[43;1;37m'"$*"'\e[m'; }
#c_red () { printf '\e[41;1;37m'"$*"'\e[m'; }


