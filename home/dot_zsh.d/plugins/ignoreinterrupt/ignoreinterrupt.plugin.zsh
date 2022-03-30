#!/bin/zh
#
# Ignore cntrl-C when on prompt
#
# Because I hit it by mistake too often.

ignoreintr() {
  stty intr undef
}

unignoreintr() {
  stty intr \^C
}

# Add to precmd_functions if not already present
# Kudos: https://stackoverflow.com/a/5203740/197789
if [[ ${precmd_functions[(i)ignoreintr]} -gt ${#precmd_functions} ]] ; then
  precmd_functions+=(ignoreintr)
fi

# Add to preexec_functions if not already present
# Kudos: https://stackoverflow.com/a/5203740/197789
if [[ ${preexec_functions[(i)unignoreintr]} -gt ${#preexec_functions} ]] ; then
  preexec_functions+=(unignoreintr)
fi
