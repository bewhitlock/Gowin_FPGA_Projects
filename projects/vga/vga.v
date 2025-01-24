module vga (
input clk27Mhz,
output hsync_nonreg,
output vsync_nonreg,
output[2:0] red,
output[2:0] green,
output[2:0] blue
);


initial begin
    hsync = 1'b0;
    vsync = 1'b0;
	r = 3'b011;
    g = 3'b000;
    b = 3'b000;

	vcount = 32'd0;
	hcount = 32'd0;
	video_state = 1'b0;
end



wire dotclk;
dot_clock_gen dotclock1 ( .Mhz27(clk27Mhz), .dotclock(dotclk) ); //25.2Mhz clock

reg[31:0] hcount;
reg[31:0] vcount;
reg video_state;
reg vsync;
assign vsync_nonreg = vsync;
reg hsync;
assign hsync_nonreg = hsync;
reg[2:0] r;
assign red = r;
reg[2:0] g;
assign green = g;
reg[2:0] b;
assign blue = b;

always @(posedge dotclk) begin //counting generator


	if (hcount == 799) begin
	hcount <= 32'd0;
		if (vcount < 479) begin
			vcount <= vcount + 1'b1;
		end else begin
			vcount <= 32'd0;
		end
	end else begin
	hcount <= hcount + 1'b1;
	end // end counting whole display
	
	
	if ( (702 < hcount) | (476 < vcount) ) begin
		if ( (702 < hcount) & (476 < vcount) ) begin //check for both h and vsync first
			vsync <= 1'b0;
			hsync <= 1'b0;
		end else if (702 < hcount) begin //check for hsync
			vsync <= 1'b1;
			hsync <= 1'b0;
		end else begin //check for vsync
			vsync <= 1'b0;
			hsync <= 1'b1;
		end // end neither event
	end else begin//end syncing period event
		vsync <= 1'b1;
		hsync <= 1'b1;
	end //end display area event
	
	if ( (47 < hcount < 688) & (32 < vcount < 512 ) ) begin
		video_state <= 1'b1;
	end else begin
		video_state <= 1'b0;
	end //end display time event
	
	
end

always @(posedge dotclk) begin // video generator
    if (video_state == 1'b1) begin
        r <= 3'd7;
        g <= 3'd7;
        b <= 3'd7;
    end else begin
        r <= 3'd0;
        g <= 3'd0;
        b <= 3'd0;
    end
end
endmodule