set background=dark
set termguicolors

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "pastel"

let s:bold      = "bold"
let s:underline = "underline"
let s:undercurl = "undercurl"
let s:reverse   = "reverse"
let s:italic    = "italic"
let s:standout  = "standout"
let s:none      = "NONE"

let s:fg        = "#ccd2dc"
let s:bg        = "#292933"
let s:red       = "#e6aaaa"
let s:red_d     = "#996767"
let s:orange    = "#e6be96"
let s:orange_d  = "#997a5c"
let s:yellow    = "#e6e68c"
let s:yellow_d  = "#999951"
let s:green     = "#b9e6b9"
let s:green_d   = "#679967"
let s:blue      = "#8cc8e6"
let s:blue_d    = "#518599"
let s:purple    = "#b9b9e6"
let s:purple_d  = "#7a7a99"
let s:magenta   = "#e6b9e6"
let s:magenta_d = "#997a99"
let s:rgb_r     = "#ff0000"
let s:rgb_g     = "#00ff00"
let s:rgb_b     = "#0000ff"
let s:cmy_c     = "#00ffff"
let s:cmy_m     = "#ff00ff"
let s:cmy_y     = "#ffff00"
let s:black     = "#1a1a26"
let s:gray_0    = s:bg
let s:gray_1    = "#3d3d4d"
let s:gray_2    = "#525266"
let s:gray_3    = "#6c6c80"
let s:gray_4    = "#8a8a99"
let s:white     = "#ffffff"

function! s:hi(name, fg, bg, attr) abort " {{{
    let l:guifg   = type(a:fg) != type(0) ? "guifg=" . a:fg : ""
    let l:guibg   = "guibg=" . (type(a:bg)   != type(0) ? a:bg   : s:bg)
    let l:guiattr = "gui="   . (type(a:attr) != type(0) ? a:attr : s:none)
    exec "hi" a:name l:guifg l:guibg l:guiattr
endfunction " }}}

call <SID>hi("Comment"      , s:green_d , 0          , s:italic)
call <SID>hi("Constant"     , s:red     , 0          , 0)
call <SID>hi("Identifier"   , s:blue    , 0          , 0)
call <SID>hi("Statement"    , s:yellow  , 0          , 0)
call <SID>hi("PreProc"      , s:magenta , 0          , 0)
call <SID>hi("Type"         , s:orange  , 0          , 0)
call <SID>hi("Special"      , s:purple  , 0          , 0)
call <SID>hi("Underlined"   , s:blue    , 0          , s:underline)
call <SID>hi("Ignore"       , s:gray_2  , 0          , 0)
call <SID>hi("Error"        , s:cmy_y   , s:red_d    , 0)
call <SID>hi("Todo"         , s:rgb_r   , s:yellow   , s:italic)

" TODO: QuickFixLine, Term*
call <SID>hi("ColorColumn"  , 0         , s:gray_1   , 0)
call <SID>hi("Conceal"      , s:gray_3  , 0          , 0)
call <SID>hi("Cursor"       , 0         , 0          , s:reverse)
call <SID>hi("CursorLine"   , 0         , 0          , 0)
call <SID>hi("Directory"    , s:blue    , 0          , s:bold)
call <SID>hi("DiffAdd"      , s:gray_0  , s:yellow   , 0)
call <SID>hi("DiffChange"   , s:gray_0  , s:blue     , 0)
call <SID>hi("DiffDelete"   , s:gray_0  , s:gray_3   , 0)
call <SID>hi("DiffText"     , s:gray_0  , s:red      , 0)
call <SID>hi("ErrorMsg"     , s:rgb_r   , s:yellow   , 0)
call <SID>hi("VertSplit"    , s:gray_3  , s:gray_3   , 0)
call <SID>hi("Folded"       , s:green   , s:gray_2   , 0)
call <SID>hi("FoldColumn"   , s:orange  , s:gray_1   , 0)
call <SID>hi("SignColumn"   , 0         , s:gray_1   , 0)
call <SID>hi("IncSearch"    , s:fg      , s:blue_d   , 0)
call <SID>hi("LineNr"       , s:orange  , s:gray_1   , 0)
call <SID>hi("CursorLineNr" , s:orange  , s:gray_1   , s:bold)
call <SID>hi("MatchParen"   , s:green   , 0          , s:bold)
call <SID>hi("ModeMsg"      , s:blue    , 0          , 0)
call <SID>hi("MoreMsg"      , s:green   , 0          , 0)
call <SID>hi("NonText"      , s:gray_3  , s:black    , 0)
call <SID>hi("Normal"       , s:fg      , s:bg       , 0)
call <SID>hi("NormalFloat"  , s:fg      , s:gray_1   , 0)
call <SID>hi("Pmenu"        , s:white   , s:blue_d   , 0)
call <SID>hi("PmenuSel"     , s:white   , s:green_d  , 0)
call <SID>hi("PmenuSbar"    , 0         , s:gray_3   , 0)
call <SID>hi("PmenuThumb"   , 0         , s:gray_4   , 0)
call <SID>hi("Question"     , s:green   , 0          , 0)
call <SID>hi("Search"       , s:white   , s:purple_d , 0)
call <SID>hi("SpecialKey"   , s:gray_3  , 0          , 0)
call <SID>hi("SpellBad"     , 0         , s:gray_2   , 0)
call <SID>hi("SpellCap"     , 0         , s:gray_2   , 0)
call <SID>hi("SpellLocal"   , 0         , s:gray_2   , 0)
call <SID>hi("SpellRare"    , 0         , s:gray_2   , 0)
call <SID>hi("StatusLine"   , s:gray_0  , s:fg       , 0)
call <SID>hi("StatusLineNC" , s:gray_4  , s:fg       , 0)
call <SID>hi("Title"        , s:green   , 0          , 0)
call <SID>hi("Visual"       , 0         , s:gray_2   , 0)
call <SID>hi("WarningMsg"   , s:red     , 0          , 0)
call <SID>hi("WhiteSpace"   , 0         , s:yellow_d , 0)
call <SID>hi("WildMenu"     , s:gray_0  , s:yellow   , 0)
