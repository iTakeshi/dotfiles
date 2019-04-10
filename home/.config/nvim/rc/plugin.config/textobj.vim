if g:dein#tap('vim-textobj-comment')
  let g:textobj_comment_no_default_key_mappings = 1
  xmap ac <Plug>(textobj-comment-a)
  xmap ic <Plug>(textobj-comment-i)
  omap ac <Plug>(textobj-comment-a)
  omap ic <Plug>(textobj-comment-i)
endif

if g:dein#tap('vim-textobj-datetime')
  let g:textobj_datetime_no_default_key_mappings = 1
  xmap ada <Plug>(textobj-datetime-auto)
  xmap ida <Plug>(textobj-datetime-auto)
  xmap add <Plug>(textobj-datetime-date)
  xmap idd <Plug>(textobj-datetime-date)
  xmap adf <Plug>(textobj-datetime-full)
  xmap idf <Plug>(textobj-datetime-full)
  xmap adt <Plug>(textobj-datetime-time)
  xmap idt <Plug>(textobj-datetime-time)
  xmap adz <Plug>(textobj-datetime-tz)
  xmap idz <Plug>(textobj-datetime-tz)
  omap ada <Plug>(textobj-datetime-auto)
  omap ida <Plug>(textobj-datetime-auto)
  omap add <Plug>(textobj-datetime-date)
  omap idd <Plug>(textobj-datetime-date)
  omap adf <Plug>(textobj-datetime-full)
  omap idf <Plug>(textobj-datetime-full)
  omap adt <Plug>(textobj-datetime-time)
  omap idt <Plug>(textobj-datetime-time)
  omap adz <Plug>(textobj-datetime-tz)
  omap idz <Plug>(textobj-datetime-tz)
endif

if g:dein#tap('vim-textobj-entire')
  let g:textobj_entire_no_default_key_mappings = 1
  xmap ae <Plug>(textobj-entire-a)
  xmap ie <Plug>(textobj-entire-i)
  omap ae <Plug>(textobj-entire-a)
  omap ie <Plug>(textobj-entire-i)
endif

if g:dein#tap('vim-textobj-between')
  let g:textobj_between_no_default_key_mappings = 1
  xmap af <Plug>(textobj-between-a)
  xmap if <Plug>(textobj-between-i)
  omap af <Plug>(textobj-between-a)
  omap if <Plug>(textobj-between-i)
endif

if g:dein#tap('vim-textobj-indent')
  let g:textobj_indent_no_default_key_mappings = 1
  xmap ai <Plug>(textobj-indent-a)
  xmap ii <Plug>(textobj-indent-i)
  xmap aI <Plug>(textobj-indent-same-a)
  xmap iI <Plug>(textobj-indent-same-i)
  omap ai <Plug>(textobj-indent-a)
  omap ii <Plug>(textobj-indent-i)
  omap aI <Plug>(textobj-indent-same-a)
  omap iI <Plug>(textobj-indent-same-i)
endif

if g:dein#tap('vim-textobj-line')
  let g:textobj_line_no_default_key_mappings = 1
  xmap al <Plug>(textobj-line-a)
  xmap il <Plug>(textobj-line-i)
  omap al <Plug>(textobj-line-a)
  omap il <Plug>(textobj-line-i)
endif

if g:dein#tap('vim-textobj-space')
  let g:textobj_space_no_default_key_mappings = 1
  xmap aS <Plug>(textobj-space-a)
  xmap iS <Plug>(textobj-space-i)
  omap aS <Plug>(textobj-space-a)
  omap iS <Plug>(textobj-space-i)
endif

if g:dein#tap('vim-textobj-url')
  let g:textobj_url_no_default_key_mappings = 1
  xmap au <Plug>(textobj-url-a)
  xmap iu <Plug>(textobj-url-i)
  omap au <Plug>(textobj-url-a)
  omap iu <Plug>(textobj-url-i)
endif

if g:dein#tap('vim-textobj-variable-segment')
  let g:textobj_variable_no_default_key_mappings = 1
  xmap av <Plug>(textobj-variable-a)
  xmap iv <Plug>(textobj-variable-i)
  omap av <Plug>(textobj-variable-a)
  omap iv <Plug>(textobj-variable-i)
endif

if g:dein#tap('vim-textobj-syntax')
  let g:textobj_syntax_no_default_key_mappings = 1
  xmap ay <Plug>(textobj-syntax-a)
  xmap iy <Plug>(textobj-syntax-i)
  omap ay <Plug>(textobj-syntax-a)
  omap iy <Plug>(textobj-syntax-i)
endif

if g:dein#tap('vim-textobj-fold')
  let g:textobj_fold_no_default_key_mappings = 1
  xmap az <Plug>(textobj-fold-a)
  xmap iz <Plug>(textobj-fold-i)
  omap az <Plug>(textobj-fold-a)
  omap iz <Plug>(textobj-fold-i)
endif

if g:dein#tap('vim-textobj-parameter')
  let g:textobj_parameter_no_default_key_mappings = 1
  xmap a, <Plug>(textobj-parameter-a)
  xmap i, <Plug>(textobj-parameter-i)
  omap a, <Plug>(textobj-parameter-a)
  omap i, <Plug>(textobj-parameter-i)
endif
