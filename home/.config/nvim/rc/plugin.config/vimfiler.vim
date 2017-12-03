if g:dein#tap('vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_ignore_pattern = ['^\.$', '^\.\.$', '^.*\.pyc$', '^bazel-.*$']

  " vimfiler specific key mappings
  autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
  function! s:vimfiler_settings()
    " use R to refresh
    nmap <buffer> R <Plug>(vimfiler_redraw_screen)
    " overwrite C-j ignore <Plug>(vimfiler_switch_to_history_directory)
    nmap <buffer> <C-j> <C-w>j
    " overwrite C-l ignore <Plug>(vimfiler_redraw_screen)
    nmap <buffer> <C-l> <C-w>l
    " disable switch_to_root
    nmap <buffer> \ <Nop>
  endfunction

  function! s:exec_vimfiler()
    call vimfiler#custom#profile('default', 'context', {
          \ 'split'    : 1,
          \ 'winwidth' : 50,
          \ 'no_quit'  : 1,
          \ 'columns'  : 'devicons',
          \ })
    VimFiler
    setl nonumber
  endfunction
  command! ExecVimFiler :call s:exec_vimfiler()
  nnoremap <silent> <Leader>f :<C-u>ExecVimFiler<CR>
  nnoremap <silent> <Plug>(my-toggle)f :<C-u>ExecVimFiler<CR>

  function! s:exec_vimfiler_on_vimenter()
    if bufexists('COMMIT_EDITMSG')
      return 0
    endif
    call s:exec_vimfiler()
    wincmd l
    if expand('%') == ''
      wincmd h
    endif
  endfunction
  autocmd MyAutoCmd VimEnter * call s:exec_vimfiler_on_vimenter()
endif
