module dot_clock_gen (
    input board, 
    output dotclock 
);
reg dotclk;
assign dotclock = dotclk;

always @(posedge board) begin
    dotclk <= !dotclk;
end 
endmodule