
module node
    (
        output[31:0]    nodeval,
        output[31:0]    nodepos,
        input[31:0]     input1,
        input[31:0]     posx1,
        input[31:0]     input2,
        input[31:0]     posx2,
        input[31:0]     kval,
        input[31:0]     dt,
        input[2:0]      command
        input           clk
    );

    reg[31:0] node_val_reg;
    reg[31:0] node_pos_reg;

    reg[31:0] dx;
    reg[31:0] time_spatial_const;
    reg[31:0] abs_dx;

    always @* begin
        dx <= posx1 - posx2;
        // Absolute value of dx
        if (dx[31] == 1'b1) begin
            abs_dx <= -dx;
        end
        else begin
            abs_dx <= dx;
        end
    end

    always @* begin
        time_spatial_const <= kval*dt/(dx*dx);
    end

    always @(posedge clk) begin
        nodeval <= time_spatial_const*(input1 - 2*nodeval + input2);
    end
endmodule
