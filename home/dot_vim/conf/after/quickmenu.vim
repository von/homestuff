" Configuration for quickmenu

" Guard
try
  " Work on default menu
  call quickmenu#current(0)
catch
  finish
endtry

" clear all the items
call quickmenu#reset()

" enable cursorline (L) and cmdline help (H)
let g:quickmenu_options = "HL"

" Git
call quickmenu#append("# Git", '')
call quickmenu#append("git blame", 'Git blame', 'Toggle git blame mode')
call quickmenu#append("git status", 'Git', 'git status')
call quickmenu#append("git diff", 'Gdiffsplit', 'Show git diff')
call quickmenu#append("git log", 'Gclog', 'Show git log')
call quickmenu#append("git preview hunk", 'GitGutterPreviewHunk', 'Show preview of hunk')
call quickmenu#append("git undo hunk", 'GitGutterUndoHunk', 'Undo changes in hunk')
call quickmenu#append("git stage hunk", 'GitGutterStageHunk', 'Stage changes in hunk')
call quickmenu#append("git commit", 'Git commit', 'Commit staged changes')
call quickmenu#append("git amend", 'Git commit --amend', 'Amend staged changes')
call quickmenu#append("Toggle fold", 'GitGutterFold', 'Toggle folding of non-changed text')

" Utilities
call quickmenu#append("# Utilities", '')
call quickmenu#append("Clean whitespace", 'call WhitespaceClean()', 'Clean up whitespace')
call quickmenu#append("Clean Unicode", "call UnicodeClean()", "Clean Unicode")
call quickmenu#append("Re-wrap paragraph", "normal {gq}", "Wrap paragraph")
call quickmenu#append("Re-wrap file", "normal gqG", "Wrap file")
call quickmenu#append("VimWiki", "VimwikiUISelect", "VimWiki")
call quickmenu#append("Hammerspoon source file", "call HammerspoonSourceCurrentFile()", "Hammerspoon source file", "lua")
call quickmenu#append("Reload Hammerspoon config", "call HammerspoonReload()", "Reload Hammerspoon config", "lua")
call quickmenu#append("Gundo", "GundoToggle", "Toggle Gundo menu")
call quickmenu#append("Markdown preview", "call Vim_Markdown_Preview()", "Markdown preview", "markdown")
call quickmenu#append("Run Lint", "PymodeLint", "Run PymodeLint", "python")

" Options
call quickmenu#append("# Options", '')
call quickmenu#append("Turn spell %{&spell? 'off':'on'}", "set spell!", "Toggle spell check (:set spell!)")
if exists('*NeoCompleteToggle')
  call quickmenu#append("Toggle Neocomplete", "NeoCompleteToggle", "Toggle NeoComplete")
endif
call quickmenu#append("Soft Word Wrap", "call WrapSoft()", "Soft (virtual) word wrapping")
call quickmenu#append("Hard Word Wrap", "call WrapHard()", "Hard word wrapping")
call quickmenu#append("Word Wrap Off", "call WrapOff()", "Hard word wrapping")
call quickmenu#append("Toggle Highlight of Non-ASCII", "call ToggleHighlightNonascii()", "Highlight Non-ASCII")

" Projects
call quickmenu#append("# Projects", '')
func! AddProject(projectname, projectconf)
  call quickmenu#append(a:projectname, "call ProjectTabNew(\"" . a:projectname . "\")", "Launch project " . a:projectname)
endfunc
" Make copy() as map() changes in place
call map(copy(g:projects), function('AddProject'))

" Debugging
call quickmenu#append("# Debugging", '')
call quickmenu#append("Debug highlight group", "call SynStack()", "Debug highlight group under cursor")

" SessionMenu(): Display menu of Sessions {{{ "

" Internal helper function
func! s:add_session(index, sessionpath)
  let l:sessionname = fnamemodify(a:sessionpath, ":t")
  if l:sessionname ==# "__LAST__"
    return
  endif
  call quickmenu#append(l:sessionname, "SLoad " . l:sessionname, "Load session " . l:sessionname)
endfunction

" TODO: Right now this regenerates the session menu each time it is invoked.
"       This certainly isn't necessary if we are closing the menu, but I don't
"       know how to detect it is open. And if I'm opening the menu, I only
"       need to regenerate if a session has been created or deleted.
function! SessionMenu()
  let l:menu_id = 765   " Arbitrary
  call quickmenu#current(l:menu_id)
  call quickmenu#reset()
  call quickmenu#header("Sessions")
  call map(split(globpath(g:startify_session_dir, '*'), '\n'), function('s:add_session'))
  call quickmenu#toggle(l:menu_id)
endfunction
" }}} SessionMenu(): Display menu of Sessions "
