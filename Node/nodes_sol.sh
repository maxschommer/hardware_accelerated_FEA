python3 gen_nodes.py > nodetest.t.v
iverilog -o nodes nodetest.t.v 
./nodes > res.py
rm nodes nodetest.t.v
python3 plot_hardware_soln.py