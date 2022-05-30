" Configuration for chezmoi: https://www.chezmoi.io/
"
augroup ChezmoiAutoApply
  autocmd!
  " Apply dotfiles whenever we save them
  " Kudos: https://www.chezmoi.io/user-guide/tools/editor/#configure-vim-to-run-chezmoi-apply-whenever-you-save-a-dotfile
  autocmd BufWritePost ~/.local/share/chezmoi/* silent! ! chezmoi apply --source-path "%"
augroup END
