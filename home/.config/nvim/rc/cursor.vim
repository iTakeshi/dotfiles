set showmatch             " highlight a partner of cursor character
set matchtime=1           " highlight a partner ASAP
set matchpairs& mps+=<:>  " add < and > pair
set updatetime=1000       " increase speed of CursorHold autocommand
set cursorline            " required for activating CursorLineNr highlight
set nocursorcolumn        " do not show column highlight
set virtualedit=block     " allow virtual editing in Visual block modes
set nostartofline         " let C-D, C-U,... to keep same column

" move cursor previous/next line when the cursor is first/last character in the
" line and user move the cursor left/right
set whichwrap=b,s,<,>,~,[,]
