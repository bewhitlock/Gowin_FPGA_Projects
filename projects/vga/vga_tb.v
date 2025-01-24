module vga_tb ();
reg clk; //make all io ports to interface with the module under test
wire hsync;
wire vsync;
wire[2:0] red;
wire[2:0] green;
wire[2:0] blue;


vga test_vga (.clk27Mhz(clk), .hsync_nonreg(hsync), .vsync_nonreg(vsync), .red(red), .green(green), .blue(blue));
//connect the test bench to the module under test



initial begin
    clk = 1'b0;
end
initial begin
    $dumpfile("vga_test.vcd");  // Define the name of the waveform file
    $dumpvars(0, clk, hsync, vsync, red, green, blue);    // Dump all signals in the testbench hierarchy
end

always begin
    #1 clk = !clk; //alternate the clock forever
end

initial begin
    #10000;
    $finish;
end
endmodule