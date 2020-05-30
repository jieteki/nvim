scriptencoding utf-8
set encoding=utf-8

set nocompatible              " be iMproved, required
filetype off                  " required
syntax on
let mapleader = "\<Space>"

call plug#begin('~/.nvim/plugged')

Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins'  }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Konfekt/FastFold'
Plug 'tmhedberg/SimpylFold'
Plug 'jiangmiao/auto-pairs'
Plug 'dyng/ctrlsf.vim'
Plug 'flazz/vim-colorschemes'
Plug 'majutsushi/tagbar'
Plug 'kannokanno/previm'
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'xolox/vim-misc'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'prettier/vim-prettier'
Plug 'elzr/vim-json'
Plug 'mattn/emmet-vim'
Plug 'schickling/vim-bufonly'
Plug 'rbgrouleff/bclose.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'derekwyatt/vim-scala'

Plug 'rust-lang/rust.vim'

Plug 'dense-analysis/ale'
Plug 'neovim/nvim-lsp'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'dart-lang/dart-vim-plugin'
Plug 'tpope/vim-abolish'
Plug 'mzlogin/vim-markdown-toc'
Plug 'godlygeek/tabular'              " required by vim-markdown
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-fugitive'
Plug 'easymotion/vim-easymotion'

call plug#end()


function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction



"""""""""""""""""""""""""""""""""""""""
""""""""
""""""""   Settings for Plugins
""""""""
"""""""""""""""""""""""""""""""""""""""

call defx#custom#option('_', {
      \ 'winwidth': 30,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 0,
      \ 'buffer_name': '',
      \ 'root_marker': ':'
      \ })
call defx#custom#column('filename', {
    \ 'root_marker_highlight': 'Ignore'
    \ })
autocmd FileType defx call s:defx_mappings()
function! s:defx_mappings() abort
  nnoremap <silent><buffer><expr> <Cr> <SID>defx_toggle_tree()                    " 打开或者关闭文件夹，文件
  nnoremap <silent><buffer><expr> o    <SID>defx_toggle_tree()                    " 打开或者关闭文件夹，文件
  nnoremap <silent><buffer><expr> ss    defx#do_action('multi', [['drop', 'split']])
  nnoremap <silent><buffer><expr> sv    defx#do_action('multi', [['drop', 'vsplit']])
  nnoremap <silent><buffer><expr> f     defx#do_action('toggle_ignored_files')     " 显示隐藏文件
  nnoremap <silent><buffer><expr> R     defx#do_action('redraw')
  nnoremap <silent><buffer><expr> U     defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> C     defx#do_action('cd', defx#get_candidate().action__path)
  nnoremap <silent><buffer><expr> mm    defx#do_action('rename')
  nnoremap <silent><buffer><expr> mc    defx#do_action('copy')
  nnoremap <silent><buffer><expr> mx    defx#do_action('move')
  nnoremap <silent><buffer><expr> mp    defx#do_action('paste')
  nnoremap <silent><buffer><expr> md    defx#do_action('remove')
  nnoremap <silent><buffer><expr> ma    defx#do_action('new_file')
  nnoremap <silent><buffer><expr> yy    defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> >     defx#do_action('resize', defx#get_context().winwidth + 10)
  nnoremap <silent><buffer><expr> <     defx#do_action('resize', defx#get_context().winwidth - 10)

endfunction
function! s:defx_toggle_tree() abort
    if defx#is_directory()
        return defx#do_action('open_or_close_tree')
    endif
    return defx#do_action('multi', ['drop'])
endfunction

function! Root(path) abort
    return fnamemodify(a:path, ':t') . '/'
endfunction
call defx#custom#source('file', {'root': 'Root'})

nmap <silent> <Leader>n :Defx -resume -toggle <CR>
nmap <silent> <Leader>m :Defx <CR>
nmap <silent> <Leader>M :Defx -resume -search=`expand('%:p')` `getcwd()` <CR>
autocmd FileType defx noremap <buffer> <c-left> <nop>
autocmd FileType defx noremap <buffer> <c-h> <nop>
autocmd FileType defx noremap <buffer> <c-right> <nop>
autocmd FileType defx noremap <buffer> <c-l> <nop>
autocmd FileType defx noremap <buffer> <Leader>L <nop>
autocmd FileType defx set cursorline
autocmd FileType defx hi CursorLine cterm=none ctermfg=10 ctermbg=234
autocmd VimEnter * call s:open_defx_if_directory()
function! s:open_defx_if_directory()
    if !exists('g:loaded_defx')
        echom 'Defx not installed, skipping...'
        return
    endif
    if isdirectory(expand(printf('#%s:p', expand('<abuf>'))))
        Defx
    endif
endfunction
" donot want netrw plugin
let loaded_netrwPlugin = 1


let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '

function! AirlineInit()
    let g:airline#extensions#default#layout = ['a', 'b', 'c', 'x', 'y', 'z']
endfunction
autocmd VimEnter * call AirlineInit()
let g:airline_section_x = ''
let g:airline_section_z = '%3p%% %3l/%L:%3v'
let g:airline_skip_empty_sections = 1


" let g:fzf_layout = { 'down': '~40%'  }
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

map <silent> <expr> <C-g> (expand('%') =~ 'defx' ? "\<c-w>\<c-w>" : '').":CFiles\<cr>"
map <silent> <expr> <C-p> (expand('%') =~ 'defx' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
map <silent> <expr> <C-j> (expand('%') =~ 'defx' ? "\<c-w>\<c-w>" : '').":Buffers\<cr>"
function! CleanFiles(query, fullscreen)
  let command_fmt = 'fd --type file --follow --hidden --exclude .git --exclude node_modules --exclude vendor %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let spec = {'options': ['--query', a:query ], 'sink': 'e' }
  call fzf#vim#grep(initial_command, 0, spec, a:fullscreen)
endfunction
command! -nargs=* -bang CFiles call CleanFiles(<q-args>, <bang>0)
nnoremap <leader>a :CtrlSF
nnoremap <leader>s :CtrlSFOpen <CR>
nnoremap <Leader>f yiw :CtrlSF "<C-R>""<CR>
vnoremap <Leader>a y<ESC> :CtrlSF "<C-R>""

let g:ctrlsf_auto_focus = { "at": "start" }
let g:ctrlsf_search_mode = 'async'


command! -nargs=? -complete=buffer -bang BL :call BufOnly('<args>', '<bang>')

noremap <silent> <Leader>o :TagbarToggle<CR>

" see https://github.com/majutsushi/tagbar/wiki#google-go
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

let g:tagbar_type_scala = {
    \ 'ctagstype' : 'scala',
    \ 'sro'       : '.',
    \ 'kinds'     : [
      \ 'p:packages',
      \ 'T:types:1',
      \ 't:traits',
      \ 'o:objects',
      \ 'O:case objects',
      \ 'c:classes',
      \ 'C:case classes',
      \ 'm:methods',
      \ 'V:values:1',
      \ 'v:variables:1'
    \ ]
\ }


let g:ale_linters = {'go': ['golangci-lint', 'govet']}
let g:ale_fixers = {'go': ['goimports', 'gofmt']}
let g:ale_fix_on_save = 1
let g:ale_go_gofmt_options=" -s -w "
let g:ale_go_golangci_lint_options = " "


let g:deoplete#enable_at_startup = 1


let g:previm_open_cmd = 'open -a Safari'
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END


nnoremap <silent> gd            <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD            <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <Leader>h     <cmd>lua vim.lsp.buf.hover()<CR>

function! LspMaybeHighlight() abort
  lua vim.lsp.util.buf_clear_references()
  lua vim.lsp.buf.document_highlight()
endfunction
augroup lsp_aucommands
  au!
  au CursorMoved * call LspMaybeHighlight()
augroup END

lua << EOF
  do
    local default_callback = vim.lsp.callbacks["textDocument/publishDiagnostics"]
    local err, method, params, client_id
    vim.lsp.callbacks["textDocument/publishDiagnostics"] = function(...)
      err, method, params, client_id = ...
      if vim.api.nvim_get_mode().mode ~= "i" and vim.api.nvim_get_mode().mode ~= "ic" then
        publish_diagnostics()
      end
    end
    function publish_diagnostics()
      default_callback(err, method, params, client_id)
    end
  end

  local on_attach = function(_, bufnr)
    vim.api.nvim_command [[autocmd InsertLeave <buffer> lua publish_diagnostics()]]
  end

  local nvim_lsp = require'nvim_lsp'

  nvim_lsp.rls.setup{{on_attach=on_attach}}
  nvim_lsp.gopls.setup({on_attach=on_attach})

EOF


let g:multi_cursor_exit_from_insert_mode=0
function! Multiple_cursors_before()
  let g:ale_enabled=0
endfunction
function! Multiple_cursors_after()
  let g:ale_enabled=1
endfunction

let g:go_fmt_autosave=0
let g:go_def_mapping_enabled=0
let g:go_doc_popup_window = 1


let g:user_emmet_leader_key='<C-C>'
let g:user_emmet_settings = {
\  'javascript.jsx' : {
\      'extends' : 'jsx',
\  },
\}


let g:vim_json_syntax_conceal = 0

let g:jsx_ext_required = 0

let g:prettier#config#tab_width = 4

let g:rust_fold = 1
let g:perl_fold = 1
let g:python_fold = 1
let g:erlang_fold = 1
let g:go_fold = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A']
let g:fastfold_savehook = 0

let g:vim_markdown_folding_disabled = 1

let g:indent_guides_guide_size = 1


map  f <Plug>(easymotion-bd-w)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)


"""""""""""""""""""""""""""""""""""""""
"""""""" Settings for Mappings """""""""
"""""""""""""""""""""""""""""""""""""""

nnoremap J mzJ`z
noremap H ^
noremap L $
vnoremap L g_


noremap <silent> <C-h> :bprev<CR>
noremap <silent> <C-l> :bnext<CR>

nnoremap <silent> <Leader>q :Bclose<CR>
nnoremap <silent> <Leader>x <C-w>c

map <Leader>L :set invnumber<CR>

map <Leader>T :%s/\s\+$//<CR>
map <Leader>U :g/^$/d<CR>
map <Leader>R :retab<CR>
map <Leader>; %
map <Leader>. :@:<CR>
nmap <silent> <Leader>ev :e $MYVIMRC<CR>
nmap <silent> <Leader>es :so $MYVIMRC<CR>
nnoremap <silent> <leader>b :nohlsearch<CR>
nnoremap <Leader>= :wincmd =<CR>

nmap S :%s//g<LEFT><LEFT>
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

map <Leader>w :w<CR>

nnoremap m <C-d>
nnoremap , <C-u>
nnoremap ; zz
nnoremap ' zt<C-y>

vnoremap // y/<C-R>"<CR>"

vnoremap p "_dp
vnoremap P "_dP


nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tn  :tabnext<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

set wildmenu wildmode=full
set wildchar=<Tab> wildcharm=<C-Z>
noremap <C-q> <C-y>



"""""""""""""""""""""""""""""""""""""""
"""""""""
"""""""" Settings for FileType
"""""""""
"""""""""""""""""""""""""""""""""""""""

autocmd FileType qf wincmd J

autocmd BufRead,BufNewFile *.json set filetype=json
autocmd BufNewFile,BufRead *.webapp set filetype=json
autocmd BufNewFile,BufRead *.jshintrc set filetype=json
autocmd BufNewFile,BufRead *.eslintrc set filetype=json
autocmd BufNewFile,BufReadPost *.go set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.coffee set shiftwidth=2 softtabstop=2 expandtab
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufWritePost *.coffee silent make!
autocmd QuickFixCmdPost * nested cwindow | redraw!
autocmd BufNewFile,BufReadPost *.js set shiftwidth=4 softtabstop=4 expandtab
autocmd BufNewFile,BufRead *.js set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.ejs set filetype=html
autocmd FileType scss set iskeyword+=-
autocmd BufNewFile,BufReadPost *.scss set shiftwidth=4 softtabstop=4 expandtab
autocmd BufNewFile,BufReadPost *.sh set shiftwidth=4 softtabstop=4 expandtab
autocmd BufNewFile,BufReadPost *.sls set shiftwidth=4 softtabstop=4 expandtab


nmap <silent>=j :%!python -m json.tool<CR>:setfiletype json<CR>


"""""""""""""""""""""""""""""""""""""""
"""""""""
"""""""" Settings for normal vi
"""""""""
"""""""""""""""""""""""""""""""""""""""

set splitbelow
set splitright

set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:×
set list

set number
set nomodeline
set viminfo='1000,f1,:1000,/1000
set history=1000
set foldmethod=syntax
set tabstop=4
set shiftwidth=4
set hidden
filetype indent on
filetype plugin on
set autoindent
set mouse=
set clipboard^=unnamed,unnamedplus
cmap w!! %!sudo tee > /dev/null %
set backspace=indent,eol,start
let pair_program_mode = 0

noremap K <nop>
nnoremap Q <nop>
map q: :q

set maxmempattern=20000
set timeoutlen=1000 ttimeoutlen=0

syntax on
set number
set nowrap
set vb
set ruler

set incsearch
set ignorecase
set smartcase
set hlsearch
set nostartofline


"""""""""""""""""""""""""""""""""""""""
"""""""""
"""""""" Settings for Custom Funcs
"""""""""
"""""""""""""""""""""""""""""""""""""""


function! ToggleMouse()
    if &mouse == 'a'
        set mouse=
    else
        set mouse=a
    endif
endfunc
nnoremap <F4> :call ToggleMouse() <Enter>

nnoremap <F8> *

set pastetoggle=<F2>

function! ToggleFold()
    let &foldlevel = 100 - &foldlevel
    :normal zz
endfunc
nnoremap zm :call ToggleFold() <Enter>
nnoremap zo zA

function! s:CopyToTmux()
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  let tempfile = tempname()
  call writefile(lines, tempfile, "b")
  call system('tmux load-buffer '.tempfile)
  call delete(tempfile)
endfunction
vnoremap <silent> Y :call <sid>CopyToTmux()<cr>


" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction
" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction
" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif


colorscheme leo
hi Search               cterm=none      ctermfg=232     ctermbg=214     guifg=#000000   guibg=#a8a8a8
hi SpellCap             ctermfg=black   ctermbg=green   guifg=black     guibg=green
hi LspReferenceText     ctermfg=black   ctermbg=green   guifg=black     guibg=green

" hi Pmenu                ctermfg=238 ctermbg=252 guifg=#4d4d4c guibg=#d6d6d6
" hi PmenuSel             cterm=reverse ctermfg=238 ctermbg=252 gui=reverse guifg=#4d4d4c guibg=#d6d6d6
" hi PmenuSbar            ctermbg=248 guibg=Grey
" hi PmenuThumb           ctermbg=0 guibg=Black

" hi Pmenu                ctermfg=0       ctermbg=6
" hi PmenuSel             ctermfg=NONE    ctermbg=24      cterm=NONE
hi Whitespace           ctermfg=DarkGray
hi LspDiagnosticsError  ctermfg=cyan
hi SignColumn           ctermfg=white ctermbg=black


"------  Local Overrides  ------
if filereadable($HOME.'/.vimrc_local')
    source $HOME/.vimrc_local
endif


filetype plugin indent on

