module vga (
input board_clock, //**change this in cst file
output reg hsync,
output reg vsync,
output reg[7:0] red,
output reg[7:0] green,
output reg[7:0] blue
);

wire clk;
dot_clock_gen dotclk (.Mhz27(board_clock), .dotclock(clk));


initial begin
red = 8'b11111111;
green = 8'b11111111;
blue = 8'b11111111;
vsync = 1'b1;
hsync = 1'b1;
end


///////////////////////////////////////////////////////////////////////////

//horizontal parameters
parameter h_total_pix = 800; //total pixel count
parameter h_front_porch = 16;
parameter h_back_porch = 48;
parameter h_sync_pulse = 96; //h-sync pulse length
parameter h_visible_area = 640;
//vertical parameters
parameter v_total_pix = 525; //total line count 
parameter v_front_porch = 10;
parameter v_back_porch = 33;
parameter v_sync_pulse = 2; //v-sync pulse length
parameter v_visible_area = 480;

///////////////////////////////////////////////////////////////////////////

reg[11:0] h_count;
reg[11:0] v_count; 

always @(posedge clk) begin

    if(h_count < h_total_pix) begin
        h_count <= h_count + 1'b1;
    end else begin
        h_count <= 12'd0;
        if (v_count < v_total_pix) begin
            v_count <= v_count + 1'b1;
        end else begin
            v_count = 12'd0;
        end
    end

    if(h_sync_pulse > h_count) begin
        hsync <= 1'b0;
    end else begin
        hsync <= 1'b1;
    end


    if(v_sync_pulse > v_count) begin
        vsync <= 1'b0;
    end else begin
        vsync <= 1'b1;
    end

end

endmodule