" tmux will send xterm-style keys when its xterm-keys option is on
" This make <S-arrow> keys work.
" Kudos: http://superuser.com/a/402084/128341
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
