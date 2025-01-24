module rgb_drive (
input clk,
output ws2812
);

reg[3:0] state;
reg out;
reg[7:0] count;
reg[23:0] color;
reg[4:0] send_count;
parameter reset = 4'd0;
parameter sendh = 4'd1;
parameter sendl = 4'd2;
parameter sendit = 4'd3;
parameter reset_num = 16'd99;

parameter t0h = 8'd9;
parameter t0l = 8'd22;

parameter t1h = 8'd19;
parameter t1l = 8'd16;

initial begin
	state = 4'd0;
	count = 8'd0;
	color = 24'b111111111111111111111111;
	send_count = 5'd0;
end
	always @(posedge clk) begin
		case(state)
			reset: begin
				if (count < reset_num) begin
				out <= 1'b0;
				count = count + 1'b1;
				end else begin
					count <= 8'd0;
					state <= sendit;
				end

			end

			sendit: begin
				if (send_count < 5'd24) begin
					if (color[send_count] == 1'b1) begin
						state <= sendh;
					end else begin
						state <= sendl;
					end
					send_count <= send_count + 1'b1;
				end else begin
					send_count <= 5'd0;
					state <= reset; //add change color flag after this line
				end
			end

			sendl: begin
				if (count < t0h) begin
				end else begin
					if (count < (t0h + t0l)) begin
					end else begin
						count <= 8'd0;
						state <= sendit;
					end
				end
			end

			sendh: begin
				if (count < t1h) begin

				end else begin
					if (count < (t1h + t1l)) begin
					end else begin
						count <= 8'd0;
						state <= sendit;
					end
				end
			end
		endcase
	end
endmodule