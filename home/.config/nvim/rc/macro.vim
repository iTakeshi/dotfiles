" save the file as root with 'sudo'
cabbr w!! w !sudo tee > /dev/null %

" automatically create missing directories
autocmd MyAutoCmd BufWritePre * call s:makedirs(expand('<afile>:p:h'), v:cmdbang)
function! s:makedirs(dir, force) abort
  if !isdirectory(a:dir)
    if a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$'
      call mkdir(a:dir, 'p')
    endif
  endif
endfunction

" automatically change working directory on vim enter
function! s:workon(dir, bang) abort
  let dir = (a:dir ==# '' ? expand('%') : a:dir)
  " convert filename to directory if required
  if filereadable(dir)
    let dir = fnamemodify(expand(dir),':p:h')
  else
    let dir = fnamemodify(dir, ':p')
  endif
  " change directory to specified directory
  if isdirectory(dir)
    silent execute 'cd ' . fnameescape(dir)
    if a:bang ==# ''
      redraw | echo 'Working on: '.dir
      if v:version > 703 || (v:version == 703 && has('patch438'))
        doautocmd <nomodeline> MyAutoCmd User my-workon-post
      else
        doautocmd MyAutoCmd User my-workon-post
      endif
    endif
  endif
endfunction
autocmd MyAutoCmd VimEnter * call s:workon(expand('<afile>'), 1)
command! -nargs=? -complete=dir -bang Workon call s:workon('<args>', '<bang>')

" toggle quickfix window
function! s:toggle_qf() abort
  let nwin = winnr('$')
  cclose
  if nwin == winnr('$')
    cwindow
  endif
endfunction
nnoremap <silent> <Leader>q :call <SID>toggle_qf()<CR>

" highlight zenkaku spaces
autocmd MyAutoCmd VimEnter,WinEnter * match MyZenkakuSpace /　/
highlight MyZenkakuSpace
      \ cterm=reverse ctermfg=DarkMagenta
      \ gui=reverse guifg=DarkMagenta

" edit vimrc
if has('vim_starting')
  function s:edit_vimrc() abort
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1 && expand('%') ==# ''
      edit $MYVIMRC
    else
      vsplit
      edit $MYVIMRC
    endif
  endfunction
endif
nnoremap <F3> :<C-u>call <SID>edit_vimrc()<CR>

" reload vimrc
if has('vim_starting')
  function s:reload_vimrc() abort
    execute printf('source %s', $MYVIMRC)
    redraw
    syn on
    echo 'vimrc/init.vim has been reloaded.'
  endfunction
endif
nnoremap <F4> :<C-u>call <SID>reload_vimrc()<CR>

" open help in vertically split window
autocmd MyAutoCmd FileType help wincmd L

function! s:fix_layout() abort
  exec 100 . 'wincmd +'
  wincmd =
endfunction
command FixLayout call <SID>fix_layout()

" re-generate *.add.spl file on startup, if *.add file is modified
for d in glob(g:config_root . '/spell/*.add', 1, 1)
  if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
    exec 'mkspell! ' . fnameescape(d)
    echom 'generated '. d
  endif
endfor
