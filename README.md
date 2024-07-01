Version: 0.1
Creation of the readme is in progress...

# Installation
## Requirements

1. Perl provider as the script for the transformation into utf-8 charachters is done using a perl script.
    - For information on the installation of a perl provider visit https://neovim.io/doc/user/provider.html

2. Nerd Icons to display the utf-8 charachters correctly: 
```
Plug 'glepnir/nerdicons.nvim', {'do': 'NerdIcons'}
```

    

# Options 

    config = {
        autocmds = false,
        usercmds = true,
        file_types = {'tex'},

        highlighting = {
            fg = 'NONE',
            bg = '#082a2b',
            gui = 'NONE'
        },

        virt_text_params = {
            string_before = '->  '
        },
    },


# Example Use-Cases
\[
    \int_{1}^\infty \varepsilon dx
\]

Sum over random variable \( \sum_{k=1}^n X(\omega_k) \). A random variable \(X: \Omega \to \mathbb R\\ \omega \mapsto X(\omega) \). 

The expected value \( \mathbb E [X] = \int_{x \in \mathbb R} x d\mathbb P_X\)

