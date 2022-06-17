" Use Vim settings, rather than Vi settings.
" This must be first, because it changes other options as a side effect.
set nocompatible

set encoding=utf-8

filetype plugin indent on

set number
set numberwidth=5

syntax on

" Press F4 to toggle highlighting on/off.
noremap <F4> :set hls!<CR>

" Press F5 to toggle "paste", so that we can paste without autoindent messing
" up the pasted text.
set pastetoggle=<F5>

" Press F6 to remove trailing white space
nnoremap <silent> <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" The command :dig displays digraphs you can use.
" Enter the Pilcrow mark by pressing Ctrl-k then PI
" Enter the right-angle-quote by pressing Ctrl-k then >>
" Enter the middle-dot by pressing Ctrl-k then .M
"   Example text with tabs:		, and trailing space.  
set list listchars=tab:»·,trail:·

" Have multiple buffers without saving all the time.
set hidden

" Set the window title
set title

" For search
set ignorecase smartcase

set shell=/bin/bash

set background=dark
colorscheme PaperColor
"colorscheme base16-default-dark

" Close the Omni-Completion tip window when a selection is made.
" Close it on movement in insert mode.
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
" Close it when leaving insert mode. Just using this and not the above, I can
" see documentation while typing arguments.
autocmd InsertLeave * if pumvisible() == 0 && bufname("%") != "[Command Line]"|pclose|endif

autocmd FileType sh setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2

" Settings for NERDTree.
map <F12> :NERDTreeToggle <CR>
let NERDTreeWinSize=48
let NERDTreeIgnore=['\.egg-info$', '^__pycache__$', '\.pyc$', '\~$']

" Settings for Buffer Explorer.
let g:bufExplorerShowRelativePath=1

" Settings for vim-airline
let g:airline_powerline_fonts = 1
let g:airline_theme = 'papercolor'

packloadall

" More settings for vim-airline
let g:airline_section_z = airline#section#create(['windowswap', 'obsession','%3p%% %04l:%03v'])

function! NERDTreeAirline()
  let nt = getbufvar(t:NERDTreeBufName, 'NERDTree')
  let rv = nt.root.path.str()
  return rv
endfunction

function! NERDTree_airline(...)
  " First argument is the statusline builder.
  "   WARNING: the API for the builder is not finalized and may change
  let builder = a:1
  " Second argument is the context.
  let context = a:2
  if exists('t:NERDTreeBufName')
    if bufwinnr(t:NERDTreeBufName) == context.winnr
      call builder.add_section('airline_c', '%{NERDTreeAirline()}')
      call builder.split()
      call builder.add_section('airline_z', ' %p%% ')
      " Tell the core to use the contents of the builder.
      return 1
    endif
  endif
endfunction

call airline#add_statusline_func('NERDTree_airline')
call airline#add_inactive_statusline_func('NERDTree_airline')

" Settings for syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_python_checkers = ['flake8', 'bandit']

" Settings for YouCompleteMe
" Show documentation in a popup at the cursor location, e.g. for pydoc
nmap <leader>D <plug>(YCMHover)
" Ask if it is safe to load .ycm_extra_conf.py files (to prevent execution of malicious code from files I didn't write.)
" To selectively ask/not ask about loading certain .ycm_extra_conf.py files, see the g:ycm_extra_conf_globlist option.
" Default: 1, which is 'do ask'
let g:ycm_confirm_extra_conf = 1

" Use templates for new files
function! LoadTemplate()
  " Try the whole file name first, e.g. build.xml
  let l:tpl_fn = '~/.vim/templates/' . expand("%") . '.tpl'

  " Try the last two components of the file name, including its extension,
  "   e.g. project-a.build.xml
  let l:tpl_e_e = '~/.vim/templates/' . expand("%:e:e") . '.tpl'

  " Try the file extension, e.g. generic-document.xml
  let l:tpl_e = '~/.vim/templates/' . expand("%:e") . '.tpl'

  if filereadable(expand(l:tpl_fn))
    silent! :execute '0r ' . l:tpl_fn
  elseif filereadable(expand(l:tpl_e_e))
    silent! :execute '0r ' . l:tpl_e_e
  elseif filereadable(expand(l:tpl_e))
    silent! :execute '0r ' . l:tpl_e
  endif
endfunction

autocmd BufNewFile * silent! call LoadTemplate()

" What do these do?
nnoremap <c-j> /<+.\{-1,}+><cr>c/+>/e<cr>
inoremap <c-j> <ESC>/<+.\{-1,}+><cr>c/+>/e<cr>
