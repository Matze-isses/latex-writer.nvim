import neovim
import subprocess
neovim.pynvim.decode('utf-8')


@neovim.plugin
class NvimLatex:

    def __init__(self, nvim) -> None:
        self.nvim = nvim

    @neovim.function('GetLatex', sync=True)
    def get_latex_code(self, args):
        latex_code = args[0]
        path = args[1]
        result = subprocess.run(' ' + latex_code, capture_output=True, text=True, shell=True, encoding='utf-8')
        return result.stdout.encode('utf-8')


# print(NvimLatex(None).get_latex_code([r'\sum_{i=1}^{n} i ']))
