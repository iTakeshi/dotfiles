set nomodeline    " do not use modeline
set smarttab      " insert blanks according to shiftwidth
set expandtab     " use spaces instead of TAB
set tabstop=8     " the number of spaces that a TAB counts for
set softtabstop=4 " the number of spaces that a TAB counts for
set shiftwidth=4  " the number of spaces of an indent
set shiftround    " round indent to multiple of shiftwidth with > and <

set autoindent    " copy indent from current line when starting a new line
set copyindent    " copy the structure of the existing lines indent when autoindenting a new line

" every wrapped line will continue visually indented
if has('&breakindent')
  set breakindent
endif

set hidden            " hide the buffer instead of close
set switchbuf=useopen " use an existing buffer instaed of creating a new one
set autoread          " automatically read the changed contents

" store cursor, folds, slash, unix on view
set viewoptions=cursor,folds,slash,unix

" change default view directory
let &viewdir = g:util#normpath('view', 'data')
if !isdirectory(&viewdir)
  call mkdir(&viewdir, 'p', 0700)
endif

" use external clipboard tool
set clipboard=unnamedplus

" keep undo history on undofile
if has('persistent_undo')
  let &undodir = g:util#normpath('undo', 'data')
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p', 0700)
  endif
  set undofile
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" suppress spell checking
set nospell

" suppress tex formula conversion
let g:tex_conceal=''

" show double quotation in json file
let g:vim_json_syntax_conceal = 0

" prefer UTF-8
if has('multi_byte')
  if has('vim_starting')
    set encoding=utf-8
  endif
  scriptencoding utf-8
  set fileencodings=ucs-bom,utf-8,euc-jp,iso-2022-jp,cp932,utf-16,utf-16le
  set fileformats=unix,dos,mac
endif
