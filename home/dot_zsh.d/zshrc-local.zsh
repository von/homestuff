# Source local Zsh configuration
# (N) causes zsh to return empty list if no matches
for file in ~/.zshrc.local/*.zsh(N) ; do
  source ${file}
done
