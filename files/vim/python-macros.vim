set tags+=$HOME/.vim/tags/python.ctags
set suffixesadd+=.py

python << EOF
import os
import sys
import vim
python_path = "/usr/lib/python2.4"
vim.command(r"set path=%s" % python_path)
dir = os.listdir(python_path)
for item in dir:
  fullpath = os.path.join(python_path, item)
  if os.path.isdir(fullpath):
    vim.command(r"set path+=%s" % (fullpath.replace(" ", r"\ ")))
EOF

python << EOF
def SetBreakpoint():
    import re
    nLine = int( vim.eval( 'line(".")'))

    strLine = vim.current.line
    strWhite = re.search( '^(\s*)', strLine).group(1)

    vim.current.buffer.append(
       "%(space)spdb.set_trace() %(mark)s Breakpoint %(mark)s" %
         {'space':strWhite, 'mark': '#' * 30}, nLine - 1)

    for strLine in vim.current.buffer:
        if strLine == "import pdb":
            break
    else:
        vim.current.buffer.append( 'import pdb', 0)
        vim.command( 'normal j1')

vim.command('map <f5> :py SetBreakpoint()<cr>')
vim.command('map <f6> :py RemoveBreakpoints()<cr>')
vim.command('map <f7> :!python %<cr>')

def RemoveBreakpoints():
    import re

    nCurrentLine = int( vim.eval( 'line(".")'))

    nLines = []
    nLine = 1
    for strLine in vim.current.buffer:
        if strLine == 'import pdb' or strLine.lstrip()[:15] == 'pdb.set_trace()':
            nLines.append( nLine)
        nLine += 1

    nLines.reverse()

    for nLine in nLines:
        vim.command( 'normal %dG' % nLine)
        vim.command( 'normal dd')
        if nLine < nCurrentLine:
            nCurrentLine -= 1

    vim.command( 'normal %dG' % nCurrentLine)

EOF
