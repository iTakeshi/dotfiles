set ignorecase       " ignore case
set smartcase        " override the ignorecase if the search pattern contains upper case characters
set incsearch        " use incremental search
set wrapscan         " when hit to bottom, scan from the top
set hlsearch         " highlight found terms

" K to search the help with the cursor word
set keywordprg=:help

" automatically escape / or ?
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'

" remove highlight with pressing ESC twice
nnoremap <silent> <Esc><Esc> :<C-u>nohlsearch<CR>

