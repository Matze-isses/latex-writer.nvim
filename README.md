Version: 0.1
Creation of the readme is in progress...

As this is my first public neovim plugin the code can be improved heavily.


# Installation
## Requirements

1. Perl provider as the script for the transformation into utf-8 charachters is done using a perl script.
    - For information on the installation of a perl provider visit https://neovim.io/doc/user/provider.html

2. Nerd Icons to display the utf-8 charachters correctly

## Example import
```
Plug 'glepnir/nerdicons.nvim', {'do': 'NerdIcons'}
Plug 'matze-isses/latex-writer'
```

    

# Default Options 

```
require("latex-writer").setup({
    --- prints the exit code if pearl script does not return anything
    debug = false,

    --- currently not working! Same effect by using the usercommand: "LatexWriterToggleAuto"
    autocmds = false,

    --- Determines if usercommands should be set.
    usercmds = true,

    --- Filetypes where this plugin can be applied
    apply_on_filetypes = {'tex', 'markdown'},

    --- highlighting of the generated virtual text
    highlighting = {
        fg = '#e8ee30',
        bg = 'NONE',
        gui = 'NONE'
    },

    virt_text_params = {
        --- string placed before the latex formula
        string_before = string.rep(' ', 4),

        --- Writes in the sign column where this plugin detects latex formulas.
        mark_at_signcolumn = true
    },
})
```


# Example Use-Cases

\[
    \int_{1}^\infty \varepsilon dx
\]
Sum over random variable \( \sum_{k=1}^n X(\omega_k) \). A random variable \(X: \Omega \to \mathbb R\\ \omega \mapsto X(\omega) \). 
The expected value \( \mathbb E [X] = \int_{x \in \mathbb R} x d\mathbb P_X\)

