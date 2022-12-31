" highlight zenkaku spaces
" autocmd MyAutoCmd VimEnter,WinEnter * match MyZenkakuSpace /　/
match MyZenkakuSpace /　/
highlight MyZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta

" open help in vertically split window
autocmd MyAutoCmd FileType help wincmd L

" re-generate *.add.spl file on startup, if *.add file is modified
for d in glob(g:config_root . '/spell/*.add', 1, 1)
  if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
    exec 'mkspell! ' . fnameescape(d)
    echom 'generated '. d
  endif
endfor
