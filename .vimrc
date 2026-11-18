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

" Barre d'onglets : onglet actif bien visible
highlight TabLine     ctermfg=250 ctermbg=236 guifg=#bcbcbc guibg=#303030 cterm=NONE gui=NONE
highlight TabLineSel  ctermfg=16  ctermbg=117 guifg=#000000 guibg=#87d7ff cterm=bold gui=bold
highlight TabLineFill ctermbg=235 guibg=#262626 cterm=NONE gui=NONE

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
nnoremap <silent> <leader>h :nohlsearch<CR>

" Réindente tout le fichier et remet le curseur exactement où il était
function! s:Reindent() abort
  let view = winsaveview()
  keepjumps normal! gg=G
  call winrestview(view)
endfunction
nnoremap <silent> <leader>i :call <SID>Reindent()<CR>

" ---------------------------------------------------------------
" Buffers (les "onglets")
" ---------------------------------------------------------------
set hidden
set showtabline=2

function! s:BufferLabel(buf, tails) abort
  if empty(a:buf.name)
    return '[No Name]'
  endif
  let tail = fnamemodify(a:buf.name, ':t')
  if count(a:tails, tail) > 1
    return fnamemodify(a:buf.name, ':~:.')
  endif
  return tail
endfunction

function! s:VisibleRange(widths, current) abort
  let first = a:current
  let last = a:current
  let used = a:widths[a:current]
  let grew = 1
  while grew
    let grew = 0
    if last + 1 < len(a:widths) && used + a:widths[last + 1] <= &columns
      let last += 1
      let used += a:widths[last]
      let grew = 1
    endif
    if first > 0 && used + a:widths[first - 1] <= &columns
      let first -= 1
      let used += a:widths[first]
      let grew = 1
    endif
  endwhile
  return [first, last]
endfunction

function! BufferTabline() abort
  let buffers = getbufinfo({'buflisted': 1})
  if empty(buffers)
    return ''
  endif
  let tails = map(copy(buffers), 'fnamemodify(v:val.name, ":t")')
  let labels = []
  for i in range(len(buffers))
    call add(labels, ' ' . (i + 1) . ':' . s:BufferLabel(buffers[i], tails)
          \ . (buffers[i].changed ? ' +' : '') . ' ')
  endfor
  let current = max([0, index(map(copy(buffers), 'v:val.bufnr'), bufnr('%'))])
  let [first, last] = s:VisibleRange(map(copy(labels), 'strwidth(v:val)'), current)
  let line = ''
  for i in range(first, last)
    let line .= buffers[i].bufnr == bufnr('%') ? '%#TabLineSel#' : '%#TabLine#'
    let line .= substitute(labels[i], '%', '%%', 'g')
  endfor
  return line . '%#TabLineFill#'
endfunction
set tabline=%!BufferTabline()

" Gauche / droite
nnoremap <silent> L :bnext<CR>
nnoremap <silent> H :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [b :bprevious<CR>

" Saut direct par numéro : Espace + 1..9
function! GoToBuffer(n) abort
  let buffers = getbufinfo({'buflisted': 1})
  if a:n <= len(buffers)
    execute 'buffer' buffers[a:n - 1].bufnr
  endif
endfunction
for i in range(1, 9)
  execute 'nnoremap <silent> <leader>' . i . ' :call GoToBuffer(' . i . ')<CR>'
endfor

" Dernier buffer utilisé
nnoremap <silent> <leader><leader> :silent! buffer #<CR>

" Choisir un buffer par son nom
nnoremap <leader>b :buffer<Space>

" Ferme le buffer actuel sans casser la disposition des fenêtres
function! s:CloseBuffer() abort
  let cur = bufnr('%')
  if &modified
    echohl ErrorMsg
    echo 'Buffer modifié : sauvegarde (Espace+w) ou :bd!'
    echohl None
    return
  endif
  if !buflisted(cur)
    bdelete
    return
  endif
  if len(getbufinfo({'buflisted': 1})) > 1
    let alt = bufnr('#')
    if alt > 0 && alt != cur && buflisted(alt)
      buffer #
    else
      bprevious
    endif
  else
    enew
  endif
  if buflisted(cur)
    execute 'bdelete' cur
  endif
endfunction
nnoremap <silent> <leader>x :call <SID>CloseBuffer()<CR>

" Ferme tous les buffers sauf l'actuel (garde ceux non sauvegardés)
function! s:CloseOtherBuffers() abort
  let cur = bufnr('%')
  let skipped = 0
  for info in getbufinfo({'buflisted': 1})
    if info.bufnr == cur
      continue
    endif
    if info.changed
      let skipped += 1
    else
      execute 'bdelete' info.bufnr
    endif
  endfor
  if skipped
    echohl WarningMsg
    echo skipped . ' buffer(s) modifié(s) conservé(s)'
    echohl None
  endif
endfunction
nnoremap <silent> <leader>X :call <SID>CloseOtherBuffers()<CR>

" ---------------------------------------------------------------
" Fenêtres
" ---------------------------------------------------------------
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Netrw redéfinit Ctrl+h et Ctrl+l : on remet la navigation entre fenêtres
function! s:NetrwMaps() abort
  nnoremap <buffer> <silent> <C-h> <C-w>h
  nnoremap <buffer> <silent> <C-l> <C-w>l
endfunction
augroup netrw_maps
  autocmd!
  autocmd FileType netrw call s:NetrwMaps()
augroup END

" Explorateur de fichiers à gauche (Espace + e ouvre / ferme)
nnoremap <silent> <leader>e :Lexplore<CR>
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 4

" Visuel : déplacer les lignes
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Défilement centré
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" ---------------------------------------------------------------
" Recherche de fichiers (:find flou) et de texte (:grep)
" ---------------------------------------------------------------
set path+=**
set wildignore+=*/node_modules/*,*/.git/*,*/venv/*,*.o,*.pyc
nnoremap <leader>f :find<Space>
if exists('+findfunc')
  let s:project_files = []
  let s:find_max_depth = 4
  function! s:ListProjectFiles() abort
    if executable('rg')
      let cmd = 'rg --files --hidden --max-depth ' . s:find_max_depth
      for pat in ['!.git', '!node_modules', '!venv', '!*.o', '!*.pyc']
        let cmd .= ' --glob ' . shellescape(pat)
      endfor
      let found = systemlist(cmd)
      if v:shell_error == 0
        return found
      endif
    endif
    let files = []
    for depth in range(1, s:find_max_depth)
      call extend(files, glob(repeat('*/', depth - 1) . '*', 0, 1))
    endfor
    return filter(files, '!isdirectory(v:val)')
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
nnoremap <leader>g :silent grep<Space>
" Ouvre automatiquement la liste de résultats après :grep
augroup quickfix_auto
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow | redraw!
  autocmd QuickFixCmdPost l* lwindow | redraw!
augroup END

augroup remember_position
  autocmd!
  autocmd BufReadPost *
    \ if &filetype !~# 'gitcommit' && line("'\"") > 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif
augroup END
