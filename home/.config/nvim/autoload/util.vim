let g:is_windows = 0 " placeholder
let g:is_macosx  = 0 " placeholder
let g:is_linux   = !g:is_windows && !g:is_macosx
let g:is_neovim  = has('nvim')
let g:delimiter  = g:is_windows ? ';' : ':'
let g:pathsep    = g:is_windows ? '\\' : '/'
let g:homepath   = expand($HOME)

if g:is_neovim
  let g:config_root = g:homepath . g:pathsep . '.config' . g:pathsep . 'nvim'
else
  let g:config_root = g:homepath . g:pathsep . '.vim'
endif

if g:is_linux
  let g:data_root = g:homepath . g:pathsep . '.local' . g:pathsep . 'share'
  let g:data_root = g:data_root . g:pathsep . (g:is_neovim ? 'nvim' : 'vim')
else
  " TODO windows configuration
end

if g:is_windows
  function! g:util#is_abspath(path) abort
    return a:path =~# '\v^[A-Z]:\\'
  endfunction
else
  function! g:util#is_abspath(path) abort
    return a:path =~# '\v^/'
  endfunction
endif

function! g:util#is_relpath(path) abort
  return !g:util#is_abspath(a:path)
endfunction

function! g:util#normpath(path, type) abort
  let l:relpath = g:util#is_relpath(a:path)
        \ ? a:path
        \ : fnamemodify(a:path, ':~:.')
  if a:type =~# 'c\%[onfig]'
    let l:typeroot = g:config_root
  elseif a:type =~# 'd\%[ata]'
    let l:typeroot = g:data_root
  endif
  return l:typeroot . g:pathsep . l:relpath
endfunction

function! g:util#source(path) abort
  let l:path = expand(a:path)
  if filereadable(l:path)
    execute printf('source %s', l:path)
    return 1
  endif
  return 0
endfunction
