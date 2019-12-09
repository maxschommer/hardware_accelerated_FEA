`include "node.v"


// Uncomment the `define below to enable dumping waveform traces for debugging
//`define DUMP_WAVEFORM

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);


module node_test ();
	reg [31:0] left_endpt;
	reg [31:0] right_endpt;
	reg [31:0] dt, kval;
	reg clk;

	reg [31:0] posx1, posx2, posx3;

	wire[31:0] posx1_1, posx1_3;

	// Left, first node
	node DUT1(.nodeval 	(nodeval1),
			.nodepos 	(posx1),
			.input1 	(left_endpt),
			.posx1  	(posx1_1),
			.input2 	(nodeval2),
			.posx2  	(posx2), // Position of middle node
			.kval   	(kval),
			.dt     	(dt),
			.clk    	(clk));

	// Middle node
	node DUT2(.nodeval 	(nodeval2),
			.nodepos 	(posx2),
			.input1 	(nodeval1), 
			.posx1  	(posx1),
			.input2 	(nodeval3),
			.posx2  	(posx3),
			.kval   	(kval),
			.dt     	(dt),
			.clk    	(clk));

	// Right, last node
	node DUT3(.nodeval 	(nodeval3),
			.nodepos 	(posx3),
			.input1 	(nodeval2),  // 
			.posx1  	(posx2), // Position of node to the left
			.input2 	(right_endpt), // The right boundary
			.posx2  	(posx1_3),
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