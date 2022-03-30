" Configuration for vifm plugin

" Run vifm in an embedded terminal so it doesn't take over the whole
" vim session.
let g:vifm_embed_term=1

" Source a vifmrc specific to plugin
" TODO: Find a way to source a project-specific vifmrc so I can
" have project-specific bookmarks
let g:vifm_exec_args="-c 'source ~/.vim/vifmrc'"
