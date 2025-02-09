module dot_clock_gen (
    input board, 
    output reg dotclock
);
wire clk252;
reg[3:0] clk_count;

Gowin_rPLL252 your_instance_name(
        .clkout(clk252), //output clkout
        .clkin(board) //input clkin
    );

always @(posedge clk252) begin

    if(clk_count < 4'd4) begin
        clk_count <= clk_count + 1'b1;
    end else begin
        clk_count <= 4'd0;
        dotclock <= !dotclock;
    end

end

endmodule