if g:dein#tap('defx.nvim')
  let s:height = 50
  let s:width = 50

  call defx#custom#column('icon', {
        \ 'directory_icon' : "\u25be",
        \ 'opend_icon'     : "\u25b8",
        \})
  call defx#custom#column('mark', {
        \ 'readonly_icon' : "\ue0a2",
        \ 'selected_icon' : "\u2713",
        \})
  call defx#custom#column('filename', {
        \ 'min_width' : s:width,
        \ 'max_width' : s:width,
        \})
  call defx#custom#option('_', {
        \ 'columns'       : 'mark:icon:filename:icons',
        \ 'split'         : 'floating',
        \ 'ignored_files' : '*.[ado],*.l[ao],*.py[cdo],bazel-.*',
        \ 'listed'        : 1,
        \ 'winwidth'      : s:width + 7,
        \})

  " open defx at the center of the window
  function! s:open_defx()
    " re-calculate window center position everytime
    let l:height = min([&lines - 6, s:height])
    let l:winrow = ((&lines - 1) - l:height) / 2
    let l:wincol = (&columns - s:width) / 2
    " if there is already a defx buffer in the current tab, reuse it.
    " otherwise create a new one.
    " perhaps Defx itself should have `resume-by-bufnr` functionality.
    if get(t:, 'defxbufnr', 0) > 0
      call nvim_open_win(t:defxbufnr, v:true, {
            \ 'relative' : 'editor',
            \ 'row'      : l:winrow,
            \ 'col'      : l:wincol,
            \ 'width'    : s:width + 7,
            \ 'height'   : l:height,
            \})
    else
      call defx#custom#option('_', {
            \ 'new'       : 1,
            \ 'winheight' : l:height,
            \ 'winrow'    : l:winrow,
            \ 'wincol'    : l:wincol,
            \})
      Defx
      let t:defxbufnr = bufnr()
      call defx#custom#option('_', 'new', 0) " reset
    endif
  endfunction

  function! DefxChoosewin(context)
    if winnr('$') > 2
      " hide defx window, except for a single line showing target filename
      call nvim_win_set_config(win_getid(), { 'height': 1 })
      redraw
      " choose target window with defx excluded, whose window number is always
      " equal to winnr('$')
      call choosewin#start(range(1, winnr('$') - 1))
    else
      1wincmd w
    endif
    exec 'edit ' . a:context.targets[0]
  endfunction

  " forcibly reset window layout
  function! ResetWindowHeight(context)
    resize +100
    wincmd =
  endfunction

  " window-local config
  function! s:config_defx()
    IndentLinesDisable
    call lightline#update()
    setl nonumber
    setl nospell

    if g:dein#tap('vim-choosewin')
      nnoremap <silent><buffer><expr> e        defx#is_directory() ? defx#do_action('open') : defx#do_action('multi', [['call', 'DefxChoosewin'], 'quit', ['call', 'ResetWindowHeight']])
      nnoremap <silent><buffer><expr> <CR>     defx#is_directory() ? defx#do_action('open') : defx#do_action('multi', [['call', 'DefxChoosewin'], 'quit', ['call', 'ResetWindowHeight']])
    else
      nnoremap <silent><buffer><expr> e        defx#is_directory() ? defx#do_action('open') : defx#do_action('multi', ['drop', 'quit', ['call', 'ResetWindowHeight']])
      nnoremap <silent><buffer><expr> <CR>     defx#is_directory() ? defx#do_action('open') : defx#do_action('multi', ['drop', 'quit', ['call', 'ResetWindowHeight']])
    endif
    nnoremap <silent><buffer><expr> E          defx#do_action('multi', [['drop', 'vsplit'], 'quit', ['call', 'ResetWindowHeight']])
    nnoremap <silent><buffer><expr> o          defx#do_action('execute_system')

    nnoremap <silent><buffer><expr> l          defx#is_directory() ? defx#do_action('open') : ""
    nnoremap <silent><buffer><expr> h          defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> <BS>       defx#do_action('cd', ['..'])

    nnoremap <silent><buffer><expr> <SPACE>    defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> <C-d>      defx#do_action('remove')
    nnoremap <silent><buffer><expr> <C-x>      defx#do_action('move')
    nnoremap <silent><buffer><expr> <C-c>      defx#do_action('copy')
    nnoremap <silent><buffer><expr> <C-v>      defx#do_action('paste')
    nnoremap <silent><buffer><expr> <C-r>      defx#do_action('rename')
    nnoremap <silent><buffer><expr> <C-n>      defx#do_action('new_multiple_files')
    nnoremap <silent><buffer><expr> Y          defx#do_action('yank_path')

    nnoremap <silent><buffer><expr> .          defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> <C-f>      defx#do_action('multi', ['quit', ['call', 'ResetWindowHeight']])
    nnoremap <silent><buffer><expr> <C-h>      defx#do_action('multi', ['quit', ['call', 'ResetWindowHeight']])
    nnoremap <silent><buffer><expr> <C-j>      defx#do_action('multi', ['quit', ['call', 'ResetWindowHeight']])
    nnoremap <silent><buffer><expr> <C-k>      defx#do_action('multi', ['quit', ['call', 'ResetWindowHeight']])
    nnoremap <silent><buffer><expr> <C-l>      defx#do_action('multi', ['quit', ['call', 'ResetWindowHeight']])
    nnoremap <silent><buffer><expr> <ESC><ESC> defx#do_action('multi', ['quit', ['call', 'ResetWindowHeight']])
  endfunction
  autocmd FileType defx call <SID>config_defx()

  " auto-start
  function! s:open_defx_on_vimenter()
    if expand('%') == '' && &ft != 'man'
      call <SID>open_defx()
    endif
  endfunction
  autocmd MyAutoCmd VimEnter * call <SID>open_defx_on_vimenter()

  " shortcut
  nnoremap <silent> <C-f> :<C-u>call <SID>open_defx()<CR>
endif
