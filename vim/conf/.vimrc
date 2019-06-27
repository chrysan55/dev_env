" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
" set compatible

execute pathogen#infect()


" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Only do this part when compiled with support for autocommands
if has("autocmd")
    augroup redhat
    autocmd!
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
    " don't write swapfile on most commonly used directories for
    " NFS mounts or USB sticks
    autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=/var/tmp,/tmp
    " start with spec file template
    autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
    augroup END 
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

if &term=="xterm"
	set t_Co=8
	set t_Sb=^[[4%dm
	set t_Sf=^[[3%dm
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Set mapleader
let mapleader = ","

set fileencodings=utf-8,gb2312,gbk,gb18030

set termencoding=utf-8

set fileformats=dos

set encoding=prc

set nocompatible 

set nu

filetype on 

set history=1000 

set background=dark 

set autoindent 
"set smartindent 

set tabstop=4 
"set expandtab
set shiftwidth=4 

set showmatch 

"set guioptions-=T 

set vb t_vb= 

set ruler 

"set nohls

"set mouse=a


set incsearch 


set nobackup 

set backspace=indent,eol,start

set backspace=2

set formatoptions=tcqMm

" Highlight tabline
set showtabline=0

let Tlist_Exit_OnlyWindow=1

" CtrlP
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'r'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

"autocmd vimenter * TagbarOpen
"autocmd tabenter * TagbarOpen
let g:tagbar_ctags_bin='/usr/local/bin/ctags'
let g:tagbar_compact = 1
"autocmd vimenter * NERDTree
"autocmd VimEnter * 2 wincmd w
"autocmd TabLeave * tabp
"autocmd VimEnter * TrinityToggleAll
"autocmd TabEnter * TrinityToggleAll
"autocmd TabLeave * TrinityToggleAll
let g:nerdtree_tabs_autofind=1
"let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_focus_on_files=1
let NERDTreeShowBookmarks=1
"autocmd WinEnter * call s:CloseIfOnlyNerdTree()
"autocmd VimEnter * 2 wincmd w
" Close all open buffers on entering a window if the only
"  buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTree()
    if exists("t:NERDTreeBufName")
        if bufwinnr(t:NERDTreeBufName) != -1
            if winnr("$") == 1
                q
            elseif winnr("$") == 2
                if bufwinnr("__Tag_List__") != -1
                    q
                endif
                if bufwinnr("__Tag_Bar__") != -1
                    q
                endif
            endif
        endif
    endif
endfunction

function! s:DeleteCurrentBuffer()
	let currentBufferNo = bufnr("%")
endfunction


imap <C-h> <Left>
imap <C-l> <Right>
imap <C-j> <Down>
imap <C-k> <Up>

map tl :Tlist<CR> 
map tc :TlistClose<CR> 
map ts :ts<CR> 
"map tt :TagbarToggle<CR>
map nt :NERDTree<CR>
map = :bn<CR>
map - :bp<CR>
map <Leader>1 :1b<CR>
map <Leader>2 :2b<CR>
map <Leader>3 :3b<CR>
map <Leader>4 :4b<CR>
map <Leader>5 :5b<CR>
map <Leader>6 :6b<CR>
map <Leader>7 :7b<CR>
map <Leader>8 :8b<CR>
map <Leader>9 :9b<CR>
map <Leader>sh :set ft=sh<CR>
map <Leader>a viwy:Ack <c-r>"
let g:ackprg = 'ag --nogroup --nocolor --column'

nmap <Leader><Space> <C-w><C-]><C-w>T
nmap <Leader>t :LeaderfBufTag<CR>
nmap <Leader>s :LeaderfTag<CR>

nmap <Leader>x :call s:DeleteCurrentBuffer()

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

"Swap
vnoremap <C-S-X> <ESC>`.``gvp``P

" Fold with research result
nnoremap zpr :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>:set foldmethod=manual<CR><CR>

" Doxygen config
let g:DoxygenToolkit_authorName="Zhao Gang"
let g:DoxygenToolkit_authorTag="donzhao@tencent.com"
let s:licenseTag = "Copyright(C) 2018 Tencent.com, Inc."
let s:licenseTag = s:licenseTag . "All right reserved\<enter>"
let g:DoxygenToolkit_licenseTag = s:licenseTag
let g:DoxygenToolkit_briefTag_funcName="yes"
let g:doxygen_enhanced_color=1
let g:DoxygenToolkit_compactDoc="yes"
let g:DoxygenToolkit_paramTag_post=" - "
let g:DoxygenToolkit_briefTag_post = "- "
let g:DoxygenToolkit_throwTag_post = " - "
let g:DoxygenToolkit_pythonStyle = 1
map <leader>da :DoxAuthor<CR>
map <leader>df :Dox<CR>
map <leader>db :DoxBlock<CR>
map <leader>dl :DoxLic<CR>
map <leader>dc a /* */<LEFT><LEFT><LEFT>

let g:indentLine_char = '|'
let g:indentLine_color_gui = 'DarkGrey'
let g:indentLine_color_term = 0
let g:indentLine_enabled = 0
au Filetype python let g:indentLine_enabled=1
au Filetype javascript let g:indentLine_enabled=1
"let g:indentLine_color_tty_light = 4
"let g:indentLine_color_dark = 1

" Default scheme
let g:solarized_menu=0
let g:solarized_termtrans=0
"let g:solarized_termcolors = 256
colorscheme solarized

" highlight current line
"set cursorline 
"hi CursorLine cterm=bold 
"hi CursorColumn cterm=bold
"au Filetype python set cursorcolumn

" set floder
set foldlevelstart=99
"au Filetype python set foldmethod=indent
set foldmethod=indent

" python completion
"au FileType python set omnifunc=pythoncomplete#Complete
"let g:SuperTabDefaultCompletionType = "context"
"let g:SuperTabClosePreviewOnPopupClose = 0
"set completeopt=menuone,longest,preview

" flake8
let g:flake8_quickfix_location="botright"
"map <leader>n :cn<CR> 
"map <leader>p :cp<CR> 

" ctags & cscope
"set tags=/home/zhaogang/tags,./tags,./TAGS,tags,TAGS;set autochdir
if has("cscope")
    set cscopequickfix=c-,d-,i-,t-,e-
    set csto=0
    set cst
    set nocsverb
endif

set completeopt=menu

function! LoadCTagsAndCScope()
    let max = 10
    "let dir = substitute(getcwd(), $HOME, "~", "g")
    let dir=expand('%:p:h') . '/'
    let curdir=dir
    let i = 0
    let break = 0
    while isdirectory(dir) && i < max
        if filereadable(dir . 'GTAGS')
            execute 'cs add ' . dir . 'GTAGS ' . glob("`pwd`")
            let break += 1
        endif
        if filereadable(dir . 'cscope.out')
            execute 'cs add ' . dir . 'cscope.out '
            let break = 1
        endif
        if filereadable(dir . 'tags')
            execute 'set tags =' . dir . 'tags'
            let break = 1
        endif
        if break == 1
            "execute 'lcd ' . dir
            break
        endif
        let dir = dir . '../'
        let i = i + 1
    endwhile
endf

function! AutoLoadCTagsAndCScope()
    if &filetype == 'c'
        call LoadCTagsAndCScope()
    endif
endf

autocmd vimenter * call AutoLoadCTagsAndCScope()
function! UpdateCtags()
    let curdir=getcwd()
    while !filereadable("/home/zhaogang/tags")
        cd ..
        if getcwd() == "/"
            break
        endif
    endwhile
    if filewritable("/home/zhaogang/tags")
        !ctags -R --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q
    endif
    execute ":cd " . curdir
endfunction
"nmap <leader>c :call UpdateCtags()<CR>

"set showtabline=2
nmap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>:belowright copen<CR>
nmap <leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
map <C-LeftMouse> :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>:belowright copen<CR>
nmap <leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>:belowright copen<CR>
nmap <leader>ce :cs find e <C-R>=expand("<cword>")<CR><CR>:belowright copen<CR>
nmap <leader>cf :cs find f <C-R>=expand("<cfile>")<CR><CR>:belowright copen<CR>
nmap <leader>ci :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:belowright copen<CR>
nmap <leader>cd :cs find d <C-R>=expand("<cword>")<CR><CR>:belowright copen<CR>
nmap <leader>q :ccl<CR>

" Ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" let g:UltiSnipsExpandTrigger="<Tab>"
"let g:UltiSnipsJumpForwardTrigger="<C-j>"
"let g:UltiSnipsJumpBackwardTrigger="<C-k>"

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"
"let g:UltiSnipsSnippetDirectories=['UltiSnips']
"let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'

"jedi completion
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    "set fileencodings=ucs-bom,utf-8,latin1
    "setglobal bomb
endif
"let g:jedi#popup_on_dot = 0
let g:jedi#use_splits_not_buffers = "top"
let g:jedi#auto_vim_configuration = 1
let g:jedi#squelch_py_warning = 1
let g:jedi#show_call_signatures = 0

" Supertab
let g:SuperTabDefaultCompletionType="context" 

" YouCompleteMe
"let g:"ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py"
"let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1 }
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_min_num_of_chars_for_completion = 2
"set completeopt-=preview
"let g:ycm_seed_identifiers_with_syntax = 1
"let g:ycm_collect_identifiers_from_tag_files = 1
""let g:ycm_key_invoke_completion = '<leader>.'
"let g:ycm_key_invoke_completion = '<C-o>'
"let g:ycm_server_log_level = 'debug'
"nmap <leader>g :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR>"
"let g:ycm_filetype_blacklist = {
      "\ 'tagbar' : 1,
      "\ 'nerdtree' : 1,
      "\ 'python': 1}

"set completeopt=menu

"map  <F2>   <Plug>ShowFunc
"map!  <F2>   <Plug>ShowFunc

" AutoPair
let g:AutoPairsMapCR = 0

" Mark line over 100 chars
function! HighlightLineOver100Chars()
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%101v.\+/
endf
au Filetype python call HighlightLineOver100Chars()
au Filetype c call HighlightLineOver100Chars()
au Filetype sh call HighlightLineOver100Chars()
au Filetype java call HighlightLineOver100Chars()

" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_enable_highlighting=1
"let g:syntastic_python_checkers=['pyflakes']
"let g:syntastic_check_on_wq = 0
"let g:syntastic_mode = 'passive'
"nnoremap <Leader>f :lnext<cr>
"nnoremap <Leader>b :lprevious<cr>

" SrcExpl & Trinity
" // The switch of the Source Explorer 
"nmap <F8> :SrcExplToggle<CR> 

" // Set the height of Source Explorer window 
"let g:SrcExpl_winHeight = 8 

" // Set 100 ms for refreshing the Source Explorer 
"let g:SrcExpl_refreshTime = 10

" // Set "Enter" key to jump into the exact definition context 
"let g:SrcExpl_jumpKey = "<ENTER>" 

" // Set "Space" key for back from the definition context 
"let g:SrcExpl_gobackKey = "<SPACE>" 

" // In order to Avoid conflicts, the Source Explorer should know what plugins 
" // are using buffers. And you need add their bufname into the list below 
" // according to the command ":buffers!" 
"let g:SrcExpl_pluginList = [ 
        "\ "NERD_tree_1", 
        "\ "Source_Explorer",
        "\ "__Tagbar__",
        "\ "-MiniBufExplorer-"
"    \ ] 

" // Enable/Disable the local definition searching, and note that this is not 
" // guaranteed to work, the Source Explorer doesn't check the syntax for now. 
" // It only searches for a match with the keyword according to command 'gd' 
"let g:SrcExpl_searchLocalDef = 1

" // Do not let the Source Explorer update the tags file when opening 
"let g:SrcExpl_isUpdateTags = 1 

" // Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to 
" //  create/update a tags file 
"let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ." 

" // Set "<F12>" key for updating the tags file artificially 
"let g:SrcExpl_updateTagsKey = "<F12>"  

" Open and close all the three plugins on the same time 
"nmap <F8>  :TrinityToggleAll<CR> 

" Open and close the Source Explorer separately 
"nmap <F9>  :TrinityToggleSourceExplorer<CR> 

" Open and close the Taglist separately 
"nmap <F10> :TrinityToggleTagList<CR> 

" Open and close the NERD Tree separately 
"nmap <F11> :TrinityToggleNERDTree<CR>

" for json beautify
noremap <buffer> <leader>j :!python -m json.tool<cr>

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')"

Plug 'Yggdroot/LeaderF', { 'do': './install.sh'  }
"Plug 'mhinz/vim-signify'
"Plug 'ludovicchabant/vim-gutentags'

" Initialize plugin system
call plug#end()

" Signify 默认关闭,提升文件打开速度
"let g:signify_disable_by_default = 0

" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" gutentags 更新 ctags & cscope
let g:gutentags_modules = ['ctags', 'cscope']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = 'tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let s:vim_tags = expand('~/.cache/tags')
"let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
"let g:gutentags_ctags_extra_args = ['--fields=+iaS', '--extra=+q']
"let g:gutentags_ctags_extra_args += ['--c++-kinds=+p']
"let g:gutentags_ctags_extra_args += ['--c-kinds=+p']

" 检测 ~/.cache/tags 不存在就新建
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" LeaderF 搜索整个工程目录
let g:Lf_WorkingDirectoryMode = 'a'
