# vim-k8s

Plugin for vim/nvim that allows you to easily list pods and execing into it
with a preferred shell.
You bind a mapping to show the list of pods, when the list appears you
have a few options available:

* `<enter>` - exec into the pod
* `e` - exec into the pod
* `d` - describe the pod

![](file:examples/example.gif)

## Configuration

The only global mapping required is `<Plug>(vim_k8s-listpods)`,
so you can map it to anything non-conflicting like:

```vimscript
nnoremap <silent> <leader>a <Plug>(vim_k8s-listpods)
```

This mapping has to be added, since this plugin does not
take any default mapping. The mapping is also only tested for normal
mode, but you could map it in other modes.

The exec command used for the pods is:

```bash
kubectl exec -it <pod> <shell>
```

The default shell is `bash`, if you want to change it you can
set it like this in your vim file:

```vimscript
let g:vim_k8s#shell = 'sh'
```

or

```vimscript
let g:vim_k8s#shell = 'zsh'
```

Most important is that the shell set, actually exists in the pod.

It is possible to change the pager of the pod describe command by
setting the global variable `vim_k8s#pager`

```vimscript
let g:vim_k8s#pager = 'more'
```

The default is `less`

## Install

### VimPlug

```bash
    Plug 'denlillemand/vim-k8s'
```

Source .vimrc or init.vim and run `bash:PlugInstall`

## Prerequisites

This plugin assumes a working `kubectl` command available on your cmdline.
It also assumes that kubectl has a default context set,
that you wish to use there is no magic letting you
select a different context when running the commands.
