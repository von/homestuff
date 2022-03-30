# Configuration for midnight-commander
# See ../../mc/

if test -d ${HOMEBREW_PREFIX}/Cellar/midnight-commander ; then
  # Set MC_EXT_D for use in ../../mc/mc.ext
  # cd /tmp to avoid error if current directory does not exist
  export MC_EXT_D=$(cd /tmp && find ${HOMEBREW_PREFIX}/Cellar/midnight-commander -ipath \*/ext.d | tail -1)
fi
