module start_up_tb ();
wire meg25;
wire sda;
wire scl;
wire reset;
wire started;
wire pulse;
wire[3:0] step;

reg meg_reg25;
assign meg25 = meg_reg25;


start_up test (
    .scl(scl),
    .sda(sda),
    .meg25(meg25),
    .reset(reset),
    .started(started),
    .pulse_test(pulse),
    .step_test(step)

);

initial begin
$dumpfile("test.vcd");
$dumpvars(0, sda, scl, started, reset, pulse, step);
meg_reg25 = 1'b0;
#4000000;
$finish;
end

always begin
    #1 meg_reg25 = ~meg_reg25;
end
endmodule