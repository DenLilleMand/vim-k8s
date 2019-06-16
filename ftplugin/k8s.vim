echom("herpderp")
if exists('g:loaded_k8s') || &cp || v:version < 700
  finish
endif
let g:loaded_k8s = 1

let s:nvim = has('nvim')
let s:async = has('job') && has('channel')

function! MakeLocList()
    call setloclist(0, [], ' ', {'lines' : systemlist('kubectl get all')})
    execute  lopen()
     call CmdLine("lopen<cr>")
endfunction

function! SelectResource()
    let l:saved_reg = @"
    let l:saved_reg_type = getregtype(@")

    execute "normal! yW"
    let l:pattern = @"


    execute ":vsplit | term"
    if !exists('b:terminal_job_id')
        echom 'This buffer is not a terminal.'
        return
    end
    call chansend(b:terminal_job_id, "kubectl exec -it " . l:pattern . " bash\n")

    " Restore the register after use
    call setreg(@", l:saved_reg, l:saved_reg_type)
endfunction

nnoremap <silent> <leader>a  :call MakeLocList()<CR>
nnoremap <silent> <leader>e  :call SelectResource()<CR>



