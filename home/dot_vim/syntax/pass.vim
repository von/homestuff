" Syntax highlighting for Password store files

" Conceal the first line with an asterisk
" Kudos: Guthrie McAfee Armstrong <guthrie.armstrong@gmail.com>
" This works with ../ftplugin/pass.vim
syntax match Concealed '\%1l.*' conceal cchar=*
