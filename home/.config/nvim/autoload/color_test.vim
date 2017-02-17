function! color_test#color_test(outfile, fgend)
  let result = []
  for fg in range(a:fgend)
      let kw = printf('%-7s', printf('c_%d', fg))
      let h = printf('hi %s ctermfg=%d', kw, fg)
      let s = printf('syn keyword %s %s', kw, kw)
      call add(result, printf('%-32s | %s', h, s))
  endfor
  call writefile(result, a:outfile)
  execute 'edit '.a:outfile
  source %
endfunction
