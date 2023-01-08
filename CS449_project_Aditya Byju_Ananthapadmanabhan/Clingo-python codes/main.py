import clingo
from tkinter import *
import numpy as np

# taking input from input.txt
with open('input1.txt') as f:
    lines = f.readlines()

c = 1
s = ""
l = []
no = 1

compDict = {}

for x in lines:
    string = x
    string = string.split(' ', 1)
    compDict[c] = string[0]
    nodes = [int(s) for s in x.split() if s.isdigit()]
    no = max(no, nodes[0])
    no = max(no, nodes[1])
    s = "comp("+str(c)+","+str(nodes[0])+","+str(nodes[1])+")."
    l.append(s)
    c = c+1


# variables to store important info
h = 0
w = 0
ctr = 0
wire = []
comp = []
compLocations = []
wireLocations = []

# function to extract stable models from clingo and store it


def myfn(ans):
    global ctr
    global h
    global w
    global wireLocations
    global compLocations
    ctr += 1
    print("Answer number: ", ctr, " is printed below")
    atoms = ans.symbols(atoms=True)
    print("Atoms are: ", atoms)
    w = 0
    h = 0
    compLocations = []
    wireLocations = []

    for atom in atoms:
        if(atom.name == "place"):
            s = str(atom.arguments[3])
            w = max(w, int(s)-1)
            s = str(atom.arguments[4])
            h = max(w, int(s)-1)
            comp = []
            for arg in atom.arguments:
                comp.append(int(str(arg)))
            compLocations.append(comp)

        elif(atom.name == "wplace"):
            s = str(atom.arguments[4])
            w = max(w, int(s)-1)
            s = str(atom.arguments[5])
            h = max(w, int(s)-1)
            wire = []
            for arg in atom.arguments:
                wire.append(int(str(arg)))
            wireLocations.append(wire)
        else:
            continue


# function to display the final PCB design
def pcbLayout():
    global compLocations
    global wireLocations
    global compDict
    global w
    global h

    # changeable thickness of the cell
    t = 101

    myw = Tk()
    myw.title(" Effective PCB Design")
    myc = Canvas(myw, width=(w)*t, height=(h)*t, background='#008C4A')
    myc.grid(row=0, column=0)

    # placement of components
    for components in compLocations:
        stringTemp = str(compDict[components[0]])
        y = components[1]-1
        x = components[2]-1
        i = myc.create_text(x*t + (t+1)/2, y*t + (t+1)/2, fill="darkblue", font="Times 20 italic bold",
                            text=stringTemp)
        r = myc.create_rectangle(x*t + 0, y*t + 0, x*t + t,
                                 y*t + t, fill="#bdd99e")
        myc.tag_lower(r, i)

    # placement of wires
    for wires in wireLocations:
        y = wires[2]-1
        x = wires[3]-1
        a = wires[0]
        b = wires[1]
        if (a == 1 and b == 2) or (a == 2 and b == 1):
            myc.create_line(x*t + (t+1)/2, y*t + (t+1)/2, x*t + (t+1)/2,
                            y*t + t, fill='#FFD700')
            myc.create_line(x*t + (t+1)/2, y*t + (t+1)/2, x*t +
                            t, y*t + (t+1)/2, fill='#FFD700')
        elif (a == 1 and b == 3) or (a == 3 and b == 1):
            myc.create_line(x*t + 0, y*t + (t+1)/2, x*t + t,
                            y*t + (t+1)/2, fill='#FFD700')
        elif (a == 1 and b == 4) or (a == 4 and b == 1):
            myc.create_line(x*t + (t+1)/2, y*t + 0, x*t + (t+1)/2,
                            y*t + (t+1)/2, fill='#FFD700')
            myc.create_line(x*t + (t+1)/2, y*t + (t+1)/2, x*t +
                            t, y*t + (t+1)/2, fill='#FFD700')
        elif (a == 2 and b == 3) or (a == 3 and b == 2):
            myc.create_line(x*t + 0, y*t + (t+1)/2, x*t + (t+1)/2,
                            y*t + (t+1)/2, fill='#FFD700')
            myc.create_line(x*t + (t+1)/2, y*t + (t+1)/2, x*t + (t+1)/2,
                            y*t + t, fill='#FFD700')
        elif (a == 2 and b == 4) or (a == 4 and b == 2):
            myc.create_line(x*t + (t+1)/2, y*t + 0, x*t + (t+1)/2,
                            y*t + t, fill='#FFD700')
        elif (a == 3 and b == 4) or (a == 4 and b == 3):
            myc.create_line(x*t + (t+1)/2, y*t + 0, x*t + (t+1)/2,
                            y*t + (t+1)/2, fill='#FFD700')
            myc.create_line(x*t + (t+1)/2, y*t + (t+1)/2, x*t +
                            0, y*t + (t+1)/2, fill='#FFD700')

    myw.mainloop()


# run clingo and generate answers
ctl = clingo.Control("0")
n = int(input("What is n? -> "))
with open("data.lp", 'w') as f:
    for L in l:
        f.writelines(L)
        f.writelines("\n")
    f.write("#const n="+str(n)+".")
    f.writelines("\n")
    f.write("#const no="+str(no)+".")
ctl.load("data.lp")
ctl.load("project.lp")
ctl.configuration.solve.models = "0"
ctl.ground([("base", [])])

with ctl.solve(on_model=lambda m: myfn(m), async_=True) as handle:
    while not handle.wait(0):
        pass
    handle.get()


# display the output PCB Design
pcbLayout()
