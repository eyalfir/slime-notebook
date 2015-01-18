# slime-notebook

Turn you vim + tmux + ipython terminal into an improved ipython-notebook

# Features

* Works over any slime plugin (vim-slime, tslime, slimux)
* works with any REPL (tested mostly with ipython console and bash)

## Customization

By default

## ipython notes

Turn autoindent off

    In []: %autoindent

Otherwise use ipython cpaste magic:

    let slime_notebook_prefix="%cpaste"
    let slime_notebook_suffix="\n--\n"
