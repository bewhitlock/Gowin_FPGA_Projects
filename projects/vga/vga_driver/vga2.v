module vga (
input board_clock, //**change this in cst file
output reg hsync,
output reg vsync,
//output clk_test
output reg[2:0] red,
output reg[2:0] green,
output reg[2:0] blue
//output reg[9:0] x_val,
//output reg[9:0] y_val,

//temporary testing outputs
//output[11:0] v_count_test,
//output[11:0] h_count_test
);

//temporary testing things
//assign h_count_test = h_count;
//assign v_count_test = v_count;
//assign clk_test = clk;

wire[7:0] rand;
dot_clock_gen dotclk (.board(board_clock), .dotclock(clk));
random name (.clk(clk), .rand(rand));




initial begin
red = 3'b111;
green = 3'b111;
blue = 3'b111;
vsync = 1'b1;
hsync = 1'b1;
h_count = 10'd0;
v_count = 10'd0;
end


///////////////////////////////////////////////////////////////////////////

//horizontal parameters
parameter h_total_pix = 10'd800; //total pixel count
parameter h_front_porch = 10'd16;
parameter h_back_porch = 10'd48;
parameter h_sync_pulse = 10'd96; //h-sync pulse length
parameter h_visible_area = 10'd640;
//vertical parameters
parameter v_total_pix = 10'd525; //total line count 
parameter v_front_porch = 10'd10;
parameter v_back_porch = 10'd33;
parameter v_sync_pulse = 10'd2; //v-sync pulse length
parameter v_visible_area = 10'd480;

///////////////////////////////////////////////////////////////////////////

reg[9:0] h_count;
reg[9:0] v_count;

reg[9:0] x_val; //cartesian
reg[9:0] y_val; //inverse cartesian

wire[9:0] x=x_val;//cartesian
reg[9:0] y; //cartesian


reg[8:0] frame;

always @(posedge clk) begin

    red <= 3'b000;
    green <= 3'b000;
    blue <= 3'b000;

    if(h_count < h_total_pix) begin
        h_count = h_count + 1'b1;
    end else begin
        h_count = 10'd0;
        if (v_count < v_total_pix) begin
            v_count = v_count + 1'b1;
        end else begin
            v_count = 10'd0;
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


    if((h_count - h_back_porch - h_sync_pulse) < h_visible_area) begin
        x_val <= (h_count - h_back_porch - h_sync_pulse);
    end else begin
        x_val <= 10'd640; //out of display area
    end

    if((v_count - v_back_porch - v_sync_pulse) < v_visible_area) begin
       y_val <= (v_count - v_back_porch - v_sync_pulse);
    end else begin
       y_val <= 10'd480; //out of display area
    end
    
    
    if(x_val < 10'd640 && y_val < 10'd480) begin
    y <= (10'd480-y_val);
///////////////////////////////////////////////////////////////////////////////
        red <= (rand % 8);
        green <= (rand % 8);
        blue <= (rand % 8);
///////////////////////////////////////////////////////////////////////////////
    end else begin
        red <= 3'b000;
        green <= 3'b000;
        blue <= 3'b000;
    end
end

endmodule

//pseudorandom number generator
module random (
    input clk,
    output reg[7:0] rand
);
initial begin
    rand <= 8'b11001101;
end
always @(negedge clk) begin
    rand <= {rand[5:1], rand[6] ^ rand[7], rand[0], rand[6]};
end

endmodule
