if g:dein#tap('lightline.vim')
  let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'active': {
        \   'left': [
        \     ['mode', 'paste'],
        \     ['filename'],
        \   ],
        \   'right': [
        \     ['fileformat', 'fileencoding', 'filetype'],
        \     ['lineinfo', 'qfstatusline']
        \   ],
        \ },
        \ 'inactive': {
        \   'left': [
        \     ['filename'],
        \   ],
        \   'right': [
        \     ['fileformat', 'fileencoding', 'filetype'],
        \   ],
        \ },
        \ 'tabline': {
        \   'left': [
        \     ['cwd'],
        \     ['tabs'],
        \   ],
        \   'right': [
        \     ['gita_branch', 'gita_traffic', 'gita_status'],
        \   ]
        \ },
        \ 'component_function': {
        \   'mode':         'g:lightline.my.mode',
        \   'cwd':          'g:lightline.my.cwd',
        \   'filename':     'g:lightline.my.filename',
        \   'fileformat':   'g:lightline.my.fileformat',
        \   'fileencoding': 'g:lightline.my.fileencoding',
        \   'filetype':     'g:lightline.my.filetype',
        \   'lineinfo':     'g:lightline.my.lineinfo',
        \   'gita_branch':  'g:lightline.my.gita_branch',
        \   'gita_traffic': 'g:lightline.my.gita_traffic',
        \   'gita_status':  'g:lightline.my.gita_status',
        \ },
        \ 'component_expand': {
        \   'qfstatusline': 'qfstatusline#Update',
        \ },
        \ 'component_type': {
        \   'qfstatusline': 'error'
        \ },
        \}

  " Note:
  " component_function cannot be a script local function so use
  " g:lightline.my namespace instead of s:
  let g:lightline.my = {}

  if !has('multi_byte') || $LANG ==# 'C'
    let g:lightline.my.symbol_readonly = '[RO]'
    let g:lightline.my.symbol_modified = '*'
    let g:lightline.my.symbol_not_modifiable = '#'
  else
    let g:lightline.my.symbol_readonly = "\ue0a2"
    let g:lightline.my.symbol_modified = "\uf41e"
    let g:lightline.my.symbol_not_modifiable = "\uf46f"
  endif

  function! g:lightline.my.mode() abort
    return &filetype !~# 'vimfiler' ? lightline#mode() : ''
  endfunction

  function! g:lightline.my.cwd() abort
    return fnamemodify(getcwd(), ':~')
  endfunction

  function! g:lightline.my.readonly() abort
    return empty(&buftype) && &readonly ? g:lightline.my.symbol_readonly : ''
  endfunction

  function! g:lightline.my.modified() abort
    return empty(&buftype) && &modified ? g:lightline.my.symbol_modified : ''
  endfunction

  function! g:lightline.my.not_modifiable() abort
    return !&modifiable ? g:lightline.my.symbol_not_modifiable : ''
  endfunction

  function! g:lightline.my.filename() abort
    if &filetype =~# '\v%(unite|vimshell|gundo)'
      return {&filetype}#get_status_string()
    elseif &filetype =~# '\v%(gita-blame-navi)'
      let fname = winwidth(0) > 79 ? expand('%') : get(split(expand('%'), ':'), 2, 'NAVI')
      return fname
    else
      let fname = fnamemodify(expand('%'), ':~:.')
      let readonly       = g:lightline.my.readonly()
      let modified       = g:lightline.my.modified()
      let not_modifiable = g:lightline.my.not_modifiable()
      return '' .
            \ (empty(fname)          ? '[No name]' : fname) .
            \ (empty(readonly)       ? '' : ' ' . readonly) .
            \ (empty(not_modifiable) ? '' : ' ' . not_modifiable) .
            \ (empty(modified)       ? '' : ' ' . modified)
    endif
    return ''
  endfunction

  function! g:lightline.my.fileformat() abort
    return &filetype !~# 'vimfiler' ? &fileformat . ' ' . WebDevIconsGetFileFormatSymbol() : ''
  endfunction

  function! g:lightline.my.filetype() abort
    return &filetype !~# 'vimfiler' ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction

  function! g:lightline.my.fileencoding() abort
    return &filetype !~# 'vimfiler' ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
  endfunction

  function! g:lightline.my.lineinfo() abort
    return &filetype !~# 'vimfiler' && winwidth(0) >= 70 ? printf('%d:%d', line('.'), col('.')) : ''
  endfunction

  if dein#tap('vim-gita') && executable('git')
    function! g:lightline.my.gita_branch() abort
      return g:gita#statusline#preset('branch_fancy')
    endfunction
    function! g:lightline.my.gita_traffic() abort
      return g:gita#statusline#preset('traffic_fancy')
    endfunction
    function! g:lightline.my.gita_status() abort
      return g:gita#statusline#preset('status')
    endfunction
  else
    function! g:lightline.my.gita_branch() abort
      return ''
    endfunction
    function! g:lightline.my.gita_traffic() abort
      return ''
    endfunction
    function! g:lightline.my.gita_status() abort
      return ''
    endfunction
  endif

  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimshell_force_overwrite_statusline = 0
endif
