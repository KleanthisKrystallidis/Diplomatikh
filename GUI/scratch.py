import tkinter as tk
from subprocess import Popen, PIPE, STDOUT
import shlex


name='my_agent'
port=9149
lol = '0'
cmd_commands = 'c: && cd \"C:/Program Files/ECLiPSe 7.0/lib/x86_64_nt\" & eclipse -f ' \
               '\"//E/Users/Kleanthis/Sxolh/Diplomatikh/prolog_starter_code/prolog_starter_code/src' \
               '/main.ecl\" ' \
               '-e main:start_game_player({0},{1},{2}).'.format(name, port, lol)
cmd_commands = shlex.split(cmd_commands)
prolog_parser = Popen(cmd_commands, shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, text=True, bufsize=0)
parser_output, parser_error = prolog_parser.communicate()
parser_output = parser_output.rstrip('\n')
print("Parser output:", parser_output)
print("Parser Error:", parser_error)