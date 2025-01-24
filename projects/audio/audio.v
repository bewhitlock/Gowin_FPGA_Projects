module dac_driver(
input clk,
output din,
output bck,
output ws,
output amp_shutdown
);
assign amp_shutdown = 1'b1;
reg din_reg;
reg ws_reg;
reg bck_reg;

reg clk_count;
reg[31:0] data;
reg[7:0] bit_count;
reg [23:0] cycle_count;
always @(posedge clk) begin
	if (clk_count == 1'b0) begin
		bck_reg <= 1'b1;
		clk_count <= 1'b1;
	end else begin
		bck_reg <= 1'b0; 
		clk_count <= 1'b0;
	end
end 

always @(posedge bck_reg) begin //take care of ws signal


	if(cycle_count < 5000) begin
	
		data = 24'd8384512;
		
		if (bit_count < 8'd31) begin
		bit_count = bit_count + 1'b1;
			if (bit_count > 8'd15) begin
				ws_reg <= 1'b1;
			end
		end else begin
			bit_count <= 8'd0;
			ws_reg <= 1'b0;
			cycle_count <= cycle_count+1'b1;
		end
		
	end else begin
		if(cycle_count == 10000) begin
			cycle_count <= 24'd0;
		end else begin
			data <= 24'd2047;
			if (bit_count < 8'd31) begin
				bit_count = bit_count + 1'b1;
				if (bit_count > 8'd15) begin
					ws_reg <= 1'b1;
				end
			end else begin
				bit_count <= 8'd0;
				ws_reg <= 1'b0;
				cycle_count <= cycle_count+1'b1;
			end
		end
	end
	
	
end

always @(negedge bck_reg) begin
	din_reg <= data[bit_count];
end

assign ws = ws_reg;
assign bck = bck_reg;
assign din = din_reg;
endmodule