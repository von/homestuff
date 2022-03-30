" startify configuration
" See conf/sessions.vim for startify session configuration

" Persist sessions
" startify_session_persistence must be set before loading Startify
" so startify sets up AutoCmd
let g:startify_session_persistence = 1

" Don't print a header on start
let g:startify_custom_header = []

let g:startify_list_order = [
  \ ['Sessions'],
  \ 'sessions',
  \ ['Recent files'],
  \ 'files',
  \ ['Recent files in current directory'],
  \ 'dir',
  \ ['Bookmarks'],
  \ 'bookmarks',
  \ ]
