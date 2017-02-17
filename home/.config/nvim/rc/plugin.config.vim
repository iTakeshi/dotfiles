let s:plugin_config_dir =
      \ g:util#normpath('rc'. g:pathsep . 'plugin.config', 'config')
      \ . g:pathsep
call g:util#source(s:plugin_config_dir . 'lightline.vim')
call g:util#source(s:plugin_config_dir . 'complete.vim')
call g:util#source(s:plugin_config_dir . 'unite.vim')
call g:util#source(s:plugin_config_dir . 'vimfiler.vim')

" sudo
if g:dein#tap('sudo.vim')
  cabbr w!! :w sudo:%
endif

" choosewin
if g:dein#tap('vim-choosewin')
  let g:choosewin_overlay_enable = 1
  let g:choosewin_overlay_clear_multibyte = 1
  nmap - <Plug>(choosewin)
endif

" capslock
if g:dein#tap('vim-capslock')
  nmap <silent> <Plug>(my-toggle)c <Plug>CapsLockToggle
endif

" easy-align
if g:dein#tap('vim-easy-align')
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)
endif

" vim-anzu
if g:dein#tap('vim_anzu')
  let g:anzu_enable_CursorMoved_AnzuUpdateSearchStatus = 1
endif

" unified-diff
if g:dein#tap('vim-unified-diff') && executable('git')
  let g:unified_diff#arguments = [
        \   'diff',
        \   '--no-index',
        \   '--no-color',
        \   '--no-ext-diff',
        \   '--unified=0',
        \   '--histogram',
        \ ]
  set diffexpr=unified_diff#diffexpr()
endif

" operator-flashy
if g:dein#tap('vim-operator-flashy')
  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$
endif

" caw
if g:dein#tap('caw.vim')
  nmap <Leader>c <Plug>(caw:i:toggle)
  vmap <Leader>c <Plug>(caw:i:toggle)
endif

" neosnippet
if g:dein#tap('neosnippet.vim')
  imap <C-t> <Plug>(neosnippet_expand_or_jump)
  smap <C-t> <Plug>(neosnippet_expand_or_jump)
  xmap <C-t> <Plug>(neosnippet_expand_target)
  if has('conceal')
    set conceallevel=2 concealcursor=niv
  endif
endif

" textobj-multiblock
if g:dein#tap('vim-textobj-multiblock')
  omap ab <Plug>(textobj-multiblock-a)
  omap ib <Plug>(textobj-multiblock-i)
  xmap ab <Plug>(textobj-multiblock-a)
  xmap ib <Plug>(textobj-multiblock-i)
endif

" operator-replace
if g:dein#tap('vim-operator-replace')
  map gr <Plug>(operator-replace)
endif

" operator-surround
if g:dein#tap('vim-operator-surround')
  " add ```...``` surround when filetype is markdown
  let g:operator#surround#blocks = {
        \ 'markdown' : [
        \   {
        \     'block' : ['```\n', '\n```'],
        \     'motionwise' : ['line'],
        \     'keys' : ['`']
        \   },
        \ ]}

  map gsa <Plug>(operator-surround-append)
  map gsd <Plug>(operator-surround-delete)
  map gsr <Plug>(operator-surround-replace)

  nmap gsdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  nmap gsrr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
  vmap gsdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
  vmap gsrr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
endif

" quickrun
if g:dein#tap('vim-quickrun')
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config['_'] = {
        \ 'runner' : 'vimproc',
        \ 'outputter/buffer/split': ':botright 8sp',
        \ 'outputter/buffer/close_on_empty': 1,
        \ 'hook/time/enable': 1,
        \}
  " Terminate the quickrun with <C-c>
  nnoremap <expr><silent> <C-c> quickrun#is_running()
        \ ? quickrun#sweep_sessions() : "\<C-c>"

  nnoremap <Plug>(my-quickrun) <Nop>
  nmap <LocalLeader>r <Plug>(my-quickrun)
  nmap <Plug>(my-quickrun) <Plug>(quickrun)
endif

" watchdogs
if g:dein#tap('vim-watchdogs')
  let g:watchdogs_check_CursorHold_enable = 0
  let g:watchdogs_check_BufWritePost_enable = 0
  let g:watchdogs_check_BufWritePost_enables = {
        \ 'vim': 1,
        \ 'python': 1,
        \ 'javascript': 1,
        \ 'scala': 1,
        \ 'ruby': 1,
        \}
  let g:watchdogs_check_BufWritePost_enable_on_wq = 0

  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config = extend(g:quickrun_config, {
        \ 'watchdogs_checker/_': {
        \   'runner/vimproc/updatetime': 40,
        \   'outputter/quickfix/open_cmd': '',
        \   'hook/qfstatusline_update/enable_exit': 1,
        \   'hook/qfstatusline_update/priority_exit': 4,
        \   'hook/qfsigns_update/enable_exit': 1,
        \   'hook/qfsigns_update/priority_exit': 3,
        \ }
        \})
  if executable('vint')
    let g:quickrun_config['watchdogs_checker/vint'] = {
          \ 'command': 'vint',
          \ 'exec'   : '%c %o %s:p',
          \}
    let g:quickrun_config['vim/watchdogs_checker'] = {
          \ 'type': 'watchdogs_checker/vint',
          \}
  endif
  if executable('flake8')
    let g:quickrun_config['watchdogs_checker/pyflakes'] = {
          \ 'command': 'flake8',
          \}
  endif
  call g:watchdogs#setup(g:quickrun_config)

  function! s:run_watchdogs() abort
    for l:ft in keys(g:watchdogs_check_BufWritePost_enables)
      if l:ft == &filetype
        WatchdogsRun
        return 0
      endif
    endfor
    return 0
  endfunction
  autocmd MyAutoCmd BufEnter * call s:run_watchdogs()
endif

if g:dein#tap('vim-qfstatusline')
  let g:Qfstatusline#UpdateCmd = function('lightline#update')
  let g:Qfstatusline#Text = 0
endif

if g:dein#tap('vim-hier')
  nnoremap <silent> <Esc><Esc> :<C-u>HierClear<CR>:nohlsearch<CR>
endif
