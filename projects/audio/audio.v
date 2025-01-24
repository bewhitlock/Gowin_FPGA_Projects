module dac_driver(
input clk,
output din, //data in. Accepts the first 16 bits of data as 2's compliment
output bck, //clk that can run up to 20megs for the sample freq.
output ws, //ws is low when we send data to the RIGHT channel+vice-versa.
output amp_shutdown
);
assign amp_shutdown = 1'b1; //Shutdown is active-low
reg din_reg;
reg ws_reg;
reg bck_reg;

reg[31:0] data;
reg[7:0] bit_count;
reg [23:0] cycle_count;
always @(posedge clk) begin
	bck_reg = !bck_reg;
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