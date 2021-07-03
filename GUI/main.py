import tkinter as tk
from subprocess import Popen, PIPE, STDOUT
import shlex


button_row = 2
button_column = 1

entry_row1 = 1
entry_column1 = 0

entry_row2 = 1
entry_column2 = 2

text_row1 = 0
text_column1 = 0

text_row2 = 1
text_column2 = 1

text_row3 = 0
text_column3 = 2


work_flag = True

window = tk.Tk()


def button_press(event):
    agent_name = name_entry.get()
    port_number = port_entry.get()
    change_condition()
    start_program(agent_name,port_number)
    change_condition()

def change_condition():
    text = working_text["text"]
    if text == "Inactive":
        working_text["text"] = "Active"
    else:
        working_text["text"] = "Inactive"

def start_program(name,port):
    cmd_commands = 'c: && cd \"C:/Program Files/ECLiPSe 7.0/lib/x86_64_nt\" & eclipse -f ' \
                   '\"//E/Users/Kleanthis/Sxolh/Diplomatikh/prolog_starter_code/prolog_starter_code/src' \
                   '/main.ecl\" ' \
                   '-e main:start_game_player({0},{1},0).'.format(name,port)
    cmd_commands = shlex.split(cmd_commands)
    prolog_parser = Popen(cmd_commands, shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, text=True, bufsize=0)
    parser_output, parser_error = prolog_parser.communicate()
    parser_output = parser_output.rstrip('\n')
    print("Parser output:", parser_output)
    print("Parser Error:", parser_error)

button_frame = tk.Frame(master=window, relief=tk.RAISED,borderwidth=5)
button_frame.grid(row=button_row,column=button_column)
button = tk.Button(
    master=button_frame,
    text="Start Agent",
    width=25,
    height=5,
    bg="Black",
    fg="Red",
)
button.grid(row=button_row,column=button_column)
button.bind("<Button-1>", button_press)

name_text_frame = tk.Frame(master=window, relief=tk.FLAT)
name_text_frame.grid(row=text_row1,column=text_column1)
name_text = tk.Label(master=name_text_frame,text="Add Agent Name")
name_text.grid(row=text_row1,column=text_column1)

working_text_frame = tk.Frame(master=window,relief=tk.FLAT)
working_text_frame.grid(row=text_row2, column=text_column2)
working_text = tk.Label(master=working_text_frame,text="Inactive")
working_text.grid(row=text_row2, column=text_column2)

name_entry_frame = tk.Frame(master=window, relief=tk.SUNKEN,borderwidth=5 )
name_entry_frame.grid(row=entry_row1, column=entry_column1)
name_entry = tk.Entry(master=name_entry_frame)
name_entry.insert(0, "my_agent")
name_entry.grid(row=entry_row1,column=entry_column1)

port_text_frame = tk.Frame(master=window, relief=tk.FLAT)
port_text_frame.grid(row=text_row3,column=text_column3)
port_text = tk.Label(master=port_text_frame,text="Add Port")
port_text.grid(row=text_row3,column=text_column3)

port_entry_frame = tk.Frame(master=window, relief=tk.SUNKEN,borderwidth=5 )
port_entry_frame.grid(row=entry_row2, column=entry_column2)
port_entry = tk.Entry(master=port_entry_frame)
port_entry.insert(0, "8000")
port_entry.grid(row=entry_row2,column=entry_column2)

window.mainloop()

