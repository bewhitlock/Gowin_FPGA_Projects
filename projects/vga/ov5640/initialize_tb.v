module initialize_tb ();
wire meg25;
wire sda;
wire scl;
reg meg_reg25;

assign meg25 = meg_reg25;
initialize test (.scl(scl), .sda(sda), .meg25(meg25));



initial begin
$dumpfile("test.vcd");
$dumpvars(0, sda, scl);
meg_reg25 = 1'b0;
#25000;
$finish;
end

always begin
    #1 meg_reg25 = ~meg_reg25;
end
endmodule