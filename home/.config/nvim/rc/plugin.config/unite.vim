if g:dein#tap('unite.vim')
  " start unite in normal mode
  let g:unite_enable_start_insert = 1

  " use vimfiler to open directories
  " call unite#custom_default_action('directory',     'vimfiler')
  " call unite#custom_default_action('directory_mru', 'vimfiler')

  " unite specific key mappings
  autocmd MyAutoCmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    imap <buffer> <C-j>      <Plug>(unite_select_next_line)
    imap <buffer> <C-k>      <Plug>(unite_select_previous_line)
    imap <buffer> <Esc><Esc> <Plug>(unite_exit)
    nmap <buffer> <Esc>      <Plug>(unite_exit)
  endfunction

  nnoremap <Plug>(my-unite) <Nop>
  nmap U <Plug>(my-unite)

  " Unite default
  nnoremap <silent> <Plug>(my-unite)b  :<C-u>Unite buffer<CR>
  nnoremap <silent> <Plug>(my-unite)d  :<C-u>Unite directory<CR>
  nnoremap <silent> <Plug>(my-unite)f  :<C-u>Unite file<CR>
  nnoremap <silent> <Plug>(my-unite)g  :<C-u>Unite grep/git<CR>
  nnoremap <silent> <Plug>(my-unite)s  :<C-u>Unite source<CR>
  nnoremap <silent> <Plug>(my-unite)t  :<C-u>Unite tab<CR>
  nnoremap <silent> <Plug>(my-unite)w  :<C-u>Unite window<CR>

  " Unite plugins
  nnoremap <silent> <Plug>(my-unite)du :<C-u>Unite directory_mru<CR>
  nnoremap <silent> <Plug>(my-unite)fu :<C-u>Unite file_mru<CR>
  nnoremap <silent> <Plug>(my-unite)gt :<C-u>Unite gtags/
  nnoremap <silent> <Plug>(my-unite)m  :<C-u>Unite mark<CR>
  nnoremap <silent> <Plug>(my-unite)o  :<C-u>Unite outline<CR>
  nnoremap <silent> <Plug>(my-unite)qf :<C-u>Unite -no-quit -direction=botright quickfix<CR>
  nnoremap <silent> <Plug>(my-unite)ra :<C-u>Unite rails/
  nnoremap <silent> <Plug>(my-unite)ta :<C-u>Unite tag/
  nnoremap <silent> <Plug>(my-unite)wc :<C-u>Unite webcolorname<CR>
  nnoremap <silent> <Plug>(my-unite)y  :<C-u>Unite history/yank<CR>
endif
