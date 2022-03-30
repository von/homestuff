" vifm configuration files
if has("autocmd")
    autocmd BufNewFile,BufRead *.vifm set filetype=vim
    autocmd BufNewFile,BufRead vifmrc set filetype=vim
endif
