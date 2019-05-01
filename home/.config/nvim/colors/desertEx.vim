" Vim color file
" Maintainer: Takeshi D. ITOH <itakeshi.net@gmail.com>

set background=dark
let g:colors_name="desertEx"

highlight      Normal       guifg=#d3d3d3 guibg=#2b2b2b gui=NONE

" highlight groups
highlight      Cursor       guifg=#000000 guibg=#ffff00 gui=NONE
highlight      DiffAdd      guifg=#000000 guibg=#ffe7ba gui=NONE
highlight      DiffChange   guifg=#000000 guibg=#87ceeb gui=NONE
highlight      DiffDelete   guifg=#000000 guibg=#737373 gui=NONE
highlight      DiffText     guifg=#000000 guibg=#ff6eb4 gui=NONE
highlight      ErrorMsg     guifg=#ffffff guibg=#ff0000 gui=NONE
highlight      FoldColumn   guifg=#d2b48c guibg=#4d4d4d gui=NONE
highlight      Folded       guifg=#79cdcd guibg=#4d4d4d gui=NONE
highlight      IncSearch    guifg=#b0ffff guibg=#2050d0 gui=NONE
highlight      LineNr       guifg=#cdaa7d               gui=NONE
highlight      MatchParen   guifg=#00ffff guibg=NONE    gui=bold
highlight      ModeMsg      guifg=#87ceeb               gui=NONE
highlight      MoreMsg      guifg=#2e8b57               gui=NONE
highlight      NonText      guifg=#00ffff guibg=#333333 gui=NONE
highlight      Pmenu        guifg=#ffffff guibg=#445599 gui=NONE
highlight      PmenuSel     guifg=#445599 guibg=#bebebe gui=NONE
highlight      Question     guifg=#00ff7f               gui=NONE
highlight      Search       guifg=#cccccc guibg=#445599 gui=NONE
highlight      SpecialKey   guifg=#4d4d4d               gui=NONE
highlight      StatusLine   guifg=#000000 guibg=#c2bfa5 gui=bold
highlight      StatusLineNC guifg=#bebebe guibg=#666666 gui=NONE
highlight      Title        guifg=#cd5c5c               gui=NONE
highlight      VertSplit    guifg=#666666 guibg=#666666 gui=NONE
highlight      Visual       guifg=#2b2b2b guibg=#ffa54f gui=NONE
highlight      WarningMsg   guifg=#fa8072               gui=NONE
highlight      WildMenu     guifg=#bebebe guibg=#2b2b2b gui=NONE
highlight      ColorColumn                guibg=#4d4d4d gui=NONE

" syntax highlighting groups
highlight      Comment      guifg=#7ccd7c               gui=NONE
highlight      Constant     guifg=#fa8072               gui=NONE
highlight      Identifier   guifg=#87ceeb               gui=NONE
"highlight link Function                                          Identifier
highlight      Statement    guifg=#eedc82               gui=bold
highlight      PreProc      guifg=#ee799f               gui=NONE
highlight      Type         guifg=#ffa54f               gui=bold
highlight      Special      guifg=#76eec6               gui=NONE
highlight      Ignore       guifg=#666666               gui=NONE
highlight      Todo         guifg=#ff4500 guibg=#eeee00 gui=NONE

highlight      SpellBad                   guibg=#4d4d4d gui=NONE
highlight      SpellLocal                 guibg=#4d4d4d gui=NONE
highlight      SpellRare                  guibg=#4d4d4d gui=NONE
