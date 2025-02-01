module i2c_tb ();

wire meg25;
wire sda;
wire scl;
wire[23:0] send_dat;
wire [6:0] send_count;
reg sendit;
reg meg_reg25;
assign meg25 = meg_reg25;
assign send_dat = 24'd16777215;
i2c dude (.scl(scl), .sda(sda), .meg25(meg25), .send_dat(send_dat), .sendit(sendit), .send_count_out(send_count));

initial begin
$dumpfile("test.vcd");
$dumpvars(0, sda, scl, sendit, send_count);
meg_reg25 = 1'b0;
#10 sendit = 1'b1;
#15000;
$finish;
end

always begin
    #1 meg_reg25 = ~meg_reg25;
end
endmodule