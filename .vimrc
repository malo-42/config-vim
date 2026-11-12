set nocompatible
filetype plugin indent on
syntax enable
set encoding=utf-8
set fileencoding=utf-8
set number
set cursorline
set wrap linebreak
set scrolloff=8
set sidescrolloff=8
set mouse=a
set splitright splitbelow
set signcolumn=yes
set wildmenu
set wildmode=longest:full,full
if has('clipboard')
  set clipboard=unnamedplus
endif
set tabstop=4 shiftwidth=4 softtabstop=4
set expandtab
set autoindent smartindent

augroup norminette_c
  autocmd!
  autocmd FileType c setlocal noexpandtab tabstop=4 shiftwidth=4 cindent
  autocmd FileType c setlocal cinoptions=:0,l1,g0,t0,(0,W4
augroup END
set ignorecase smartcase
set incsearch hlsearch
set nobackup nowritebackup
set noswapfile
if has('persistent_undo')
  set undofile
  set undodir=~/.vim/undodir
  if !isdirectory($HOME.'/.vim/undodir')
    call mkdir($HOME.'/.vim/undodir', 'p')
  endif
endif
if has('termguicolors')
  set termguicolors
endif
set showmatch
set showmode
set laststatus=2
set showcmd
set background=dark
silent! colorscheme torte
highlight Normal ctermbg=black guibg=black
highlight NonText ctermbg=black guibg=black

augroup CustomCSyntax
  autocmd!
  autocmd FileType c syntax match cCustomFunc "\<\([a-zA-Z_][a-zA-Z0-9_]*\)\>\ze\s*("
  autocmd FileType c highlight cCustomFunc guifg=#87d7ff ctermfg=117
augroup END

set statusline=
set statusline+=\ [%{mode()}]
set statusline+=\ %f
set statusline+=\ %m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}]
set statusline+=\ %l:%c
set statusline+=\ %p%%
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>h :nohlsearch<CR>
nnoremap <leader>i mzgg=G`zzz
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>e :Explore<CR>
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
set path+=**
set wildignore+=*/node_modules/*,*/.git/*,*/venv/*,*.o,*.pyc
nnoremap <leader>f :find<Space>
if exists('+findfunc')
  let s:project_files = []
  function! s:ListProjectFiles() abort
    if executable('rg')
      return systemlist('rg --files --hidden --glob "!.git"')
    endif
    return filter(glob('**', 0, 1), '!isdirectory(v:val)')
  endfunction
  function! s:FuzzyFind(cmdarg, cmdcomplete) abort
    if empty(s:project_files)
      let s:project_files = s:ListProjectFiles()
    endif
    if empty(a:cmdarg)
      return s:project_files
    endif
    return matchfuzzy(s:project_files, a:cmdarg)
  endfunction
  let s:find_wildmode = exists('*wildtrigger') ? 'noselect:full' : 'full'
  function! s:OnFindCmdline() abort
    if getcmdline() !~# '^\s*fin\%[d]\s'
      return
    endif
    let &wildmode = s:find_wildmode
    if exists('*wildtrigger')
      call wildtrigger()
    endif
  endfunction
  set findfunc=s:FuzzyFind
  set wildoptions+=pum
  augroup fuzzy_find
    autocmd!
    autocmd CmdlineEnter : let s:project_files = [] | let s:saved_wildmode = &wildmode
    autocmd CmdlineChanged : call s:OnFindCmdline()
    autocmd CmdlineLeave : let &wildmode = s:saved_wildmode
  augroup END
endif
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif
nnoremap <leader>g :grep<Space>
augroup remember_position
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END
