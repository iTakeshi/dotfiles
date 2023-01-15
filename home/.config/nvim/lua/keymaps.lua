vim.g.mapleader = " "
vim.g.maplocalleader = " "
Map("", "<space>", "<nop>")           -- move cursor foward           => nop (mapleader)


-- Normal mode
-----------------------------------------------------------------------------------------------------------------------

-- Map("n", "a")                      -- insert after cursor
-- Map("n", "b")                      -- move cursor back one word
-- Map("n", "c")                      -- delete text and insert
-- Map("n", "d")                      -- delete text
-- Map("n", "e")                      -- move cursor to end of word
-- Map("n", "f")                      -- find character
-- Map("n", "g")                      -- prefix for various command
-- Map("n", "h")                      -- move cursor left
-- Map("n", "i")                      -- enter insert mode
Map("n", "j", "gj")                   -- move cursor down             => fix behavior for wrapped lines
Map("n", "k", "gk")                   -- move cursor up               => fix behavior for wrapped lines
-- Map("n", "l")                      -- move cursor right
Map("n", "m", "<nop>")                -- mark                         => nop
-- Map("n", "n")                      -- next match
-- Map("n", "o")                      -- enter insert mode for next line
-- Map("n", "p")                      -- paste
Map("n", "q", "<nop>")                -- start recording              => nop
-- Map("n", "r")                      -- replace
-- Map("n", "s")                      -- delete characters and insert
Map("n", "t", "<nop>")                -- move cursor before character => nop
-- Map("n", "u")                      -- undo
-- Map("n", "v")                      -- enter visual mode
-- Map("n", "w")                      -- move cursor forward one word
-- Map("n", "x")                      -- delete character
-- Map("n", "y")                      -- yank
-- Map("n", "z")                      -- prefix for various command

-- Map("n", "A")                      -- enter insert mode at EOL
-- Map("n", "B")                      -- move cursor back one WORD
-- Map("n", "C")                      -- delete toward EOL and insert
-- Map("n", "D")                      -- delete toward EOL
-- Map("n", "E")                      -- same as e
-- Map("n", "F")                      -- find character backward
-- Map("n", "G")                      -- go to last line
Map("n", "H", "<c-w>H")               -- move cursor to window top      => move window leftmost
-- Map("n", "I")                      -- enter insert mode at SOL
-- Map("n", "J")                      -- concatenate with next line
Map("n", "K", "<nop>")                -- start keywordprg               => nop (because man plugin is not loaded)
Map("n", "L", "<c-w>L")               -- move cursor to window bottom   => move window rightmost
Map("n", "M", "<nop>")                -- move cursor to window middle   => nop
-- Map("n", "N")                      -- previous match
-- Map("n", "O")                      -- enter insert mode for previous line
-- Map("n", "P")                      -- paste previous line
Map("n", "Q", "q")                    -- repeat last recorded register  => start recording
-- Map("n", "R")                      -- enter replace mode
-- Map("n", "S")                      -- delete whole line and insert
Map("n", "T", "<nop>")                -- move cursor after character    => nop (later used as my-toggle)
Map("n", "U", "<nop>")                -- undo changes on one line
-- Map("n", "V")                      -- line-wise visual mode
-- Map("n", "W")                      -- move cursor forward one WORD
-- Map("n", "X")                      -- delete character before cursor
-- Map("n", "Y")                      -- yank to EOL (nvim mod)
-- Map("n", "Z")                      -- nop

Map("n", "<s-left>", "25<c-w><")      -- move cursor back one word      => decrease window width
Map("n", "<s-right>", "25<c-w>>")     -- move cursor forward one word   => increase window width
Map("n", "<s-up>", "5<c-w>+")         -- page up                        => increase window height
Map("n", "<s-down>", "5<c-w>-")       -- page down                      => decrease window height

-- Map("n", "<c-a>")                  -- increment
Map("n", "<c-b>", "<nop>")            -- scroll window up               => nop
-- Map("n", "<c-c>")                  -- cancel operation
Map("n", "<c-d>", "<c-l>")            -- scroll window down             => redraw screen
Map("n", "<c-e>", "10<c-d>")          -- scroll window down one line    => scroll window down
Map("n", "<c-f>", "<nop>")            -- scroll window down             => nop (later used for filer)
-- Map("n", "<c-g>")                  -- print current file name
Map("n", "<c-h>", "<c-w>h")           -- move cursor to left            => focus on the left window
-- Map("n", "<c-i>")                  -- jump forward
Map("n", "<c-j>", "<c-w>j")           -- move cursor down one line      => focus on the lower window
Map("n", "<c-k>", "<c-w>k")           -- nop                            => focus on the upper window
Map("n", "<c-l>", "<c-w>l")           -- redraw screen (nvim mod)       => focus on the right window
Map("n", "<c-m>", "<nop>")            -- move cursor down one line      => nop
Map("n", "<c-n>", "<cmd>vnew<cr>")    -- move cursor down one line      => vnew
-- Map("n", "<c-o>")                  -- jump back
Map("n", "<c-p>", "<nop>")            -- move cursor up one line         => nop
Map("n", "<c-q>", "Q")                -- enter block visual mode        => repeat last recorded register
-- Map("n", "<c-r>")                  -- redo
-- Map("n", "<c-s>")                  -- nop
Map("n", "<c-t>", "<nop>")            -- tag jump back                  => nop
Map("n", "<c-u>", "<nop>")            -- scroll window up               => nop
-- Map("n", "<c-v>")                  -- enter block visual mode
Map("n", "<c-w>", "10<c-u>")          -- wincmd                         => scroll window up
-- Map("n", "<c-x>")                  -- decrement
Map("n", "<c-y>", "<nop>")            -- scroll window up one line      => nop
-- Map("n", "<c-z>")                  -- suspend

Map("n", "<esc><esc>", "<cmd>nohlsearch<cr>") -- clear search highlight

-- toggle
Map("n", "<plug>(my-toggle)", "<nop>")
Map("n", "T", "<plug>(my-toggle)", { noremap = false })
Map("n", "<plug>(my-toggle)n", "<cmd>setl number!<cr><cmd>setl number?<cr>")
Map("n", "<plug>(my-toggle)p", "<cmd>setl paste!<cr><cmd>setl paste?<cr>")
Map("n", "<plug>(my-toggle)s", "<cmd>setl spell!<cr><cmd>setl spell?<cr>")
Map("n", "<plug>(my-toggle)w", "<cmd>setl wrap!<cr><cmd>setl wrap?<cr>")

-- tab
Map("n", "<plug>(my-tab)", "<nop>")
Map("n", "<leader>t", "<plug>(my-tab)", { noremap = false })
Map("n", "<plug>(my-tab)n", "<cmd>tabnew<cr>")
Map("n", "<plug>(my-tab)l", "<cmd>tabnext<cr>")
Map("n", "<plug>(my-tab)h", "<cmd>tabprevious<cr>")
Map("n", "<plug>(my-tab)L", "<cmd>-tabmove<cr>")
Map("n", "<plug>(my-tab)H", "<cmd>+tabmove<cr>")
Map("n", "<plug>(my-tab)0", "<cmd>tabfirst<cr>")
Map("n", "<plug>(my-tab)1", "<cmd>tabnext1<cr>")
Map("n", "<plug>(my-tab)2", "<cmd>tabnext2<cr>")
Map("n", "<plug>(my-tab)3", "<cmd>tabnext3<cr>")
Map("n", "<plug>(my-tab)4", "<cmd>tabnext4<cr>")
Map("n", "<plug>(my-tab)5", "<cmd>tabnext5<cr>")
Map("n", "<plug>(my-tab)6", "<cmd>tabnext6<cr>")
Map("n", "<plug>(my-tab)7", "<cmd>tabnext7<cr>")
Map("n", "<plug>(my-tab)8", "<cmd>tabnext8<cr>")
Map("n", "<plug>(my-tab)9", "<cmd>tabnext9<cr>")
Map("n", "<plug>(my-tab)$", "<cmd>tablast<cr>")


-- Insert mode
-----------------------------------------------------------------------------------------------------------------------

Map("i", "<c-a>", "<c-o>^")           -- repeat inserted text           => move cursor to SOL
Map("i", "<c-b>", "<c-o>b")           -- nop                            => move cursor back one word
Map("i", "<c-c>", "<esc>")            -- exit insert mode w/o autocmd   => exit insert with autocmd
Map("i", "<c-d>", "<nop>")            -- delete an indent               => nop
Map("i", "<c-e>", "<c-o>$")           -- insert character below cursor  => move cursor to EOL
Map("i", "<c-f>", "<nop>")            -- reindent                       => nop
Map("i", "<c-g>", "<nop>")            -- prefix for various commands    => nop
Map("i", "<c-h>", "<c-o>h")           -- backspace                      => move cursor back
-- Map("i", "<c-i>")                  -- insert tab / equivalent spaces
Map("i", "<c-j>", "<c-o>gj")          -- same as <cr>                   => move cursor down
Map("i", "<c-k>", "<c-o>gk")          -- digraph                        => move cursor up
Map("i", "<c-l>", "<c-o>l")           -- nop                            => move cursor forward
-- Map("i", "<c-m>")                  -- same as <cr>
Map("i", "<c-n>", "<nop>")            -- completion                     => nop (later used for completion)
Map("i", "<c-o>", "<c-o>o")           -- execute one command            => restart insert in next line
Map("i", "<c-p>", "<nop>")            -- completion                     => nop (later used for completion)
Map("i", "<c-q>", "<nop>")            -- same as <c-v>                  => nop
-- Map("i", "<c-r>")                  -- insert content of register
Map("i", "<c-s>", "<c-o><cmd>w<cr>")  -- nop                            => save
Map("i", "<c-t>", "<nop>")            -- insert indent                  => nop
-- Map("i", "<c-u>")                  -- delete all characters before cursor (nvim mod)
-- Map("i", "<c-v>")                  -- insert char code
-- Map("i", "<c-w>")                  -- delete one word (nvim mod)
Map("i", "<c-x>", "<nop>")            -- prefix for scroll commands     => nop
Map("i", "<c-y>", "<nop>")            -- insert character above cursor  => nop
-- Map("i", "<c-z>")                  -- nop


-- Command mode
-----------------------------------------------------------------------------------------------------------------------

Map("c", "<c-a>", "<c-b>")            -- completion                     => move cursot to SOL
Map("c", "<c-b>", "<s-left>")         -- nop                            => move cursor back one word
-- Map("c", "<c-c>")                  -- exit command mode
-- Map("c", "<c-d>")                  -- list completion candidates
-- Map("c", "<c-e>")                  -- move cursor to EOL
-- Map("c", "<c-f>")                  -- open command-line window
-- Map("c", "<c-g>")                  -- move to next incremental search match
Map("c", "<c-h>", "<left>")           -- backspace                      => move cursor back
-- Map("c", "<c-i>")                  -- completion
-- Map("c", "<c-j>")                  -- same as <cr>
Map("c", "<c-k>", "<nop>")            -- digraph                        => nop
Map("c", "<c-l>", "<right>")          -- nop                            => move cursor forward
-- Map("c", "<c-m>")                  -- same as <cr>
-- Map("c", "<c-n>")                  -- completion
-- Map("c", "<c-o>")                  -- nop
-- Map("c", "<c-p>")                  -- completion
Map("c", "<c-q>", "<nop>")            -- same as <c-v>                  => nop
-- Map("c", "<c-r>")                  -- insert content of register
-- Map("c", "<c-s>")                  -- nop
-- Map("c", "<c-t>")                  -- move to previous incremental search match
-- Map("c", "<c-u>")                  -- delete all characters before cursor
-- Map("c", "<c-v>")                  -- insert char code
-- Map("c", "<c-w>")                  -- delete one word
-- Map("c", "<c-x>")                  -- nop
Map("c", "<c-y>", "<nop>")            -- yank modeless selection        => nop
-- Map("c", "<c-z>")                  -- completion

-- automatically escape / or ?
Map("c", "/", function() return vim.fn.getcmdtype() == "/" and "\\/" or "/" end, { expr = true, silent = false })
Map("c", "?", function() return vim.fn.getcmdtype() == "?" and "\\?" or "?" end, { expr = true, silent = false })
