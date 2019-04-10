let s:bundle_root = expand('~/.cache/dein')
let s:dein_root   = s:bundle_root . '/repos/github.com/Shougo/dein.vim'
let s:dein_url    = 'https://github.com/Shougo/dein.vim'

function! s:install_dein() abort
  if !executable('git')
    echohl Error
    echo 'git is required to be installed.'
    echohl None
    return 1
  endif

  redraw | echo 'Installing dein.vim ...'
  call system(printf('git clone --depth 1 %s %s', s:dein_url, s:dein_root))
  let l:currentdir = system('pwd')
  redraw | echo 'dein.vim was installed. continue to install other plugins...'
  return 0
endfunction

function! s:configure_dein() abort
  if g:dein#load_state(s:bundle_root)
    call g:dein#begin(s:bundle_root, [
        \ g:util#normpath('rc/plugin.vim', 'config'),
        \ g:util#normpath('rc/plugin.define.vim', 'config'),
        \ ])
    let g:dein#types#git#clone_depth = 1
    call g:util#source(g:util#normpath('rc/plugin.define.vim', 'config'))
    call g:dein#end()
    call g:dein#save_state()
  endif

  call g:util#source(g:util#normpath('rc/plugin.config.vim', 'config'))

  filetype plugin indent on
  syntax enable

  if g:dein#check_install()
    call g:dein#install()
    call g:dein#remote_plugins()
    call g:dein#check_lazy_plugins()
    call g:dein#recache_runtimepath()
  endif

  if !has('vim_starting')
    call dein#call_hook('on_source')
  endif
endfunction

if !filereadable(s:dein_root . '/autoload/dein.vim')
  call s:install_dein()
endif

if has('vim_starting')
  execute printf('set runtimepath+=%s', s:dein_root)
endif
call s:configure_dein()

