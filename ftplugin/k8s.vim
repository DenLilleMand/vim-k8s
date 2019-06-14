echom("herpderp")
if exists('g:loaded_k8s') || &cp || v:version < 700
  finish
endif
let g:loaded_k8s = 1

let s:nvim = has('nvim')
let s:async = has('job') && has('channel')

function! SelectResource()
    let l:saved_reg = @"
    let l:saved_reg_type = getregtype(@")

    execute "normal! yiW"
    let l:pattern = @"

    call CmdLine("kubectl exec -it '" . l:pattern . "' bash" )

    " Restore the register after use
    call setreg(@", l:saved_reg, l:saved_reg_type)
endfunction

