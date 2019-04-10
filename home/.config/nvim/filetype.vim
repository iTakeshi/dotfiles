if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect
  autocmd!
  au BufNewFile,BufRead *.m setf matlab " MATLAB
augroup END
