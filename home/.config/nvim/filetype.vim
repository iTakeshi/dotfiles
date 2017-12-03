if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect
  autocmd!
  " Markdown
  au BufNewFile,BufRead *.md,*.mkd,*.markdown setf markdown
  " LESS
  au BufNewFile,BufRead *.less setf less
  " MATLAB
  au BufNewFile,BufRead *.m setf matlab
  " Scala
  au BufNewFile,BufRead *.scala setf scala
  " Rust
  au BufNewFile,BufRead *.rs setf rust
  " GLSL
  au BufNewFile,BufRead *.vert,*.tesc,*.tese,*.geom,*.frag,*.comp setf glsl
augroup END
