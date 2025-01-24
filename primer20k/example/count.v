module count (
	input clk,
	output[3:0] value
);
reg[31:0] clk_count;
reg[3:0] val_reg = 4'd0;
assign value = ~val_reg;

always @(posedge clk) begin
	clk_count <= clk_count + 1'd1;
	if (clk_count == 32'd27000000) begin
		val_reg <= val_reg + 4'd1;
		clk_count <= 32'd0;
	end
end

endmodule
