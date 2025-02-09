module dot_clock_gen (
    input board, 
    output reg dotclock
);
wire clk200;
reg[3:0] clk_count;

Gowin_rPLL PLL200( 
                .clkout(clk200), //output clkout 
                .clkin(board) //input clkin
                );

always @(posedge clk200) begin

    if(clk_count < 4'd3) begin
        clk_count <= clk_count + 1'b1;
    end else begin
        clk_count <= 4'd0;
        dotclock <= !dotclock;
    end

end

endmodule