echom("herpderp")
if exists('g:loaded_k8s') || &cp || v:version < 700
  finish
endif
let g:loaded_k8s = 1

" Could be useful later for checking compatibility:
"let s:nvim = has('nvim')
"let s:async = has('job') && has('channel')

""" Kubernetes plugin -------------------{{{

function! MakeLocList()
    " 0 often means this window like in this case
    " or is like a general broadcast type of thing
    let l:current_window = 0
    " A empty string for some reason instructs it
    " to create a new location list
    let l:create_new_list = ' '
    let l:resource_list = systemlist('kubectl get pods')
    " Pretty dirty to set efm to %f here, but it seems like ||
    " is hardcoded in the output, and only way to not have them prefixed
    " is to pretend that a podname is a filename.
    " Link
    " https://stackoverflow.com/questions/59992729/vim-quickfix-prefixes-double-bar-explain
    " Has a good explanation for the efm, and basically says i should use
    " an alternative
    call setloclist(l:current_window, [], l:create_new_list, { 'lines' : l:resource_list, 'efm': '%f', 'title':'Pods'})
    call CmdLine("lopen<cr>")

    nnoremap <buffer> <CR> :call SelectResource('e')<CR>
    nnoremap <buffer> d :call SelectResource('d')<CR>

    setlocal nowrap
endfunction

function! SelectResource(action)
    let l:saved_reg = @"
    let l:saved_reg_type = getregtype(@")

    execute "normal! yW"
    let l:pattern = @"

    execute ":vsplit | term"
    if !exists('b:terminal_job_id')
        echom 'This buffer is not a terminal.'
        return
    end
    if action == "d"
        call chansend(b:terminal_job_id, "kubectl describe pods " . l:pattern . "\n")
    else
        call chansend(b:terminal_job_id, "kubectl exec -it " . l:pattern . " bash\n")
    endif

    " Restore the register after use
    call setreg(@", l:saved_reg, l:saved_reg_type)
endfunction

nnoremap <silent> <leader>a  :call MakeLocList()<CR>
"nnoremap <silent> <leader>e  :call SelectResource('e')<CR>
"nnoremap <silent> <leader>d  :call SelectResource('d')<CR>
"}}}

