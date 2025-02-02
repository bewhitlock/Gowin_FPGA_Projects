module initialize_tb ();
wire meg25;
wire sda;
wire scl;
wire pulse_send;
wire finished;
wire i2c_done;
wire[7:0] step;
wire ack;
reg meg_reg25;
assign meg25 = meg_reg25;

reg pulse;
assign pulse_send = pulse;

//reg sda_reg;
//assign sda = sda_reg;

initialize test (.scl(scl), .sda(sda), .meg25(meg25), .pulse_send(pulse_send), .initial_done(finished), .i2c_done_test(i2c_done), .step_test(step), .ack_test(ack));

reg [7:0] scl_count;
//always @(posedge scl) begin
    //scl_count <= scl_count + 1'b1;
    //if (scl_count == 8'd9 || scl_count == 8'd18 || scl_count == 8'd27) begin
        //sda_reg <= 1'b1;
        //#1000
        //sda_reg <= 1'bz;
    //end
    //if (scl_count == 8'd36) begin
        //sda_reg <= 1'b1;
        //#1000
        //sda_reg <= 1'bz;
        //scl_count <= 8'd0;
    //end
//end

initial begin
$dumpfile("test.vcd");
$dumpvars(0, sda, scl, pulse_send, finished, i2c_done, step, ack);
meg_reg25 = 1'b0;
pulse = 1'b0;
//sda_reg = 1'bz;
# 10 pulse = 1'b1;
# 10 pulse = 1'b0;
#300000;
$finish;
end

always begin
    #1 meg_reg25 = ~meg_reg25;
end
endmodule