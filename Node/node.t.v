`include "node.v"


// Uncomment the `define below to enable dumping waveform traces for debugging
//`define DUMP_WAVEFORM

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);


module node_test ();

	// Left, first node
	node DUT1(.nodeval 	(nodeval1),
			.nodepos 	(nodepos1),
			.input1 	(input1),
			.posx1  	(posx1),
			.input2 	(input2),
			.posx2  	(posx2),
			.kval   	(kval),
			.dt     	(dt),
			.clk    	(clk));

	// Middle node
	node DUT2(.nodeval 	(nodeval2),
			.nodepos 	(nodepos2),
			.input1 	(input1),
			.posx1  	(posx1),
			.input2 	(input2),
			.posx2  	(posx2),
			.kval   	(kval),
			.dt     	(dt),
			.clk    	(clk));

	// Right, last node
	node DUT3(.nodeval 	(nodeval3),
			.nodepos 	(nodepos3),
			.input1 	(input1),
			.posx1  	(posx1),
			.input2 	(input2),
			.posx2  	(posx2),
			.kval   	(kval),
			.dt     	(dt),
			.clk    	(clk));
	

	 initial begin
	 	    // Optionally dump waveform traces for debugging
	    `ifdef DUMP_WAVEFORM
	      $dumpfile("alu.vcd");
	      $dumpvars();
	    `endif


	 end

endmodule