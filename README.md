

Want to display latex code within a buffer? -> Use this plugin.


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
