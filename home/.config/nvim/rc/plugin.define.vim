" manager itself
call g:dein#add('Shougo/dein.vim')

" utility
call g:dein#add('lambdalisue/vim-improve-diff')
call g:dein#add('lambdalisue/vim-unified-diff')
call g:dein#add('ryanoasis/vim-devicons')
call g:dein#add('lambdalisue/gina.vim')
call g:dein#add('itchyny/lightline.vim')
call g:dein#add('Yggdroot/indentLine')
call g:dein#add('tpope/vim-repeat')
call g:dein#add('t9md/vim-choosewin')
call g:dein#add('Shougo/defx.nvim'              , {'do': ':UpdateRemotePlugins'})
call g:dein#add('kristijanhusak/defx-icons')
call g:dein#add('ntpeters/vim-better-whitespace')
call g:dein#add('neoclide/coc.nvim'             , {'merge':0, 'build': './install.sh nightly'})
call g:dein#add('cocopon/inspecthi.vim'         , {'on_cmd': ['Inspecthi', 'InspecthiShowInspector']})

" language support
call g:dein#add('sheerun/vim-polyglot')
call g:dein#add('lervag/vimtex'      , {'on_ft': ['tex', 'bib']})
call g:dein#add('lazywei/vim-matlab' , {'on_ft': 'matlab'})

" textobj
" Default text objexts are: wWspt(b){B}[]<>`'"
call g:dein#add('kana/vim-textobj-user')
call g:dein#add('thinca/vim-textobj-comment'          , {'on_map': {'xo': '<Plug>'}}) " c
call g:dein#add('kana/vim-textobj-datetime'           , {'on_map': {'xo': '<Plug>'}}) " d + adftz
call g:dein#add('kana/vim-textobj-entire'             , {'on_map': {'xo': '<Plug>'}}) " e
call g:dein#add('thinca/vim-textobj-between'          , {'on_map': {'xo': '<Plug>'}}) " f
call g:dein#add('kana/vim-textobj-indent'             , {'on_map': {'xo': '<Plug>'}}) " iI
call g:dein#add('kana/vim-textobj-line'               , {'on_map': {'xo': '<Plug>'}}) " l
call g:dein#add('saihoooooooo/vim-textobj-space'      , {'on_map': {'xo': '<Plug>'}}) " S
call g:dein#add('mattn/vim-textobj-url'               , {'on_map': {'xo': '<Plug>'}}) " u
call g:dein#add('Julian/vim-textobj-variable-segment' , {'on_map': {'xo': '<Plug>'}}) " v
call g:dein#add('kana/vim-textobj-syntax'             , {'on_map': {'xo': '<Plug>'}}) " y
call g:dein#add('kana/vim-textobj-fold'               , {'on_map': {'xo': '<Plug>'}}) " z
call g:dein#add('sgur/vim-textobj-parameter'          , {'on_map': {'xo': '<Plug>'}}) " ,
call g:dein#add('rbonvall/vim-textobj-latex'          , {'on_ft': 'tex'})             " \$qQe

" operator
call g:dein#add('kana/vim-operator-user')
call g:dein#add('junegunn/vim-easy-align'        , {'on_map': '<Plug>(EasyAlign'}) " g + a
call g:dein#add('tyru/caw.vim'                   , {'on_map': '<Plug>'})           " g + c
call g:dein#add('kana/vim-operator-replace'      , {'on_map': '<Plug>'})           " g + r
call g:dein#add('rhysd/vim-operator-surround'    , {'on_map': '<Plug>'})           " g + s + adr
call g:dein#add('haya14busa/vim-operator-flashy' , {'on_map': '<Plug>'})           " yY
