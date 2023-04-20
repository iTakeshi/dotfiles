-- Skip loading default plugins
vim.g.loaded_gzip = true
vim.g.loaded_man  = true
vim.g.loaded_matchit = true
vim.g.loaded_netrw = true
vim.g.loaded_netrwFileHandlers = true
vim.g.loaded_netrwPlugin = true
vim.g.loaded_netrwSettings = true
vim.g.loaded_remote_plugins = true
vim.g.loaded_spellfile_plugin = true
vim.g.loaded_tar = true
vim.g.loaded_tarPlugin = true
vim.g.loaded_2html_plugin = true
vim.g.loaded_tutor_mode_plugin = true
vim.g.loaded_zip = true
vim.g.loaded_zipPlugin = true

-- Non-default options
vim.opt.backspace       = "indent,eol,nostop" -- allow backspacing over everything in insert mode
vim.opt.breakindent     = true                -- wrapped lines are visually indented
vim.opt.clipboard       = "unnamedplus"       -- use external clipboard tool
vim.opt.cmdheight       = 2                   -- the number of screen lines to use for command line
vim.opt.colorcolumn     = "120"               -- highlight the 120th column in a line
vim.opt.copyindent      = true                -- copy the structure of the existing lines indent when auto-indenting a new line
vim.opt.cursorline      = true                -- required for CursorLineNr highlight
vim.opt.diffopt:append("algorithm:minimal")   -- seek for smallest possible diff
vim.opt.expandtab       = true                -- use spaces instead of TAB
vim.opt.fileencodings   = "ucs-bom,utf-8,euc-jp,iso-2022-jp,cp932,utf-16,utf-16le" -- try Japanese encodings
vim.opt.fileformats     = "unix,dos,mac"      -- try unix first and lastly mac
vim.opt.foldmethod      = "marker"            -- use triple braces to define fold blocks
vim.opt.ignorecase      = true                -- case-insensitive search
vim.opt.linebreak       = true                -- wrap lines at breakat characters
vim.opt.list            = true                -- show invisible characters
vim.opt.listchars       = "eol:$,tab:>-,trail:_,extends:&,nbsp:%" -- invisible character mappings
vim.opt.matchtime       = 1                   -- flash very briefly on showmatch
vim.opt.modeline        = false               -- do not check modeline
vim.opt.preserveindent  = true                -- preserve indent structure when manipulating indentation
vim.opt.report          = 0                   -- report all changes
vim.opt.scrolloff       = 5                   -- keep 5 lines margin when scrolling
vim.opt.shiftround      = true                -- round indent to multiple of shiftwidth with > and <
vim.opt.shiftwidth      = 2                   -- the number of spaces of an indent
vim.opt.shortmess:append("acI")               -- do not display greeting message
vim.opt.showbreak       = "> "                -- indicate line continuation
vim.opt.showmatch       = true                -- frash opening parenthesis when closed
vim.opt.showtabline     = 2                   -- always show tabline"
vim.opt.sidescrolloff   = 4                   -- minimum number of screen columns to keep in scroll
vim.opt.smartcase       = true                -- automatically switch to case-sensitive search
vim.opt.softtabstop     = 2                   -- insert 2 whitespaces for a tab
vim.opt.swapfile        = false               -- do not use swap files
vim.opt.tabstop         = 8                   -- a tab character is equivalent to 8 single-width characters
vim.opt.termguicolors   = true                -- enable 24-bit colors
vim.opt.timeout         = false               -- wait for key sequence indefinitely
vim.opt.ttimeoutlen     = 100                 -- wait 100 ms for key code sequence
vim.opt.undofile        = true                -- keep undo history
vim.opt.updatetime      = 1000                -- trigger CursorHold autocmd faster
vim.opt.virtualedit     = "block"             -- move cursor where there is no actual character when visual block mode
vim.opt.whichwrap       = "b,s,h,l,<,>,~,[,]" -- enable to move to next/previous line by h/l/<BS>
vim.opt.wildmode        = "full,longest,list" -- rich cmdline completion
vim.opt.wrap            = false               -- do not wrap long text
vim.opt.writebackup     = false               -- do not create backup file on write

-- autocmds
vim.api.nvim_create_augroup("MyAutoCmd", {})
vim.api.nvim_create_autocmd("Filetype", {
  group = "MyAutoCmd",
  pattern = "help",
  command = "wincmd L",
})
vim.api.nvim_create_autocmd("VimLeave", {
  group = "MyAutoCmd",
  callback = function()
    for _, f in pairs(vim.fn.glob(vim.fn.stdpath("config") .. "/spell/*.add", true, true)) do
      if vim.fn.filereadable(f) and (not(vim.fn.filereadable(f .. ".spl")) or vim.fn.getftime(f) > vim.fn.getftime(f .. ".spl")) then
        vim.cmd("mkspell! " .. vim.fn.fnameescape(f))
      end
    end
  end,
})

-- colorscheme
vim.cmd [[
  match MyZenkakuSpace /　/
  highlight MyZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
]]
