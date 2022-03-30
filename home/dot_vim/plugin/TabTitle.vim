" Set t:title from Taboo title
" t:title is used by 'Unite buffer'
" Note this isn't perfect as title changes won't
" propagate until we leave a tab.
augroup TabSetTitle
  autocmd!

  autocmd TabLeave *
  \   let name = TabooTabName(tabpagenr())
  \ | if !empty(name)
  \ |   let t:title = name
  \ | endif

augroup END
