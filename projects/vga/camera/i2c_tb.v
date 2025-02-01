module i2c_tb ();

wire done;
wire meg25;
wire sda;
wire scl;
wire ack;
wire[23:0] send_dat;
wire [6:0] send_count;
reg sendit;
reg meg_reg25;
assign meg25 = meg_reg25;
assign send_dat = 24'b111111111111111111111111;
i2c dude (.scl(scl), .sda(sda), .meg25(meg25), .send_dat(send_dat), .sendit(sendit), .send_count_out(send_count), .ack(ack), .done(done));

initial begin
$dumpfile("test.vcd");
$dumpvars(0, sda, scl, sendit, send_count, ack, done);
meg_reg25 = 1'b0;
sendit = 1'b0;
#2000 sendit = 1'b1;
#25000;
$finish;
end

always begin
    #1 meg_reg25 = ~meg_reg25;
end

always @(done) begin
    if(done) begin
        sendit = 1'b0;
    end else begin
        #2000 sendit = 1'b1;
    end
end
endmodule