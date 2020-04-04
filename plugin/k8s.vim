if exists('g:loaded_k8s') || &cp || v:version < 700
  finish
endif
let g:loaded_k8s = 1

function! ListPods()
    let l:current_window = 0
    let l:create_new_list = ' '
    let l:resource_list = systemlist('kubectl get pods')
    call setloclist(l:current_window, [], l:create_new_list, { 'lines' : l:resource_list, 'efm': '%f', 'title':'Pods'})
    call CmdLine("lopen<cr>")

    nnoremap <buffer> <CR> :call CallKubectl('e')<CR>
    nnoremap <buffer> e :call CallKubectl('e')<CR>
    nnoremap <buffer> d :call Describe()<CR>

    setlocal nowrap
endfunction

function! Describe()
    let l:saved_reg = @"
    let l:saved_reg_type = getregtype(@")

    execute "normal! yW"
    let l:pattern = @"
    if !exists('b:terminal_job_id')
        echom 'This buffer is not a terminal.'
        return
    end
    call chansend(b:terminal_job_id, "kubectl describe pods " . l:pattern . "|less")

    call setreg(@", l:saved_reg, l:saved_reg_type)
endfunction

function! CallKubectl(action)
    let l:saved_reg = @"
    let l:saved_reg_type = getregtype(@")

    execute "normal! yW"
    let l:pattern = @"

    execute ":vsplit | term"
    if !exists('b:terminal_job_id')
        echom 'This buffer is not a terminal.'
        return
    end
    if a:action == "d"
        call chansend(b:terminal_job_id, "kubectl describe pods " . l:pattern . "\n")
    else
        call chansend(b:terminal_job_id, "kubectl exec -it " . l:pattern . " bash\n")
    endif

    call setreg(@", l:saved_reg, l:saved_reg_type)
endfunction

nnoremap <silent><unique> <leader>a  :call ListPods()<CR>
