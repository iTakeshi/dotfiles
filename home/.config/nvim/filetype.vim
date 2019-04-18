if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect
  autocmd!
  au BufNewFile,BufRead *.m        setf matlab     " MATLAB
  au BufNewFile,BufRead *.ts,*.tsx setf typescript " typescript (override polyglot)
augroup END
