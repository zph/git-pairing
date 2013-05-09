# bash git pairing prompt support
#     - based on git-prompt.sh @ https://github.com/git/git/tree/master/contrib/completion

#export PS1='  \e[0;32m  [\t \u  \e[0;34m   \W  \e[0;32m  ]  \e[0;32m  \$  \e[m  '
#export PS1='\[\e[0;32m\][\t \u\[\e[0;34m\] \W\[\e[0;32m\]]\[\e[0;32m\]\$\[\e[m\]'


__git_pairing_prompt ()
{
  local c_clear="\[\e[m\]"
  local c_red="\[\e[0;32m\]"
  local c_green="\[\e[0;34m\]"
  local untracked="\[\u2733\]"
  local pull_arrow="\[\u2798\]"
  local push_arrow="\[\u279A\]"

  local d="$(pwd  2>/dev/null)"; # d = current working directory
  local b="$(git symbolic-ref HEAD 2>/dev/null)"; # b = branch
  local p="$(git config --get user.initials 2>/dev/null)"; # p = pair initials
  local s="$(git status --ignore-submodules --porcelain 2>/dev/null)"; # s = git status
  local r="$(git remote >/dev/null 2>/dev/null)/$b"; # r = remote
  local push_pull="$(git rev-list --left-right $r...HEAD 2>/dev/null)"; # push_pull = list of revisions
  local push_count=0
  local pull_count=0

  if [ -n "$push_pull" ]
  then
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
  local prompt=""       # the prompt's final form
  local b_prompt=""     # branch portion
  local p_prompt=""     # pairing partner initials
  local ahead_r=""      # ahead of remote
  local behind_r=""     # behind remote
  local u_prompt=""     # untracked files
  local d_prompt="$d"     # directory portion

  if [ -n "$b" ]; then
    b_prompt=" [${b##refs/heads/}]"
  fi
  if [ -n "$p" ]; then
    p_prompt="${p}"
  fi
  if [ "$push_count" -gt 0  ]; then
    ahead_r=""
  fi
  if [ "$pull_count" -gt 0  ]; then
    behind_r=""
  fi

  prompt+="${d_prompt}"
  prompt+="${b_prompt}"
  prompt+="${p_prompt}"
  prompt+=" "

  # PRINT THE PROMPT ALREADY
  printf "%s" "${prompt}"
}
