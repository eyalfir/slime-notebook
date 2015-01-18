python << endpython
import re
import vim

ignored_line = re.compile('^#')
cell_seperator = '#######################'
cell_seperator_regex = re.compile('^' + cell_seperator)
def get_vim_slime_function():
    return vim.eval('slime_notebook_slime_function')

def get_prefix():
    return vim.eval('slime_notebook_prefix')

def get_suffix():
    return vim.eval('slime_notebook_suffix')

def get_prev_cell_line_number():
    line_number = vim.current.range.start
    buf = vim.current.buffer
    met_good_line = False
    for i in reversed(range(line_number + 1)):
        if met_good_line and cell_seperator_regex.match(buf[i]):
            return i
        if not ignored_line.match(buf[i]):
            met_good_line = True
    return 0

def get_next_cell_line_number():
    line_number = vim.current.range.start
    buf = vim.current.buffer
    met_good_line = False
    for i in range(line_number, int(vim.eval('line("$")'))):
        if met_good_line and cell_seperator_regex.match(buf[i]):
            return i
        if not ignored_line.match(buf[i]):
            met_good_line = True
    return int(vim.eval('line("$")'))

def jump_to_next_cell():
    vim.command('normal! %dG' % (get_next_cell_line_number() + 1))

def jump_to_prev_cell():
    vim.command('normal! %dG' % (get_prev_cell_line_number() + 1))

def slime_cell():
    prev_line = get_prev_cell_line_number() if not cell_seperator_regex.match(vim.current.buffer[vim.current.range.start]) else vim.current.range.start
    text_to_slime = '\n'.join([vim.current.buffer[i] for i in range(prev_line, get_next_cell_line_number())])
    vim.command('call ' + get_vim_slime_function() + '("' + get_prefix()
            + text_to_slime.replace('"', '\\"') + get_suffix() + '")')

def insert_new_cell_below():
    line_number = vim.current.range.start
    if cell_seperator_regex.match(vim.current.buffer[line_number]):
        vim.current.buffer.append('', line_number + 1)
        vim.current.buffer.append(cell_seperator, line_number + 2)
    else:
        vim.current.buffer.append(cell_seperator, line_number + 1)
        vim.current.buffer.append('', line_number + 2)
        vim.command('normal! j')

def split_here():
    line_number = vim.current.range.start
    vim.current.buffer.append(cell_seperator, line_number + 1)

endpython

"bindings
nmap <silent> <ESC>j :py jump_to_next_cell()<CR>
nmap <silent> <ESC>k :py jump_to_prev_cell()<CR>
nmap <silent> ,, :py slime_cell()<CR>
nmap <silent> ,j :py slime_cell()<CR>:py jump_to_next_cell()<CR>
nmap <silent> <C-@> :py slime_cell()<CR>:py jump_to_next_cell()<CR>:py insert_new_cell_below()<CR>j
map <silent> <C-M>s :py split_here()<CR>
nmap <silent> <C-M>j <ESC>jdd
imap <silent> <C-@> <ESC>:py slime_cell()<CR>:py jump_to_next_cell()<CR>:py insert_new_cell_below()<CR>ji
let slime_notebook_prefix = ''
let slime_notebook_suffix = '\n\n'
let slime_notebook_slime_function = 'SlimuxSendCode'
