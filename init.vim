scriptencoding utf-8
set encoding=utf-8

set nocompatible              " be iMproved, required
filetype off                  " required
syntax on
let mapleader = "\<Space>"

call plug#begin('~/.nvim/plugged')

Plug 'kyazdani42/nvim-tree.lua'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'junegunn/fzf.vim'
Plug 'Konfekt/FastFold'
Plug 'tmhedberg/SimpylFold'
Plug 'jiangmiao/auto-pairs'
Plug 'dyng/ctrlsf.vim'
Plug 'liuchengxu/vista.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'schickling/vim-bufonly'
Plug 'rbgrouleff/bclose.vim'
Plug 'Yggdroot/indentLine'

Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
Plug 'elzr/vim-json'

Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'

Plug 'godlygeek/tabular'              " required by vim-markdown
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'kannokanno/previm'

Plug 'lifepillar/vim-mucomplete'

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

nnoremap <silent> <expr> <C-g>     (expand('%') =~ 'NvimTree' ? "\<c-w>\<c-w>" : '').":Files<cr>"
nnoremap <silent> <expr> <Leader>l (expand('%') =~ 'NvimTree' ? "\<c-w>\<c-w>" : '').":Buffers<CR>"
nnoremap <silent> <expr> <Leader>t (expand('%') =~ 'NvimTree' ? "\<c-w>\<c-w>" : '').":BTags<CR>"
nnoremap <silent> <expr> <Leader>m (expand('%') =~ 'NvimTree' ? "\<c-w>\<c-w>" : '').":Rg<CR>"
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
let $FZF_DEFAULT_OPTS=" --preview 'bat --color=always --style=header,grid --line-range :300 {}'"




let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_gitignore = 1
let g:nvim_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_follow = 0 "0 by default, this option allows the cursor to be updated when entering a buffer
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
let g:nvim_tree_width_allow_resize = v:true
let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 0,
    \}
let g:nvim_tree_icons = {
    \ 'default': '  ',
    \ 'symlink': '  ',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': " ",
    \   'renamed': "➜",
    \   'untracked': "★"
    \   },
    \ 'folder': {
    \   'default': "+",
    \   'open': "-"
    \  }
    \ }
nnoremap <Leader>n :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap @ :NvimTreeFindFile<CR>
lua <<EOF
    local tree_cb = require'nvim-tree.config'.nvim_tree_callback
    vim.g.nvim_tree_bindings = {
      ["sv"]             = tree_cb("vsplit"),
      ["ss"]             = tree_cb("split"),
      [">"]              = ':exe "vertical resize +10"<CR>',  -- default was next_sibling
      ["<"]              = ':exe "vertical resize -10"<CR>',  -- default was prev_sibling
      ["H"]              = '^',                               -- default was toggle_dotfiles
      ["[p"]             = tree_cb("prev_sibling"),
      ["]n"]             = tree_cb("next_sibling"),
      ["f"]              = tree_cb("toggle_dotfiles"),
      -- default mappings
      ["<CR>"]           = tree_cb("edit"),
      ["o"]              = tree_cb("edit"),
      ["<C-]>"]          = tree_cb("cd"),
      ["<C-t>"]          = tree_cb("tabnew"),
      ["<BS>"]           = tree_cb("close_node"),
      ["<S-CR>"]         = tree_cb("close_node"),
      ["<Tab>"]          = "",
      ["I"]              = tree_cb("toggle_ignored"),
      ["R"]              = tree_cb("refresh"),
      ["a"]              = tree_cb("create"),
      ["d"]              = tree_cb("remove"),
      ["r"]              = tree_cb("rename"),
      ["<C-r>"]          = tree_cb("full_rename"),
      ["x"]              = tree_cb("cut"),
      ["c"]              = tree_cb("copy"),
      ["p"]              = tree_cb("paste"),
      ["[c"]             = tree_cb("prev_git_item"),
      ["]c"]             = tree_cb("next_git_item"),
      ["-"]              = tree_cb("dir_up"),
      ["q"]              = tree_cb("close"),
    }
EOF




let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '



nnoremap <leader>a :CtrlSF
nnoremap <leader>s :CtrlSFOpen <CR>
nnoremap <Leader>f yiw :CtrlSF "<C-R>""<CR>
vnoremap <Leader>a y<ESC> :CtrlSF "<C-R>""
let g:ctrlsf_auto_focus = { "at": "start" }
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_extra_backend_args = {'rg': '--no-ignore'}





command! -nargs=? -complete=buffer -bang BL :call BufOnly('<args>', '<bang>')





let g:previm_open_cmd = 'open -a Safari'
augroup PrevimSettings
    autocmd!
    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END



nnoremap <Leader>o :Vista!! <CR>





""" see https://github.com/neovim/nvim-lspconfig#Keybindings-and-completion
lua << EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "gopls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF




set completeopt+=noselect
set completeopt-=preview
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#completion_delay = 1





"    let g:my_coc_file_types = ['go', 'c', 'cpp', 'h', 'asm', 'hpp', 'vim', 'sh', 'py']
"    function! s:disable_coc_for_type()
"        if index(g:my_coc_file_types, &filetype) == -1
"            let b:coc_enabled = 0
"        else
"            let b:coc_enabled = 1
"        endif
"    endfunction
"    function! s:lsp_maybe_highlight() abort
"      call CocActionAsync('highlight')
"    endfunction
"    augroup CocGroup
"        autocmd!
"        autocmd BufNew,BufEnter *    call s:disable_coc_for_type()
"        autocmd CursorMoved * silent call s:lsp_maybe_highlight()
"    augroup end

"    " Use <c-space> to trigger completion.
"    inoremap <silent><expr> <c-space> coc#refresh()
"    inoremap <silent><expr> <TAB> (pumvisible() ? "\<C-n>" : (<SID>check_back_space() ? "\<TAB>" : coc#refresh()))
"    inoremap <expr><S-TAB> (pumvisible() ? "\<C-p>" : "\<C-h>")
"    function! s:check_back_space() abort
"        let col = col('.') - 1
"        return !col || getline('.')[col - 1] =~# '\s'
"    endfunction
"    nnoremap [g <Plug>(coc-diagnostic-prev)
"    nnoremap ]g <Plug>(coc-diagnostic-next)
"    nnoremap gd <Plug>(coc-definition)
"    nnoremap gy <Plug>(coc-type-definition)
"    nnoremap gi <Plug>(coc-implementation)
"    nnoremap gr <Plug>(coc-references)
"    nnoremap K :call <SID>call CocAction('doHover')<CR>
"    nnoremap <leader>rn  <Plug>(coc-rename)
"    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}






let g:go_imports_autosave = 1
let g:go_fmt_autosave=1
let g:go_def_mapping_enabled=0
let g:go_doc_popup_window = 1
let g:go_gopls_enabled = 0
let g:go_code_completion_enabled = 0
let g:go_diagnostics_enabled = 0
let g:go_echo_command_info = 0
let g:go_echo_go_info=0





nnoremap <Leader>p <Plug>(Prettier):retab <CR>



let g:is_doing_easymotion = 0
function! DoingEasyMotion()
  let g:is_doing_easymotion = 1
  let cancelled = EasyMotion#WB(0,2)
  let g:is_doing_easymotion = 0
endfunction
nnoremap f :call DoingEasyMotion()<CR>
autocmd User EasyMotionPromptBegin silent! CocDisable
autocmd User EasyMotionPromptEnd silent! CocEnable





"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=1
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable(".cscope.out")
        cs add .cscope.out
    endif
    set csverb
endif
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
if filereadable(".tags")
    set tags=.tags
else
    set tags=tags
endif



autocmd FileType vista,NvimTree noremap <buffer> <c-j> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <c-i> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <c-o> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <c-h> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <c-l> <nop>
autocmd FileType vista,NvimTree noremap <buffer> <Leader>L <nop>
autocmd FileType vista,NvimTree noremap <buffer> <Leader>q <nop>
autocmd FileType vista,NvimTree noremap <buffer> <Leader>x <nop>
autocmd FileType vista,NvimTree noremap <buffer> <Leader>w <nop>



"""""""""""""""""""""""""""""""""""""""
"""""""" Settings for Mappings """""""""
"""""""""""""""""""""""""""""""""""""""

nnoremap J mzJ`z
noremap H ^
noremap L $
vnoremap L g_

nnoremap <C-m> %
vnoremap <C-m> %

nnoremap <C-h>      :bprev<CR>
nnoremap <C-l>      :bnext<CR>
nnoremap <Leader>q  :Bclose<CR>
nnoremap <Leader>x  <C-w>c

nnoremap <Leader>L  :set invnumber<CR>
nnoremap <Leader>T  :%s/\s\+$//<CR>
nnoremap <Leader>U  :g/^$/d<CR>
nnoremap <Leader>R  :retab<CR>
nnoremap <Leader>.  :@:<CR>
nnoremap <Leader>ev :e $MYVIMRC<CR>
nnoremap <Leader>es :so $MYVIMRC<CR>
nnoremap <leader>b  :nohlsearch<CR>
nnoremap <Leader>=  :wincmd =<CR>
nnoremap <Leader>c  :let @+=expand('%:p')<CR>


" map C-j in all modes to save buffer
noremap  <C-j>      :w<CR>
noremap! <C-j> <ESC>:w<CR>
noremap  <Leader>w  :w<CR>

vnoremap <C-r> "hy:%sno#<C-r>h##gc<left><left><left>
nnoremap S     :%sno##g<LEFT><LEFT>
inoremap <C-y> <C-r>"

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

command! Jsonf :execute '%!python2 -m json.tool'
  \ | :execute '%!python2 -c "import re,sys;sys.stdout.write(re.sub(r\"\\\u[0-9a-f]{4}\", lambda m:m.group().decode(\"unicode_escape\").encode(\"utf-8\"), sys.stdin.read()))"'



inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-k> <C-o>D
inoremap <C-t> <C-o>O



nnoremap <silent> >  :exe "vertical resize +10"<CR>
nnoremap <silent> <  :exe "vertical resize -10"<CR>



function! MyHighlights() abort
    " for term
    hi Search                       cterm=none              ctermfg=232         ctermbg=214
    hi SpellCap                                             ctermfg=black       ctermbg=green
    hi LspReferenceText                                     ctermfg=black       ctermbg=green
    hi CocHighlightText                                     ctermfg=black       ctermbg=green
    hi LspDiagnosticsError                                  ctermfg=cyan
    hi SignColumn                                           ctermfg=white       ctermbg=black
    hi Whitespace                                           ctermfg=DarkGray
    hi ALEError                     cterm=underline,bold    ctermfg=red
    hi ALEWarning                   cterm=underline,bold    ctermfg=red
    hi VertSplit                                            ctermfg=green       ctermbg=black
    hi multiple_cursors_cursor                              ctermfg=green       ctermbg=red
    hi multiple_cursors_visual                              ctermfg=black       ctermbg=white
    hi LineNr                                                                   ctermbg=NONE
    hi Normal                                               ctermbg=234

    hi CursorLine                                           cterm=none          ctermbg=234


    " for gui
    hi Search                       gui=NONE                guifg=black         guibg=goldenrod2
    hi SpellCap                                             guifg=black         guibg=springgreen
    hi LspReferenceText                                     guifg=black         guibg=limegreen
    hi CocHighlightText                                     guifg=black         guibg=limegreen
    hi LspDiagnosticsError                                  guifg=cyan
    hi SignColumn                                           guifg=white
    hi Whitespace                                           guifg=DarkSlateGray
    hi ALEError                     gui=underline,bold      guifg=red
    hi ALEWarning                   gui=underline,bold      guifg=red
    hi VertSplit                                            guifg=springgreen   guibg=NONE
    hi multiple_cursors_cursor                              guifg=springgreen   guibg=red
    hi multiple_cursors_visual                              guifg=black         guibg=white
    hi LineNr                                                                   guibg=NONE
    hi Normal                                                                   guibg=#1c1c1c

    hi CursorLine                                                               guibg=black

endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

if has("termguicolors")
    set termguicolors
endif
colorscheme space-vim-dark



"""""""""""""""""""""""""""""""""""""""
"""""""""
"""""""" Settings for FileType
"""""""""
"""""""""""""""""""""""""""""""""""""""

autocmd FileType qf wincmd J

" default is expand tab
set expandtab
autocmd BufRead,BufNewFile *.json set filetype=json
autocmd BufNewFile,BufRead *.webapp set filetype=json
autocmd BufNewFile,BufRead *.jshintrc set filetype=json
autocmd BufNewFile,BufRead *.eslintrc set filetype=json
autocmd BufNewFile,BufReadPost *.go set shiftwidth=4 softtabstop=4 expandtab!
autocmd BufNewFile,BufReadPost *.coffee set shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufWritePost *.coffee silent make!
autocmd QuickFixCmdPost * nested cwindow | redraw!
autocmd BufNewFile,BufReadPost *.js set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufRead *.js set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.ejs set filetype=html
autocmd FileType scss set iskeyword+=-
autocmd BufNewFile,BufReadPost *.scss set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.sh set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.sls set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.lua set shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufReadPost *.json set shiftwidth=4 softtabstop=4



let g:rust_fold = 1
let g:perl_fold = 1
let g:python_fold = 1
let g:erlang_fold = 1
let g:go_fold = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A']
let g:fastfold_savehook = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_json_syntax_conceal = 0
let g:indentLine_setConceal = 0



"""""""""""""""""""""""""""""""""""""""
"""""""""
"""""""" Settings for normal vi
"""""""""
"""""""""""""""""""""""""""""""""""""""

set splitbelow
set splitright
set cursorline
" reduce cursor hold time to 500s
set updatetime=500

set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:×
set list
set hid

set number
set nomodeline
set viminfo='1000,f1,:1000,/1000
set history=1000
set scrolloff=10
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

set exrc
set secure


"""""""""""""""""""""""""""""""""""""""
"""""""""
"""""""" Settings for Custom Funcs
"""""""""
"""""""""""""""""""""""""""""""""""""""

nnoremap <F3> :set wrap!<Enter>

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


"------  Local Overrides  ------
if filereadable($HOME.'/.vimrc_local')
    source $HOME/.vimrc_local
endif


filetype plugin indent on

