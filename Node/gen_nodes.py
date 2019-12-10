import sys
import numpy as np

num_gen = 20

l_val = 1000
r_val = 3000
l_pos = 0
r_pos = 10000
dt = 100
dx = int(1000)

k = 4000

node_pos = np.arange(1, num_gen + 1)*dx

runsteps = 100

print(
    "`include \"node.v\"\n" +
    "`define ASSERT_EQ(val, exp, msg) \\ \n" +
    "if (val !== exp) $display(\"[FAIL] %s (got:0b%b expected:0b%b)\", msg, val, exp);"+
    "\n\n"+
    "module node_test();"
)

def indent(x):
    for i in x: print("    "+i)
def indent2(x):
    for i in x: print("        "+i)


indent(
    [
    "reg [31:0] left_endpt;",
        "reg [31:0] right_endpt;" ,
        "reg [31:0] set_val;",
        "reg [31:0] dt, kval;",
        "reg [2:0] command;",
        "reg clk;"
    ]
)
indent([f"wire [31:0] posx{i};" for i in range(num_gen)])
indent(
    ["reg[31:0] input_left;",
     "reg[31:0] input_right;"]
)
indent([f"wire[31:0] nodeval{i};" for i in range(num_gen)])
indent([f"reg[31:0] set_val{i};" for i in range(num_gen)])


for i in range(num_gen):
    if i==0 and i==num_gen-1:
        indent([f"node node{i}("+
                f".nodeval (nodeval{i})," +
                f".nodepos (posx{i})," +
                f".set_val (set_val{i})," +
                f".input1 (left_endpt)," +
                f".posx1 (input_left),"+
                f".input2 (right_endpt),"+
                f".posx2 (input_right),"+
                f".kval (kval),"+
                f".dt (dt),"+
                f".command(command),"+
                f".clk (clk)"+
                f");"
                ])
    elif i==0:
        indent([f"node node{i}("+
                f".nodeval (nodeval{i})," +
                f".nodepos (posx{i})," +
                f".set_val (set_val{i})," +
                f".input1 (left_endpt)," +
                f".posx1 (input_left),"+
                f".input2 (nodeval{i+1}),"+
                f".posx2 (posx{i+1}),"+
                f".kval (kval),"+
                f".dt (dt),"+
                f".command(command),"+
                f".clk (clk)"+
                f");"
                ])
    elif i==num_gen-1:
        indent([f"node node{i}("+
                f".nodeval (nodeval{i})," +
                f".nodepos (posx{i})," +
                f".set_val (set_val{i})," +
                f".input1 (nodeval{i-1})," +
                f".posx1 (posx{i-1}),"+
                f".input2 (right_endpt),"+
                f".posx2 (input_right),"+
                f".kval (kval),"+
                f".dt (dt),"+
                f".command(command),"+
                f".clk (clk)"+
                f");"
                ])
    else:
        indent([f"node node{i}("+
                f".nodeval (nodeval{i})," +
                f".nodepos (posx{i})," +
                f".set_val (set_val{i})," +
                f".input1 (nodeval{i-1})," +
                f".posx1 (posx{i-1}),"+
                f".input2 (nodeval{i+1}),"+
                f".posx2 (posx{i+1}),"+
                f".kval (kval),"+
                f".dt (dt),"+
                f".command(command),"+
                f".clk (clk)"+
                f");"
                ])

indent([
    "initial clk=0;",
    "always #10 clk = !clk;",
    "initial begin;"
])

indent2([
    f"command = `SET_NODE;"
])
indent2([
    f"set_val{i} = 32'd0;" for i in range(num_gen)
])
indent2(["@(posedge clk); #1;"])

indent2([
    f"command = `SET_POS;"
])
indent2([
    f"set_val{i} = 32'd{node_pos[i]};" for i in range(num_gen)
])
indent2(["@(posedge clk); #1;"])

indent2([
    f"left_endpt = 32'd{l_pos};",
    f"right_endpt = 32'd{r_pos};",
    f"input_left = 32'd{l_val};",
    f"input_right = 32'd{r_val};",
    f"dt=32'd{dt};",
    f"kval = 32'd{k};",
    "@(posedge clk); #1;",
    "command = `RUN;"
])
for i in range(runsteps):
    print("        @(posedge clk); #1;")
    str_prpnd = ""
    if i == 0:
        str_prpnd = "t_profile = ["

    str_end = ","
    if i == runsteps-1:
        str_end = "]"
    num_fmt_str = ("%d,"*num_gen)[:-1]
    print("        $display(\"{}[{}]{}\"".format(str_prpnd, num_fmt_str, str_end),end="")
    for i in range(num_gen):
        print(f", nodeval{i}", end="")
    print(");")

indent(["#1 $finish();"])

indent(["end"])

print("endmodule")
