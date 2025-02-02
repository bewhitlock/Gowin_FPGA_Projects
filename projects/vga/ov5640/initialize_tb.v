module initialize_tb ();
wire meg25;
wire sda;
wire scl;
wire pulse_send;
wire finished;
wire i2c_done;
wire[7:0] step;
reg meg_reg25;
assign meg25 = meg_reg25;

reg pulse;
assign pulse_send = pulse;
initialize test (.scl(scl), .sda(sda), .meg25(meg25), .pulse_send(pulse_send), .initial_done(finished), .i2c_done_test(i2c_done), .step_test(step));



initial begin
$dumpfile("test.vcd");
$dumpvars(0, sda, scl, pulse_send, finished, i2c_done, step);
meg_reg25 = 1'b0;
pulse = 1'b0;
# 10 pulse = 1'b1;
# 10 pulse = 1'b0;
#300000;
$finish;
end

always begin
    #1 meg_reg25 = ~meg_reg25;
end
endmodule