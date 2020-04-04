if exists('g:loaded_k8s') || &cp || v:version < 700
  finish
endif
let g:loaded_k8s = 1

if !exists('g:vim_k8s#shell')
    let g:vim_k8s#shell = 'bash'
endif

if !exists('g:vim_k8s#pager')
    let g:vim_k8s#pager = 'less'
endif

function! vim_k8s#ListPods()
    let l:current_window = 0
    let l:create_new_list = ' '
    let l:resource_list = systemlist('kubectl get pods')
    call setloclist(l:current_window, [], l:create_new_list, { 'lines' : l:resource_list, 'efm': '%f', 'title':'Pods'})
    call CmdLine("lopen<cr>")

    nnoremap <buffer> <CR> :call vim_k8s#CallKubectl('e')<CR>
    nnoremap <buffer> e :call vim_k8s#CallKubectl('e')<CR>
    nnoremap <buffer> d :call vim_k8s#Describe()<CR>

    setlocal nowrap
endfunction

function! vim_k8s#Describe()
    let l:saved_reg = @"
    let l:saved_reg_type = getregtype(@")

    execute "normal! yW"
    let l:pattern = @"
    call system("kubectl describe pods " . l:pattern . "|" . g:vim_k8s#pager)

    call setreg(@", l:saved_reg, l:saved_reg_type)
endfunction

function! vim_k8s#CallKubectl(action)
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
        call chansend(b:terminal_job_id, "kubectl exec -it " . l:pattern . g:vim_k8s#shell . "\n")
    endif

    call setreg(@", l:saved_reg, l:saved_reg_type)
endfunction

nnoremap <silent> <Plug>(vim_k8s-listpods) :call vim_k8s#ListPods()<CR>

