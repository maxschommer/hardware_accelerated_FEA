`define WR_PROTECT 3'd0
`define SET_NODE 3'd1
`define SET_POS  3'd2


module node
    (
        output[31:0]    nodeval,
        output[31:0]    nodepos,
        input[31:0]     set_val,
        input[31:0]     input1,
        input[31:0]     posx1,
        input[31:0]     input2,
        input[31:0]     posx2,
        input[31:0]     kval,
        input[31:0]     dt,
        input[2:0]      command,
        input           clk
    );

    reg[31:0] node_val_reg;
    reg[31:0] node_pos_reg;

    reg[31:0] dx;
    reg[31:0] time_spatial_const;
    reg[31:0] abs_dx;

    assign nodeval = node_val_reg;
    assign nodepos = node_pos_reg;

    always @* begin
        dx <= node_pos_reg - posx2;
        // Absolute value of dx
        if (dx[31] == 1'b1) begin
            abs_dx <= -dx;
        end
        else begin
            abs_dx <= dx;
        end
    end

    always @(posedge clk) begin
        case (command)
            `SET_NODE:  begin   node_val_reg <= set_val; end
            `SET_POS:   begin   node_pos_reg <= set_val; end
            default : /* default */;
        endcase
    end

    // Note, this assumes the same spatial constant for
    // left and right nodes. separate spatial constants are
    // supported, but implementation of the convolution will need
    // to be modified. 
    always @* begin
        time_spatial_const <= kval*dt/(dx*dx);
    end

    always @(posedge clk) begin
        node_val_reg <= time_spatial_const*(input1 - 2*nodeval + input2);
    end
endmodule
