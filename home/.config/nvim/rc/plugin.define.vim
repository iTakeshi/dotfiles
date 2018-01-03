" manager itself
call g:dein#add('Shougo/dein.vim')

" utility
call g:dein#add('lambdalisue/vim-improve-diff')
call g:dein#add('lambdalisue/vim-unified-diff')
call g:dein#add('ryanoasis/vim-devicons')
call g:dein#add('lambdalisue/gina.vim')
call g:dein#add('junegunn/vim-easy-align')
call g:dein#add('itchyny/lightline.vim')
call g:dein#add('Yggdroot/indentLine')
call g:dein#add('kana/vim-repeat')
call g:dein#add('tyru/open-browser.vim')
call g:dein#add('t9md/vim-choosewin')
call g:dein#add('Shougo/unite.vim')
call g:dein#add('Shougo/vimfiler.vim')
call g:dein#add('eed3si9n/LanguageClient-neovim')

" auto completion
call g:dein#add('Shougo/deoplete.nvim')
call g:dein#add('Shougo/neosnippet.vim')
call g:dein#add('Shougo/neosnippet-snippets')
call g:dein#add('Shougo/neoinclude.vim')
call g:dein#add('Shougo/neco-syntax')
call g:dein#add('Shougo/neco-vim')
call g:dein#add('ujihisa/neco-look')

" language support
call g:dein#add('tyru/caw.vim') " comment syntax
call g:dein#add('derekwyatt/vim-scala',   {'lazy': 1, 'on_ft': 'scala'})
call g:dein#add('vim-ruby/vim-ruby',      {'lazy': 1, 'on_ft': 'ruby'})
call g:dein#add('othree/html5.vim',       {'lazy': 1, 'on_ft': 'html'})
call g:dein#add('hail2u/vim-css3-syntax', {'lazy': 1, 'on_ft': 'css'})
call g:dein#add('groenewege/vim-less',    {'lazy': 1, 'on_ft': 'less'})
call g:dein#add('cespare/vim-toml',       {'lazy': 1, 'on_ft': 'toml'})
call g:dein#add('rust-lang/rust.vim',     {'lazy': 1, 'on_ft': 'rust'})
call g:dein#add('tikhomirov/vim-glsl',    {'lazy': 1, 'on_ft': 'glsl'})
call g:dein#add('lazywei/vim-matlab',     {'lazy': 1, 'on_ft': 'matlab'})
call g:dein#add('elzr/vim-json',          {'lazy': 1, 'on_ft': 'json'})

" textobj
" Default text objexts are: wWspt(b){B}[]<>`'"
call g:dein#add('kana/vim-textobj-user')
call g:dein#add('kana/vim-textobj-line')                                   " l
call g:dein#add('kana/vim-textobj-syntax')                                 " y
call g:dein#add('kana/vim-textobj-indent')                                 " iI
call g:dein#add('kana/vim-textobj-datetime')                               " d + adftz
call g:dein#add('kana/vim-textobj-fold')                                   " z
call g:dein#add('Julian/vim-textobj-variable-segment')                     " v
call g:dein#add('thinca/vim-textobj-between')                              " f
call g:dein#add('thinca/vim-textobj-comment')                              " cC
call g:dein#add('saihoooooooo/vim-textobj-space')                          " S
call g:dein#add('mattn/vim-textobj-url')                                   " u
call g:dein#add('sgur/vim-textobj-parameter')                              " ,
call g:dein#add('rbonvall/vim-textobj-latex', {'lazy': 1, 'on_ft': 'tex'}) " \$qQe

" operator
call g:dein#add('kana/vim-operator-user')
call g:dein#add('kana/vim-operator-replace')      " no default => g + r
call g:dein#add('rhysd/vim-operator-surround')    " no default => S + adr
call g:dein#add('haya14busa/vim-operator-flashy') " no default => yY
