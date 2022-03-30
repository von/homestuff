" Configuration related to buffers

" One of the most important options to activate. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files will keep you safe if your computer crashes.
set hidden

" BufferGator sort by filename instead of buffer number
let g:buffergator_sort_regime = 'basename'

" Make BufferGator a virtical split on left that is at least 80 columns
" wide so I can see buffer paths.
let g:buffergator_viewport_split_policy = 'L'
let g:buffergator_vsplit_size = 80
