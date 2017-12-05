if g:dein#tap('vimfiler.vim')
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_ignore_pattern = ['^\.$', '^\.\.$', '^.*\.pyc$', '^bazel-.*$']

  " vimfiler specific key mappings
  function! s:vimfiler_settings()
    " overwrite C-j ignore <Plug>(vimfiler_switch_to_history_directory)
    nmap <buffer> <C-j> <C-w>j

    " overwrite C-l ignore <Plug>(vimfiler_redraw_screen)

    " use R to refresh
    nmap <buffer> R <Plug>(vimfiler_redraw_screen)

    " disable switch_to_root
    nmap <buffer> \ <Nop>

    " hide vimfiler on editting
    nmap <buffer><silent> <Plug>(vimfiler_edit_file) :<C-u>call <SID>edit_file()<CR>
    nmap <buffer><silent> <Plug>(vimfiler_split_edit_file) :<C-u>call <SID>split_edit_file()<CR>
    nmap <buffer><silent> <C-l> :<C-u>wincmd l<CR>:1quit<CR>
  endfunction
  autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()

  " exec vimfiler in a split window
  function! s:exec_vimfiler()
    call vimfiler#custom#profile('default', 'context', {
          \ 'split'    : 1,
          \ 'winwidth' : 50,
          \ 'no_quit'  : 1,
          \ 'columns'  : 'devicons',
          \ })
    VimFiler
    call lightline#update()
    setl nonumber
  endfunction
  command! ExecVimFiler :call s:exec_vimfiler()
  nnoremap <silent> <Leader>f :<C-u>ExecVimFiler<CR>
  nnoremap <silent> <Plug>(my-toggle)f :<C-u>ExecVimFiler<CR>

  " auto-start
  function! s:exec_vimfiler_on_vimenter()
    if expand('%') == ''
      call s:exec_vimfiler()
    endif
  endfunction
  autocmd MyAutoCmd VimEnter * call s:exec_vimfiler_on_vimenter()

  " auto-show
  function! s:exec_vimfiler_on_wincmd()
    if winnr() == 1
      call s:exec_vimfiler()
    else
      wincmd h
    endif
  endfunction
  nnoremap <silent> <C-h> :<C-u>call <SID>exec_vimfiler_on_wincmd()<CR>

  " auto-hide
  function! s:edit_file()
    call vimfiler#mappings#do_switch_action(b:vimfiler, b:vimfiler.context.edit_action)
    1close
  endfunction

  function! s:split_edit_file()
    call vimfiler#mappings#do_action(b:vimfiler, b:vimfiler.context.split_action)
    1close
  endfunction
endif
