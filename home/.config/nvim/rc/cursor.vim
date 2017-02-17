set showmatch             " highlight a partner of cursor character
set matchtime=1           " highlight a partner ASAP
set matchpairs& mps+=<:>  " add < and > pair
set updatetime=1000       " increase speed of CursorHold autocommand

set virtualedit=block     " allow virtual editing in Visual block modes
set nostartofline         " let C-D, C-U,... to keep same column

" move cursor previous/next line when the cursor is first/last character in the
" line and user move the cursor left/right
set whichwrap=b,s,<,>,~,[,]

" do not display cursorline/column (it makes Vim really slow)
set nocursorline
set nocursorcolumn
