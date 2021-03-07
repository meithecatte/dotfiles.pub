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

inoremap !jk Jakub Kądziołka
inoremap !pz Pozdrawiam,<CR>Jakub Kądziołka
inoremap !rg Regards,<CR>Jakub Kądziołka
inoremap !ios ios::sync_with_stdio(false); cin.tie();
inoremap !std using namespace std;
inoremap @kk kuba@kadziolka.net

augroup filetypes
    au!
    autocmd FileType scheme syn sync fromstart
augroup END
