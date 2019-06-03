set background=dark
set termguicolors

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name="dusty"

highlight Comment      guifg=#87d787                gui=italic
highlight Constant     guifg=#ff875f                gui=NONE
highlight Identifier   guifg=#87d7ff                gui=NONE
highlight Statement    guifg=#d7d787                gui=bold
highlight PreProc      guifg=#ff87af                gui=NONE
highlight Type         guifg=#d7af87                gui=bold
highlight Special      guifg=#5fd7af                gui=NONE
highlight Underlined   guifg=#0000ff                gui=underline
highlight Ignore       guifg=#626262                gui=NONE
highlight Error        guifg=#0000ff
highlight Todo         guifg=#ff5f00 guibg=#ffff00  gui=NONE

highlight ColorColumn                guibg=#4e4e4e
highlight Conceal      guifg=#d3d3d3 guibg=NONE
highlight Cursor       guifg=#000000 guibg=#ffff00  gui=NONE
highlight DiffAdd      guifg=#000000 guibg=#ffffaf
highlight DiffChange   guifg=#000000 guibg=#87d7ff
highlight DiffDelete   guifg=#000000 guibg=#626262  gui=NONE
highlight DiffText     guifg=#000000 guibg=#ff5fd7  gui=NONE
highlight ErrorMsg     guifg=#ffffff guibg=#ff0000  gui=NONE
highlight FoldColumn   guifg=#d7af87 guibg=#4e4e4e  gui=NONE
highlight Folded       guifg=#87ffff guibg=#4e4e4e  gui=NONE
highlight IncSearch    guifg=#b0ffff guibg=#2050d0
highlight LineNr       guifg=#ffd700                gui=NONE
highlight MatchParen   guifg=#00ffff guibg=NONE     gui=bold
highlight ModeMsg      guifg=#87d7ff                gui=NONE
highlight MoreMsg      guifg=#5fffaf                gui=NONE
highlight NonText      guifg=#00ffff guibg=#262626  gui=NONE
highlight Normal       guifg=#d3d3d3 guibg=#303030  gui=NONE
highlight NormalFloat  guifg=#d3d3d3 guibg=#4e4e4e  gui=NONE
highlight Pmenu        guifg=#ffffff guibg=#445599  gui=NONE
highlight PmenuSel     guifg=#445599 guibg=#808080
highlight Question     guifg=#00ff87                gui=NONE
highlight Search       guifg=#d3d3d3 guibg=#445599  gui=NONE
highlight SpecialKey   guifg=#4e4e4e                gui=NONE
highlight SpellBad                   guibg=#4e4e4e
highlight SpellLocal                 guibg=#4e4e4e
highlight SpellRare                  guibg=#4e4e4e
highlight StatusLine   guifg=#000000 guibg=#c2bfa5  gui=bold
highlight StatusLineNC guifg=#808080 guibg=#626262  gui=NONE
highlight Title        guifg=#ff5f5f                gui=NONE
highlight VertSplit    guifg=#626262 guibg=#626262  gui=NONE
highlight Visual       guifg=#303030 guibg=#d7af87  gui=NONE
highlight WarningMsg   guifg=#ff875f                gui=NONE
highlight WildMenu     guifg=#808080 guibg=#303030  gui=NONE
