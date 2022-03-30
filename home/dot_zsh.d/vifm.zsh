# vifm.zsh
# Functions for interacting with vifm

# CD in vifm to $PWD
function vifm_cd_pwd() {
  # ":wincmd h" chooses left pane so cd works correctly
  vifm --remote -c ":wincmd h" -c "cd ${(q)PWD}"
}

# CD in vifm 2nd window to $PWD
function vifm_cd_pwd_2() {
  # ":wincmd h" chooses left pane so cd works correctly
  # ":wincmd l" switches us to right pane
  vifm --remote -c ":wincmd h" -c "cd . ${(q)PWD}" -c ":wincmd l"
}

# Set up so we automatically cd in a remote vifm instance each
# time we cd in the current shell.
# Optional argument "-2" causes the second vifm window is changed.
function vifm_cd_setup() {
  # Remove any existing instances of vifm_cd_pwd[_2]
  chpwd_functions=("${(@)chpwd_functions:#vifm_cd_pwd}")
  chpwd_functions=("${(@)chpwd_functions:#vifm_cd_pwd_2}")

  if test "${1}" = "-2" ; then
    vifm_cd_pwd_2
    chpwd_functions+=(vifm_cd_pwd_2)
  else
    vifm_cd_pwd
    chpwd_functions+=(vifm_cd_pwd)
  fi
}
