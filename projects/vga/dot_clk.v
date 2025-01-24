module dot_clock_gen (
    input Mhz27, 
    output dotclock 
);
reg dotclk;
assign dotclock = dotclk;

always @(posedge Mhz27) begin
    dotclk <= !dotclk;
end 
endmodule