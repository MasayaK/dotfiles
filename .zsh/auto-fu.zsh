# zsh automatic complete-word and list-choices

# Originally incr-0.2.zsh
# Incremental completion for zsh
# by y.fujii <y-fujii at mimosa-pudica.net>

# Thank you very much y.fujii!

# Adapted by Takeshi Banse <takebi@laafc.net>
# I want to use it with menu selection.

# To use this,
# 1) source this file.
# % source auto-fu.zsh
# 2) establish `zle-line-init' containing `auto-fu-init' something like below.
# % zle-line-init () {auto-fu-init;}; zle -N zle-line-init
# 3) use the _oldlist completer something like below.
# % zstyle ':completion:*' completer _oldlist _complete
# (If you have a lot of completer, please insert _oldlist before _complete.)
#
# *Optionally* you can use the zcompiled file for a little faster loading on
# every shell startup, if you zcompile the necessary functions.
# *1) zcompile the defined functions. (generates ~/.zsh/auto-fu.zwc)
# % A=/path/to/auto-fu.zsh; (zsh -c "source $A ; auto-fu-zcompile $A ~/.zsh")
# *2) source the zcompiled file instead of this file and some tweaks.
# % source ~/.zsh/auto-fu; auto-fu-install
# *3) establish `zle-line-init' and such (same as a few lines above).
# Note:
# It is approximately *(6~10) faster if zcompiled, according to this result :)
# TIMEFMT="%*E %J"
# 0.041 ( source ./auto-fu.zsh; )
# 0.004 ( source ~/.zsh/auto-fu; auto-fu-install; )

# Configuration
# The auto-fu features can be configured via zstyle.

#     :auto-fu:highlight
#       input
#         A highlight specification used for user input string.
#       completion
#         A highlight specification used for completion string.
#     :auto-fu:var
#       postdisplay
#         An initial indication string for POSTDISPLAY in auto-fu-init.
#       enable
#         A list of zle widget names the automatic complete-word and
#         list-choices to be triggered after its invocation.
#         Only with ALL in 'enable', the 'disable' style has any effect.
#         ALL by default.
#       disable
#         A list of zle widget names you do *NOT* want the complete-word to be
#         triggered. Only used if 'enable' contains ALL. For example,
#           zstyle ':auto-fu:var' enable all
#           zstyle ':auto-fu:var' disable magic-space
#         yields; complete-word will not be triggered after pressing the
#         space-bar, otherwise automatic thing will be taken into account.

# Configuration example

#     zstyle ':auto-fu:highlight' input bold
#     zstyle ':auto-fu:highlight' completion fg=black,bold
#     zstyle ':auto-fu:var' postdisplay $'\n-azfu-'
#     #zstyle ':auto-fu:var' disable magic-space


# XXX: use with the error correction or _match completer.
# If you got the correction errors during auto completing the word, then
# plese do _not_ do `magic-space` or `accept-line`. Insted please do the
# following, `undo` and then hit <tab> or throw away the buffer altogether.
# This applies _match completer with complex patterns, too.
# I'm very sorry for this annonying behaviour.
# (For example, 'ls --bbb' and 'ls --*~^*al*' etc.)

# XXX: ignoreeof semantics changes for overriding ^D.
# You cannot change the ignoreeof option interactively. I'm verry sorry.

# TODO: README
# TODO: refine afu-able-space-p or better.
# TODO: http://d.hatena.ne.jp/tarao/20100531/1275322620
# TODO: pause auto stuff until something happens. ("next magic-space" etc)
# TODO: handle RBUFFER.
# TODO: signal handling during the recursive edit.
# TODO: add afu-viins/afu-vicmd keymaps.
# TODO: handle empty or space characters.
# TODO: cp x /usr/loc
# TODO: region_highlight vs afu-able-p → nil
# TODO: region_highlight vs paste
# TODO: ^C-n could be used as the menu-select-key outside of the menuselect.
# TODO: indicate exact match if possible.
# TODO: for the screen estate, postdisplay could be cleared if it could be,
# after accepted etc.
# TODO: *-directories|all-files may not be enough.
# TODO: postdisplay should be cleared properly after the `send-break`ing.
# TODO: kill-word and yank should be added to the afu_zles.
# TODO: recommend zcompiling.

# History

# v0.0.1.7
# Fix "no such keymap `isearch'" error.
# Thank you very much for the report, mooz and Shougo!

# v0.0.1.6
# Fix `parameter not set`. Thank you very much for the report, Shougo!
# Bug fix.

# v0.0.1.5
# afu+complete-word bug (directory vs others) fix.

# v0.0.1.4
# afu+complete-word bug fixes.

# v0.0.1.3
# Teach ^D and magic-space.

# v0.0.1.2
# Add configuration option and auto-fu-zcompile for a little faster loading.

# v0.0.1.1
# Documentation typo fix.

# v0.0.1
# Initial version.

# Code

afu_zles=( \
  # Zle widgets should be rebinded in the afu keymap. `auto-fu-maybe' to be
  # called after it's invocation, see `afu-initialize-zle-afu'.
  self-insert backward-delete-char backward-kill-word kill-line \
  kill-whole-line magic-space \
)

autoload +X keymap+widget

{
  local code=${functions[keymap+widget]/for w in *
	do
/for w in $afu_zles
  do
  }
  eval "function afu-keymap+widget () { $code }"
}

afu-install () {
  zstyle -t ':auto-fu:var' misc-installed-p || {
    zmodload zsh/parameter 2>/dev/null || {
      echo 'auto-fu:zmodload error. exiting.' >&2; exit -1
    }
    afu-install-isearchmap
    afu-install-eof
  } always {
    zstyle ':auto-fu:var' misc-installed-p yes
  }

  bindkey -N afu emacs
  { "$@" }
  bindkey -M afu "^I" afu+complete-word
  bindkey -M afu "^M" afu+accept-line
  bindkey -M afu "^J" afu+accept-line
  bindkey -M afu "^O" afu+accept-line-and-down-history
  bindkey -M afu "^[a" afu+accept-and-hold
  bindkey -M afu "^X^[" afu+vi-cmd-mode

  bindkey -N afu-vicmd vicmd
  bindkey -M afu-vicmd  "i" afu+vi-ins-mode
}

afu-install-isearchmap () {
  zstyle -t ':auto-fu:var' isearchmap-installed-p || {
    [[ -n ${(M)keymaps:#isearch} ]] && bindkey -M isearch "^M" afu+accept-line
  } always {
    zstyle ':auto-fu:var' isearchmap-installed-p yes
  }
}

afu-install-eof () {
  zstyle -t ':auto-fu:var' eof-installed-p || {
    # fiddle the main(emacs) keymap. The assumption is it propagates down to
    # the afu keymap afterwards.
    if [[ "$options[ignoreeof]" == "on" ]]; then
      bindkey "^D" afu+orf-ignoreeof-deletechar-list
    else
      setopt ignoreeof
      bindkey "^D" afu+orf-exit-deletechar-list
    fi
  } always {
    zstyle ':auto-fu:var' eof-installed-p yes
  }
}

afu-eof-maybe () {
  local eof="$1"; shift
  [[ "$BUFFER" != '' ]] || { $eof; return }
  "$@"
}

afu-ignore-eof () { zle -M "zsh: use 'exit' to exit." }

afu-register-zle-eof () {
  local fun="$1"
  local then="$2"
  local else="${3:-delete-char-or-list}"
  eval "$fun () { afu-eof-maybe $then zle $else }; zle -N $fun"
}
afu-register-zle-eof afu+orf-ignoreeof-deletechar-list afu-ignore-eof
afu-register-zle-eof      afu+orf-exit-deletechar-list exit

afu+vi-ins-mode () { zle -K afu      ; }; zle -N afu+vi-ins-mode
afu+vi-cmd-mode () { zle -K afu-vicmd; }; zle -N afu+vi-cmd-mode

afu-install afu-keymap+widget
function () {
  [[ -z ${AUTO_FU_NOCP-} ]] || return
  # For backward compatibility
  zstyle ':auto-fu:highlight' input bold
  zstyle ':auto-fu:highlight' completion fg=black,bold
  zstyle ':auto-fu:var' postdisplay $'\n-azfu-'
}

declare -a afu_accept_lines

afu-recursive-edit-and-accept () {
  local -a __accepted
  zle recursive-edit -K afu || { zle send-break; return }
  (( ${#${(M)afu_accept_lines:#${__accepted[1]}}} > 1 )) &&
  { zle "${__accepted[@]}"} || { zle accept-line }
}

afu-register-zle-accept-line () {
  local afufun="$1"
  local rawzle=".${afufun#*+}"
  local code=${"$(<=(cat <<"EOT"
  $afufun () {
    __accepted=($WIDGET ${=NUMERIC:+-n $NUMERIC} "$@")
    zle $rawzle && {
      local hi
      zstyle -s ':auto-fu:highlight' input hi
      [[ -z ${hi} ]] || region_highlight=("0 ${#BUFFER} ${hi}")
    }
    return 0
  }
  zle -N $afufun
EOT
  ))"}
  eval "${${code//\$afufun/$afufun}//\$rawzle/$rawzle}"
  afu_accept_lines+=$afufun
}
afu-register-zle-accept-line afu+accept-line
afu-register-zle-accept-line afu+accept-line-and-down-history
afu-register-zle-accept-line afu+accept-and-hold

# Entry point.
auto-fu-init () {
  local auto_fu_init_p=1
  local ps
  {
    local -a region_highlight
    local afu_in_p=0

    zstyle -s ':auto-fu:var' postdisplay ps
    [[ -z ${ps} ]] || POSTDISPLAY="$ps"

    afu-recursive-edit-and-accept
    zle -I
  } always {
    [[ -z ${ps} ]] || POSTDISPLAY=''
  }
}
zle -N auto-fu-init

# Entry point.
auto-fu-on  () { with-afu-gvars zle -K afu   }; zle -N auto-fu-on
auto-fu-off () { with-afu-gvars zle -K emacs }; zle -N auto-fu-off # emacs...?
with-afu-gvars () {
  (( auto_fu_init_p == 1 )) && {
    zle -M "Sorry, can't turn on or off if auto-fu-init is in effect."; return
  }
  typeset -g afu_in_p=0
  region_highlight=()
  "$@"
}

afu-clearing-maybe () {
  region_highlight=()
  if ((afu_in_p == 1)); then
    [[ "$BUFFER" != "$buffer_new" ]] || ((CURSOR != cursor_cur)) &&
    { afu_in_p=0 }
  fi
}

with-afu () {
  local zlefun="$1"; shift
  local -a zs
  : ${(A)zs::=$@}
  afu-clearing-maybe
  ((afu_in_p == 1)) && { afu_in_p=0; BUFFER="$buffer_cur" }
  zle $zlefun && {
    local es ds
    zstyle -a ':auto-fu:var' enable es; (( ${#es} == 0 )) && es=(all)
    if [[ -n ${(M)es:#(#i)all} ]]; then
      zstyle -a ':auto-fu:var' disable ds
      : ${(A)es::=${zs:#(${~${(j.|.)ds}})}}
    fi
    [[ -n ${(M)es:#${zlefun#.}} ]]
  } && { auto-fu-maybe }
}

afu-register-zle-afu () {
  local afufun="$1"
  local rawzle=".${afufun#*+}"
  eval "function $afufun () { with-afu $rawzle $afu_zles; }; zle -N $afufun"
}

afu-initialize-zle-afu () {
  local z
  for z in $afu_zles ;do
    afu-register-zle-afu afu+$z
  done
}
afu-initialize-zle-afu

afu-able-p () {
  local c=$LBUFFER[-1]
  [[ $c == ''  ]] && return 1;
  [[ $c == ' ' ]] && { afu-able-space-p || return 1 && return 0 }
  [[ $c == '.' ]] && return 1;
  [[ $c == '^' ]] && return 1;
  [[ $c == '~' ]] && return 1;
  [[ $c == ')' ]] && return 1;
  return 0
}

afu-able-space-p () {
  [[ -z ${AUTO_FU_NOCP-} ]] &&
    # For backward compatibility.
    { [[ "$WIDGET" == "magic-space" ]] || return 1 }

  # TODO: This is quite iffy guesswork, broken.
  local -a x
  : ${(A)x::=${(z)LBUFFER}}
  #[[ $x[1] != (man|perldoc|ri) ]]
  [[ $x[1] != man ]]
}

auto-fu-maybe () {
  (($PENDING== 0)) && { afu-able-p } && [[ $LBUFFER != *$'\012'*  ]] &&
  { auto-fu }
}

auto-fu () {
  emulate -L zsh
  unsetopt rec_exact
  local LISTMAX=999999

  cursor_cur="$CURSOR"
  buffer_cur="$BUFFER"
  comppostfuncs=(afu-k)
  zle complete-word
  cursor_new="$CURSOR"
  buffer_new="$BUFFER"
  if [[ "$buffer_cur[1,cursor_cur]" == "$buffer_new[1,cursor_cur]" ]];
  then
    CURSOR="$cursor_cur"
    {
      local hi
      zstyle -s ':auto-fu:highlight' completion hi
      [[ -z ${hi} ]] || region_highlight=("$CURSOR $cursor_new ${hi}")
    }

    if [[ "$buffer_cur" != "$buffer_new" ]] || ((cursor_cur != cursor_new))
    then afu_in_p=1; {
      local BUFFER="$buffer_cur"
      local CURSOR="$cursor_cur"
      zle list-choices
    }
    fi
  else
    BUFFER="$buffer_cur"
    CURSOR="$cursor_cur"
    zle list-choices
  fi
}
zle -N auto-fu

function afu-k () {
  ((compstate[list_lines] + BUFFERLINES + 2 > LINES)) && { 
    compstate[list]=''
    zle -M "$compstate[list_lines]($compstate[nmatches]) too many matches..."
  }
}

afu+complete-word () {
  afu-clearing-maybe
  { afu-able-p } || { zle complete-word; return; }

  comppostfuncs=(afu-k)
  if ((afu_in_p == 1)); then
    afu_in_p=0; CURSOR="$cursor_new"
    case $LBUFFER[-1] in
      (=) # --prefix= ⇒ complete-word again for `magic-space'ing the suffix
        zle complete-word ;;
      (/) # path-ish  ⇒ propagate auto-fu if it could be
        { # TODO: this may not be enough.
          local x="${(M)${(@z)"${_lastcomp[tags]}"}:#(*-directories|all-files)}"
          zle complete-word
          [[ -n $x ]] && zle -U "$LBUFFER[-1]"
        };;
      (,) # glob-ish  ⇒ activate the `complete-word''s suffix
        BUFFER="$buffer_cur"; zle complete-word ;;
      (*)
        (( $_lastcomp[nmatches]  > 1 )) &&
          # many matches ⇒ complete-word again to enter the menuselect
          zle complete-word
        (( $_lastcomp[nmatches] == 1 )) &&
          # exact match  ⇒ flag not using _oldlist for the next complete-word
          _lastcomp[nmatches]=0
        ;;
    esac
  else
    [[ $LASTWIDGET == afu+*~afu+complete-word ]] && {
      afu_in_p=0; BUFFER="$buffer_cur"
    }
    zle complete-word
  fi
}
zle -N afu+complete-word

[[ -z ${afu_zcompiling_p-} ]] && unset afu_zles

# NOTE: This is iffy. It dumps the necessary functions into ~/.zsh/auto-fu,
# then zrecompiles it into ~/.zsh/auto-fu.zwc.

afu-clean () {
  local d=${1:-~/.zsh}
  rm -f ${d}/{auto-fu,auto-fu.zwc*(N)}
}

afu-install-installer () {
  local match mbegin mend

  eval ${${${"$(<=(cat <<"EOT"
    auto-fu-install () {
      { $body }
      afu-install
      typeset -ga afu_accept_lines
      afu_accept_lines=($afu_accept_lines)
    }
EOT
  ))"}/\$body/
    $(print -l \
      "# afu's all zle widgets expect own keymap+widgets stuff" \
      ${${${(M)${(@f)"$(zle -l)"}:#(afu+*|auto-fu*)}:#(\
        ${(j.|.)afu_zles/(#b)(*)/afu+$match})}/(#b)(*)/zle -N $match} \
      "# keymap+widget machinaries" \
      ${afu_zles/(#b)(*)/zle -N $match ${match}-by-keymap} \
      ${afu_zles/(#b)(*)/zle -N afu+$match})
    }/\$afu_accept_lines/$afu_accept_lines}
}

auto-fu-zcompile () {
  local afu_zcompiling_p=t

  local s=${1:?Please specify the source file itself.}
  local d=${2:?Please specify the directory for the zcompiled file.}
  local g=${d}/auto-fu
  emulate -L zsh
  setopt extended_glob no_shwordsplit

  echo "** zcompiling auto-fu in ${d} for a little faster startups..."
  { source ${s} >/dev/null 2>&1 } # Paranoid.
  echo "mkdir -p ${d}" | sh -x
  afu-clean ${d}
  afu-install-installer
  echo "* writing code ${g}"
  {
    local -a fs
    : ${(A)fs::=${(Mk)functions:#(*afu*|*auto-fu*|*-by-keymap)}}
    echo "#!zsh"
    echo "# NOTE: Generated from auto-fu.zsh ($0). Please DO NOT EDIT."; echo
    echo "$(functions \
      ${fs:#(afu-register-*|afu-initialize-*|afu-keymap+widget|\
        afu-clean|afu-install-installer|auto-fu-zcompile)})"
  }>! ${d}/auto-fu
  echo -n '* '; autoload -U zrecompile && zrecompile -p -R ${g} && {
    zmodload zsh/datetime
    touch --date="$(strftime "%F %T" $((EPOCHSECONDS - 120)))" ${g}
    [[ -z ${AUTO_FU_ZCOMPILE_NOKEEP-} ]] || { echo "rm -f ${g}" | sh -x }
    echo "** All done."
    echo "** Please update your .zshrc to load the zcompiled file like this,"
    cat <<EOT
-- >8 --
## auto-fu.zsh stuff.
# source ${s/$HOME/~}
{ . ${g/$HOME/~}; auto-fu-install; }
zstyle ':auto-fu:highlight' input bold
zstyle ':auto-fu:highlight' completion fg=black,bold
zstyle ':auto-fu:var' postdisplay $'\n-azfu-'
zle-line-init () {auto-fu-init;}; zle -N zle-line-init
-- 8< --
EOT
  }
}
