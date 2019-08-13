let s:plugin_config_dir =
      \ g:util#normpath('rc/plugin.config', 'config')
call g:util#source(s:plugin_config_dir . '/lightline.vim')
call g:util#source(s:plugin_config_dir . '/defx.vim')
call g:util#source(s:plugin_config_dir . '/textobj.vim')

" =====================================
" utility
" =====================================
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

if g:dein#tap('vim-choosewin')
  let g:choosewin_overlay_enable = 1
  let g:choosewin_overlay_clear_multibyte = 1
  nmap - <Plug>(choosewin)
endif

if g:dein#tap('vim-better-whitespace')
  let g:strip_whitespace_on_save = 1
  let g:strip_whitespace_confirm = 0
  let g:strip_whitelines_at_eof = 1
  let g:show_spaces_that_precede_tabs = 1

  function! s:disable_whitespace_strip_if_readonly() abort
    if &readonly
      DisableStripWhitespaceOnSave
    endif
  endfunction
  autocmd BufRead,BufEnter * call s:disable_whitespace_strip_if_readonly()
endif

if g:dein#tap('indentLine')
  let g:indentLine_char_list = ['|', '¦', '┆', '┊']
  let g:indentLine_setConceal = 0
  let g:indentLine_setColors = 0
endif

if g:dein#tap('inspecthi.vim')
  nnoremap <silent> <Leader>h :<C-u>Inspecthi<CR>
endif

" =====================================
" language support
" =====================================
if g:dein#tap('vim-polyglot')
  let g:polyglot_disabled = ['latex']
endif

if g:dein#tap('vimtex')
  let g:tex_flavor = 'latex'
  let g:vimtex_view_method = 'mupdf'
  let g:vimtex_compiler_progname = 'nvr'
  let g:vimtex_compiler_method = 'latexmk'
  let g:vimtex_compiler_latexmk = {
      \ 'background': 1,
      \ 'continuous': 1,
      \ 'options': [
      \    '-verbose',
      \    '-file-line-error',
      \],
      \}
  let g:vimtex_quickfix_latexlog = {'underfull' : 0}
endif

" =====================================
" operator
" =====================================
if g:dein#tap('vim-easy-align')
  map ga <Plug>(EasyAlign)
endif

if g:dein#tap('caw.vim')
  let g:caw_no_default_keymappings = 1
  map gc   <Plug>(caw:prefix)
  map gcc  <Plug>(caw:hatpos:toggle:operator)
  map gci  <Plug>(caw:hatpos:comment:operator)
  map gcui <Plug>(caw:hatpos:uncomment:operator)
  map gcI  <Plug>(caw:zeropos:comment:operator)
  map gcuI <Plug>(caw:zeropos:uncomment:operator)
  map gca  <Plug>(caw:dollarpos:comment:operator)
  map gcua <Plug>(caw:dollarpos:uncomment:operator)
  map gcw  <Plug>(caw:wrap:comment:operator)
  map gcuw <Plug>(caw:wrap:uncomment:operator)
  map gcb  <Plug>(caw:box:comment:operator)
endif

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
  map gsa <Plug>(operator-surround-append)
  map gsd <Plug>(operator-surround-delete)
  map gsr <Plug>(operator-surround-replace)
endif

if g:dein#tap('vim-operator-flashy')
  map  y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$
endif
