# bash git pairing prompt support
#     - based on git-prompt.sh @ https://github.com/git/git/tree/master/contrib/completion

__git_pairing_prompt ()
{
  local c_clear="\[\e[m\]"
  local c_red="\[\e[0;32m\]"
  local c_green="\[\e[0;34m\]"
  local untracked="\[\u2733\]"
  local pull_arrow="\x25BE" #"\xE2\x96\xB4"
  local push_arrow="\x25B4" #\xE2\x96\xBE"

  local d="$(pwd  2>/dev/null)"; # d = current working directory
  local tb="$(git symbolic-ref HEAD 2>/dev/null)";
  local b="${tb##refs/heads/}"; # b = branch
  local p="$(git config --get user.initials 2>/dev/null)"; # p = pair initials
  local s="$(git status --ignore-submodules --porcelain 2>/dev/null)"; # s = git status
  local r="$(git remote 2>/dev/null)/$b"; # r = remote
  local push_pull="$(git rev-list --left-right $r...HEAD 2>/dev/null)"; # push_pull = list of revisions
  local push_count=0
  local pull_count=0

  if [ -n "$push_pull" ]
  then
	  local commit
	  for commit in "$push_pull"
	  do
		  case "$commit" in
		  "<"*) ((pull_count++)) ;;
		  ">"*) ((push_count++))  ;;
		  esac
	  done
  fi

  echo push: $push_count
  echo pull: $pull_count

  # COMPONENTS OF PROMPT
  local prompt=""       # the prompt's final form
  local b_prompt=""     # branch portion
  local p_prompt=""     # pairing partner initials
  local ahead_r=""      # ahead of remote
  local behind_r=""     # behind remote
  local u_prompt=""     # untracked files
  local d_prompt="$d"     # directory portion

  if [ -n "$p" ]; then
    p_prompt="${p}"
  fi
  if [ "$push_count" -gt 0  ]; then
    ahead_r=" ${push_arrow}${push_count}"
  fi
  if [ "$pull_count" -gt 0  ]; then
    behind_r=" ${pull_arrow}${pull_count}"
  fi
  if [ -n "$b" ]; then
    b_prompt=" [${b}${ahead_r}${behind_r}]"
  fi

  prompt+="${d_prompt}"
  prompt+="${b_prompt}"
  prompt+="${p_prompt}"
  prompt+=" "

  # PRINT THE PROMPT ALREADY
  printf "%s" "${prompt}"
}
