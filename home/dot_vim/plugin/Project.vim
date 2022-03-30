" Projects.vim: Allow for setting up Projects

" ProjectNew(): Start up a project
" Uses g:projects to set up project.
" Uses Taboo (https://github.com/gcmt/taboo.vim) for renaming tab
function! ProjectNew(projectName)
  let conf = get(g:projects, a:projectName, {})
  execute "TabooRename " . a:projectName
  let dir = get(conf, "chdir", "")
  if !empty(dir) | execute "cd " . dir | endif
  let cmd = get(conf, "cmd", "")
  if !empty(cmd) | execute cmd | endif
endfunction

command! -nargs=1 Project call ProjectNew(<q-args>)

" ProjectTabNew(): Create a new tab for a project
"
" Note: It's tempting to try and use the TabEnter autocmd to do this,
" but TabooOpen creates the tabe and then renames it, so when TabEnter is
" invoked, the tab isn't named yet.
function! ProjectTabNew(projectName)
  tabnew!
  call ProjectNew(a:projectName)
endfunction

command! -nargs=1 ProjectTab call ProjectTabNew(<q-args>)

" Maintain a cwd for each tab
" Kudos: https://github.com/kana/vim-tabpagecd
augroup TabCwd
  autocmd!

  autocmd TabEnter *
  \   if exists('t:cwd')
  \ |   cd `=t:cwd`
  \ | endif

  autocmd TabLeave *
  \   let t:cwd = getcwd()

augroup END
