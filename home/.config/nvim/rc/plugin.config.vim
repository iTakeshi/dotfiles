let s:plugin_config_dir =
      \ g:util#normpath('rc'. g:pathsep . 'plugin.config', 'config')
      \ . g:pathsep
call g:util#source(s:plugin_config_dir . 'lightline.vim')
call g:util#source(s:plugin_config_dir . 'vimfiler.vim')

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

if g:dein#tap('vim-easy-align')
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)
endif

if g:dein#tap('caw.vim')
  nmap <Leader>c <Plug>(caw:i:toggle)
  vmap <Leader>c <Plug>(caw:i:toggle)
endif

if g:dein#tap('vim-choosewin')
  let g:choosewin_overlay_enable = 1
  let g:choosewin_overlay_clear_multibyte = 1
  nmap - <Plug>(choosewin)
endif

" =====================================
" auto completion
" =====================================
if g:dein#tap('deoplete.nvim')
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use deoplete
  let g:deoplete#enable_at_startup = 1
  " Use smartcase.
  let g:deoplete_enable_smart_case = 1
endif

if g:dein#tap('neosnippet.vim')
  imap <C-t> <Plug>(neosnippet_expand_or_jump)
  smap <C-t> <Plug>(neosnippet_expand_or_jump)
  xmap <C-t> <Plug>(neosnippet_expand_target)
  if has('conceal')
    set conceallevel=2 concealcursor=niv
  endif
endif

" =====================================
" operator
" =====================================
if g:dein#tap('vim-operator-replace')
  map gr <Plug>(operator-replace)
endif

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

  map Sa <Plug>(operator-surround-append)
  map Sd <Plug>(operator-surround-delete)
  map Sr <Plug>(operator-surround-replace)
endif

if g:dein#tap('vim-operator-flashy')
  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$
endif
