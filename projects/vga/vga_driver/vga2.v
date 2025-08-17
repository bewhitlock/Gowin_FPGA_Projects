module vga (
input board_clock, //**change this in cst file**
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
buffer[320][240] = 9'b111111111;
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

reg[9:0] x;
reg[9:0] y;

reg [8:0] buffer [639:0] [479:0]; //buffer that fits 1 frame of 3 bits per color
//   ^^^colors     ^^^x    ^^^y 
//colors formatted like this-->          MSB << bbbgggrrr >> LSB

always @(posedge clk) begin // clk is the dot clock for vga timing at 25.2 Mhz

//increment counters every clock cycle. 
//counts left to right, top to bottom for h_total_pix by v_total_pix
///////////////////////////////////////////////////////////////////////////
    if(h_count < h_total_pix) begin
        h_count = h_count + 1'b1;
    end else begin //end of line, reset and increment v_count
        h_count = 10'd0;
        if (v_count < v_total_pix) begin
            v_count = v_count + 1'b1;
        end else begin
            v_count = 10'd0;
        end
    end
///////////////////////////////////////////////////////////////////////////

//takes care of v-sync and h-sync. Both are active low.
//both are pulsed at the beginning of the count.
///////////////////////////////////////////////////////////////////////////
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
///////////////////////////////////////////////////////////////////////////

//creates easy values for x and y. in cartesian coordinates.
//sets x/y to 640/480. OR them together for an out of visible area flag.
///////////////////////////////////////////////////////////////////////////
    if((h_count - h_back_porch - h_sync_pulse) < h_visible_area) begin
        x <= (h_count - h_back_porch - h_sync_pulse);
    end else begin
        x <= 10'd640; //out of visible area
    end

    if((v_count - v_back_porch - v_sync_pulse) < v_visible_area) begin
       y <= (10'd480 - (v_count - v_back_porch - v_sync_pulse));
    end else begin
       y <= 10'd480; //out of display area
    end
///////////////////////////////////////////////////////////////////////////

//display code. Prints whatever is in the frame buffer and
//sets colors to 0 if counters are out of display area.
///////////////////////////////////////////////////////////////////////////
    if(x < 10'd640 && y < 10'd480) begin 
        red <= buffer[x][y][2:0]; // check the 2d matrix(buffer) for strength of each color
        green <= buffer[x][y][5:3]; // 2:0 for red, 5:3 for green, 8:6 for blue. MSB
        blue <= buffer[x][y][8:6];
    end else begin
        red <= 3'b000;
        green <= 3'b000;
        blue <= 3'b000;
    end
///////////////////////////////////////////////////////////////////////////
end //@posdege clk
endmodule
///////////////////////////////////////////////////////////////////////////

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
///////////////////////////////////////////////////////////////////////////
module barnsley_factory(
    input clk,
    input v_porch_flag,
    output [8:0] pixel_color,
    output [10:0] x,
    output [10:0] y
);
register 
always @(posedge v_porch_flag) begin
end //posedge v_porch_flag

always @(posedge clk) begin
    
end //posedge clk


endmodule
