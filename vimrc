set rtp+=~/dev/agda-vim
set number relativenumber
set expandtab softtabstop=4 shiftwidth=4
" Remember undo when buffers
set hidden
" Show whitespace
set list listchars=tab:>.,trail:$
" Linux-style tab completion in command mode - complete until first ambiguity
set wildmode=list:longest

nnoremap zx :w<cr>
" hide hlsearch
nnoremap <silent> z/ :noh<cr>
" avoid accidental ex mode
nnoremap Q <Nop>
" inverse of J
nnoremap K r<cr>
" buffer switching
nnoremap gb :ls<CR>:b<space>

inoremap !ios ios::sync_with_stdio(false); cin.tie();
inoremap !std using namespace std;
inoremap @kk kuba@kadziolka.net
inoremap !? <esc>diwastd::cerr << "<C-R>" = " << <C-R>"<esc>:s/\(std::cerr.*\)std::cerr << "/\1 << ", /e<cr>A

augroup filetypes
    au!
    autocmd BufRead,BufNewFile,BufWritePost *.sage setlocal filetype=python
    autocmd BufRead,BufNewFile,BufWritePost *.lalrpop setlocal filetype=rust
    autocmd FileType scheme syn sync fromstart
    autocmd FileType haskell,yaml,forth setlocal shiftwidth=2 softtabstop=2
    autocmd FileType markdown setlocal textwidth=80
    autocmd FileType plaintex setlocal filetype=tex
augroup END

let g:markdown_fenced_languages = ['python', 'rust', 'forth', 'c', 'scheme', 'haskell']

" Disables arrow-keys, which I don't care about, and ignores the scroll wheel,
" which is Very Annoying on a touchpad.
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>

inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
