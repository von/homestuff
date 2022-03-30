" recognize googlescript (.gs) files
" Use "set filetype=" instead of "setf" to override vim's setting
if has("autocmd")
    autocmd BufNewFile,BufRead *.gs set filetype=javascript
endif
