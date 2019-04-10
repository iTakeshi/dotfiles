let g:is_neovim  = has('nvim')

if g:is_neovim
  let g:config_root = expand('~/.config/nvim')
else
  let g:config_root = expand('~/.vim/')
endif

let g:data_root = expand('~/.local/share/' . (g:is_neovim ? 'nvim' : 'vim'))

function! g:util#is_abspath(path) abort
  return a:path =~# '\v^/'
endfunction

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
  return l:typeroot . '/' . l:relpath
endfunction

function! g:util#source(path) abort
  let l:path = expand(a:path)
  if filereadable(l:path)
    execute printf('source %s', l:path)
    return 1
  endif
  return 0
endfunction
