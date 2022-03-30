" Modify colors in ../../syntax/pgn.vim
" Basically, tone everything down a bit.
" Colors in my colorscheme don't work as the syntax file is loaded after the
" colorscheme is set.
highlight pgnTagName                 ctermfg=white    guifg=white
highlight pgnTagValue                ctermfg=green    guifg=green
highlight pgnMoveNumber              ctermfg=yellow   guifg=yellow
highlight pgnPiece                   cterm=none       gui=none
highlight pgnDeparture               ctermfg=white    guifg=white
highlight pgnArrival                 cterm=none       ctermfg=none
" taking symbol ("x")
highlight pgnAbbreviation            ctermfg=white    guifg=white
highlight pgnPromotion               cterm=italic     gui=italic
highlight pgnDrawOffer               ctermfg=grey     guifg=grey
highlight pgnCastling                ctermfg=white    guifg=white
highlight pgnMoveEvaluation          ctermfg=red      guifg=red
highlight pgnNovelty                 ctermfg=white    guifg=white
highlight pgnPositionEvaluation      cterm=none       gui=none
highlight pgnDiagram                 cterm=reverse    gui=reverse
highlight pgnNumericAnnotationGlyph  ctermfg=red      ctermfg=red
highlight pgnVariation               cterm=italic     gui=italic
highlight pgnResult                  ctermfg=red      guifg=red
highlight pgnCommentBlock            ctermfg=cyan     guifg=cyan
highlight pgnCommentSingleLine       ctermfg=cyan     guifg=cyan
