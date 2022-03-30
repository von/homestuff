" Configuration related to Ultisnips plugin

let g:UltiSnipsExpandTrigger="<S-Tab>"

" List all snippets with Control-`
" C-Tab doesn't work for me.
let g:UltiSnipsListSnippets="<C-l>"

" Same as UtilisnipsExpandTrigger above
let g:UltiSnipsJumpForwardTrigger="<S-Tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

let g:ultisnips_python_style="google"

" Utilisnips should autodetect version of Python, but in case not
" let g:UltiSnipsUsePythonVersion = 2
" let g:UltiSnipsUsePythonVersion = 3
