" Unite plugin configuration
" Kudos: http://www.reinteractive.net/posts/166-awesome-vim-plugins

" Guard
if exists(":Unite")

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file_rec/async','sorters','sorter_rank')

" Add -I to grep options to ignore binary files
let g:unite_source_grep_default_opts = '-iIRHn'

endif " Guard
