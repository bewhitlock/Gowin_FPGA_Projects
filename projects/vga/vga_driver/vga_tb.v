module vga_tb ();
reg clk;
wire hsync;
wire vsync;
wire[7:0] red;
wire[7:0] green;
wire[7:0] blue;
wire[9:0] x_val;
wire[9:0] y_val;
wire[11:0] h_count;
wire[11:0] v_count;

vga test_vga (.board_clock(clk), .hsync(hsync), .vsync(vsync), .red(red), .green(green), .blue(blue), .x_val(x_val), .y_val(y_val), .h_count_test(h_count), .v_count_test(v_count));




initial begin
    clk = 1'b0;
end
initial begin
    $dumpfile("vga_test.vcd");
    $dumpvars(0, clk, hsync, vsync, x_val, v_count, h_count, y_val, red, green, blue);
end

always begin
    #1 clk = !clk;
end

initial begin
    #1000000;
    $finish;
end
endmodule