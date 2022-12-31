" normal mode {{{
nnoremap <C-@> <Nop>
nnoremap <C-a> <C-a>
nnoremap <C-b> <C-b>
nnoremap <C-c> <C-c>
nnoremap <C-d> <C-l>
nnoremap <C-e> 10<C-e>
" nnoremap <C-f> => used for Defx
nnoremap <C-g> <Nop>
nnoremap <C-h> <C-w>h
nnoremap <C-i> <Nop>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-m> <Nop>
nnoremap <C-n> <C-w>n
" nnoremap <C-o> <C-w>v
nnoremap <C-p> <Nop>
nnoremap <C-q> <Nop>
nnoremap <C-r> <C-r>
nnoremap <C-s> :<C-u>w<CR>
" nnoremap <C-t> => default: `jump back` in help
nnoremap <C-u> <Nop>
nnoremap <C-v> <C-v>
nnoremap <C-w> 10<C-y>
nnoremap <C-x> <C-x>
nnoremap <C-y> <Nop>
nnoremap <C-z> <C-z>

nnoremap <S-Left>  25<C-w><
nnoremap <S-Right> 25<C-w>>
nnoremap <S-Up>     5<C-w>-
nnoremap <S-Down>   5<C-w>+

nnoremap L <C-w>L
nnoremap H <C-w>H
" }}}

" insert mode {{{
inoremap <C-@> <Nop>
inoremap <C-a> <C-o>^
inoremap <C-b> <C-o>b
inoremap <C-c> <Esc>
inoremap <C-d> <C-o>x
inoremap <C-e> <C-o>$
inoremap <C-f> <C-o>w
inoremap <C-g> <C-g>
inoremap <C-h> <C-o>h
inoremap <C-i> <Tab>
inoremap <C-j> <C-o>gj
inoremap <C-k> <C-o>gk
inoremap <C-l> <C-o>l
inoremap <C-m> <CR>
" inoremap <C-n> <C-n>
inoremap <C-o> <C-o>
" inoremap <C-p> <Nop>
inoremap <C-q> <Nop>
inoremap <C-r> <C-r>
inoremap <C-s> <C-o>:w<CR>
inoremap <C-t> <Nop>
inoremap <C-u> <C-u>
inoremap <C-v> <Esc>o
inoremap <C-w> <C-w>
inoremap <C-x> <Nop>
inoremap <C-y> <Nop>
inoremap <C-z> <Nop>
" }}}

" select whole line by vv like yy and dd
nnoremap vv 0v$

" remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" move macro to Q and disable default q
nnoremap Q q
nnoremap q <Nop>

" define <Leader> and <LocalLeader>
let g:mapleader = "\<Space>"
let g:maplocalleader = "\<Space>"

" remove any existing keymap for leader and localleader
nnoremap <space> <Nop>
xnoremap <space> <Nop>

" toggle
nnoremap <Plug>(my-toggle) <Nop>
nmap T <Plug>(my-toggle)
nnoremap <silent> <Plug>(my-toggle)s :<C-u>setl spell!<CR>:setl spell?<CR>
nnoremap <silent> <Plug>(my-toggle)l :<C-u>setl list!<CR>:setl list?<CR>
nnoremap <silent> <Plug>(my-toggle)e :<C-u>setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> <Plug>(my-toggle)w :<C-u>setl wrap!<CR>:setl wrap?<CR>
nnoremap <silent> <Plug>(my-toggle)p :<C-u>setl paste!<CR>:setl paste?<CR>
nnoremap <silent> <Plug>(my-toggle)q :<C-u>copen<CR>
nnoremap <silent> <Plug>(my-toggle)n :<C-u>setl number!<CR>:setl number?<CR>

" tag navigation
nnoremap [t  :<C-u>tprevious<CR>
nnoremap ]t  :<C-u>tnext<CR>
nnoremap g[t :<C-u>tfirst<CR>
nnoremap g]t :<C-u>tlast<CR>

" quickfix navigation
nnoremap [q  :<C-u>cprevious<CR>
nnoremap ]q  :<C-u>cnext<CR>
nnoremap g[q :<C-u>cfirst<CR>
nnoremap g]q :<C-u>clast<CR>
nnoremap [l  :<C-u>lprevious<CR>
nnoremap ]l  :<C-u>lnext<CR>
nnoremap g[l :<C-u>lfirst<CR>
nnoremap g]l :<C-u>llast<CR>

" file navigation
nnoremap [f  :<C-u>previous<CR>
nnoremap ]f  :<C-u>next<CR>
nnoremap g[f :<C-u>first<CR>
nnoremap g]f :<C-u>last<CR>

" tab operation {{{
function! s:tab_quit() abort
  if tabpagenr('$') == 1
    quit
  else
    tabclose
  endif
endfunction

nnoremap <silent> <Plug>(my-tab-new) :<C-u>tabnew<CR>
nnoremap <silent> <Plug>(my-tab-quit) :<C-u>call <SID>tab_quit()<CR>
nnoremap <silent> <Plug>(my-tab-close) :<C-u>tabclose<CR>
nnoremap <silent> <Plug>(my-tab-only) :<C-u>tabonly<CR>
nnoremap <silent> <Plug>(my-tab-next) :<C-u>tabnext<CR>
nnoremap <silent> <Plug>(my-tab-prev) :<C-u>tabprevious<CR>
nnoremap <silent> <Plug>(my-tab-move-0) :<C-u>0tabmove<CR>
nnoremap <silent> <Plug>(my-tab-move-L) :<C-u>-tabmove<CR>
nnoremap <silent> <Plug>(my-tab-move-R) :<C-u>+tabmove<CR>
nnoremap <silent> <Plug>(my-tab-move-$) :<C-u>$tabmove<CR>
nnoremap <silent> <Plug>(my-tab-0) :<C-u>tabfirst<CR>
nnoremap <silent> <Plug>(my-tab-1) :<C-u>tabnext1<CR>
nnoremap <silent> <Plug>(my-tab-2) :<C-u>tabnext2<CR>
nnoremap <silent> <Plug>(my-tab-3) :<C-u>tabnext3<CR>
nnoremap <silent> <Plug>(my-tab-4) :<C-u>tabnext4<CR>
nnoremap <silent> <Plug>(my-tab-5) :<C-u>tabnext5<CR>
nnoremap <silent> <Plug>(my-tab-6) :<C-u>tabnext6<CR>
nnoremap <silent> <Plug>(my-tab-7) :<C-u>tabnext7<CR>
nnoremap <silent> <Plug>(my-tab-8) :<C-u>tabnext8<CR>
nnoremap <silent> <Plug>(my-tab-9) :<C-u>tabnext9<CR>
nnoremap <silent> <Plug>(my-tab-$) :<C-u>tablast<CR>

nnoremap <Plug>(my-tab) <Nop>
nmap <Leader>t <Plug>(my-tab)

nmap <Plug>(my-tab)n <Plug>(my-tab-new)
nmap <Plug>(my-tab)q <Plug>(my-tab-quit)
nmap <Plug>(my-tab)c <Plug>(my-tab-close)
nmap <Plug>(my-tab)o <Plug>(my-tab-only)

nmap <Plug>(my-tab)l <Plug>(my-tab-next)
nmap <Plug>(my-tab)h <Plug>(my-tab-prev)
nmap <Plug>(my-tab)j <Plug>(my-tab-$)
nmap <Plug>(my-tab)k <Plug>(my-tab-0)

nmap <Plug>(my-tab)L <Plug>(my-tab-move-R)
nmap <Plug>(my-tab)H <Plug>(my-tab-move-L)
nmap <Plug>(my-tab)J <Plug>(my-tab-move-$)
nmap <Plug>(my-tab)K <Plug>(my-tab-move-0)

nmap <Plug>(my-tab)0 <Plug>(my-tab-0)
nmap <Plug>(my-tab)1 <Plug>(my-tab-1)
nmap <Plug>(my-tab)2 <Plug>(my-tab-2)
nmap <Plug>(my-tab)3 <Plug>(my-tab-3)
nmap <Plug>(my-tab)4 <Plug>(my-tab-4)
nmap <Plug>(my-tab)5 <Plug>(my-tab-5)
nmap <Plug>(my-tab)6 <Plug>(my-tab-6)
nmap <Plug>(my-tab)7 <Plug>(my-tab-7)
nmap <Plug>(my-tab)8 <Plug>(my-tab-8)
nmap <Plug>(my-tab)9 <Plug>(my-tab-9)
nmap <Plug>(my-tab)$ <Plug>(my-tab-$)
" }}}
