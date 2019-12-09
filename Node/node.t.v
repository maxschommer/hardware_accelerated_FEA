`include "node.v"


// Uncomment the `define below to enable dumping waveform traces for debugging
//`define DUMP_WAVEFORM

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);


module node_test ();
	reg [31:0] left_endpt;
	reg [31:0] right_endpt;
	reg [31:0] set_val;
	reg [31:0] dt, kval;
	reg [2:0] command;
	reg clk;

	reg [31:0] posx1, posx2, posx3;

	reg[31:0] posx1_1, posx1_3;
	wire[31:0] nodeval1, nodeval2, nodeval3;
	wire[31:0] posx_1_val;

	// Left, first node
	node DUT1(.nodeval 	(nodeval1),
			.nodepos 	(posx_1_val),
			.set_val 	(set_val),
			.input1 	(left_endpt),
			.posx1  	(posx1_1),
			.input2 	(right_endpt),
			.posx2  	(posx1_3), // Position of middle node
			.kval   	(kval),
			.dt     	(dt),
			.command 	(command),
			.clk    	(clk));

	// // Middle node
	// node DUT2(.nodeval 	(nodeval2),
	// 		.nodepos 	(posx2),
	// 		.input1 	(nodeval1), 
	// 		.posx1  	(posx1),
	// 		.input2 	(nodeval3),
	// 		.posx2  	(posx3),
	// 		.kval   	(kval),
	// 		.dt     	(dt),
	// 		.clk    	(clk));

	// // Right, last node
	// node DUT3(.nodeval 	(nodeval3),
	// 		.nodepos 	(posx3),
	// 		.input1 	(nodeval2),  // 
	// 		.posx1  	(posx2), // Position of node to the left
	// 		.input2 	(right_endpt), // The right boundary
	// 		.posx2  	(posx1_3),
	// 		.kval   	(kval),
	// 		.dt     	(dt),
	// 		.clk    	(clk));

	// Generate (infinite) clock
	initial clk=0;
	always #10 clk = !clk;


	initial begin
	 	    // Optionally dump waveform traces for debugging
	    `ifdef DUMP_WAVEFORM
	      $dumpfile("alu.vcd");
	      $dumpvars();
	    `endif

	    command = `SET_NODE; set_val = 32'd1000; 
	    @(posedge clk); #1 
	    $display("Node Value: ", nodeval1);

	   	command = `SET_POS; set_val = 32'd100; 
	    @(posedge clk); #1 
	    $display("Node Position: ", posx_1_val);

		posx1_1 = 32'd0; posx1_3 = 32'd200;
		kval = 32'd100; dt = 32'd10;
		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);
		
		command = `RUN; left_endpt = 32'd1000; right_endpt = 32'd3000;
		$display("Running Simulation");
		$display("Left Endpoint: ",left_endpt, ", Right Endpoint: ", right_endpt, ", Node Value: ", nodeval1);
		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);

		@(posedge clk); #1 
		$display("Node Value: ", nodeval1);



	    #1 $finish();
	end

endmodule