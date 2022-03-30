# Do a Matrix-inspired display
# Kudos: https://twitter.com/climagic/status/1472931718214651912

function matrix() {
  while :; do
    echo $LINES $COLUMNS $(( $RANDOM % $COLUMNS)) $(printf "\U$(($RANDOM % 500))")
    sleep 0.05
  done | awk '{a[$3]=0;for (x in a){o=a[x];a[x]=a[x]+1;printf "\033[%s;%sH\033[2;32m%s",o,x,$4;printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,$4;if (a[x] >= $1){a[x]=0;} }}'
}
