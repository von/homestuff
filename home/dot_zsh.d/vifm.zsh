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

# Use vifm to select and output a list of files
# We use a temporary file because vifm seems to redirect stdout in a way
# such we can't just run 'vifm > list'
function vifm_select_files() {
  local tmpfile=$(mktemp -t vifm_select_files)
  # XXX There will be a flash as vifm switches to echo command. I'm not sure
  #     how avoid this.
  # XXX It would be nice to provide guidance on the 'o' command here, but
  #     -c "echo 'foo'" doesn't seem to work
  vifm -c "nnoremap o :!echo %f:p >> ${tmpfile}<cr>"
  cat ${tmpfile}
  rm -f ${tmpfile}
}

