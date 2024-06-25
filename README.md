
Creation of the readme is in progress...

# Example Use-Cases
\[
    \int_1^\infty \varepsilon dx
\]

Sum over random variable \( \sum_{k=1}^n X(\omega_k) \). A random variable \(X: \Omega \to \mathbb R\\ \omega \mapsto X(\omega) \). 

The expected value \( \mathbb E [X] = \int_{x \in \mathbb R} x d\mathbb P_X\)

# Requirements


1. Perl provider as the script for the transformation into utf-8 charachters is done using a perl script.
    - For information on the installation of a perl provider visit https://neovim.io/doc/user/provider.html
    

# Options 

    config = {
        --- 
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



Version: 0.1
