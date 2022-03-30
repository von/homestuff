" recognize temporary password-store files
" Paths are of the form: /<unique tmp dir>/pass.###/###-name.txt
if has("autocmd")
    autocmd BufNewFile,BufRead */pass.*/*.txt set filetype=pass
endif

