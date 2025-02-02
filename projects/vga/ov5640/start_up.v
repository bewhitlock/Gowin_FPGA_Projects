module start_up (
    output[3:0] step_test,
    output pulse_test, //for testing
    output reset,
    output started,
    output scl,
    inout sda,
    input meg25
); 
assign step_test = step;
assign pulse_test = pulse; //for testing
reg[19:0] clk_count; //intermediary registers
reg[3:0] step;

reg resetb; //output registers + assignments
assign reset = resetb;
reg power_on;
assign started = power_on;

wire pulse_send; //instantiation wires + regs
reg pulse;
assign pulse_send = pulse;
wire initialized;

initialize mod1 (
    .pulse_send(pulse_send),
    .sda(sda),
    .scl(scl),
    .initial_done(initialized)
);

initial begin
    step = 4'd0;
    clk_count = 20'd0;
    resetb = 1'b0;
    pulse = 1'b0; //create
    power_on = 1'b0;
end


always @(posedge meg25) begin
    case(step)
    4'd0: begin
        if(clk_count < 20'd50000) begin //2 ms
            clk_count <= clk_count + 1'b1;
            resetb <= 1'b0;
        end else begin
            resetb <= 1'bz; //physical pullup resistor
            step <= 4'd1;
            clk_count <= 20'd0;
        end
    end
    4'd1: begin
        if(clk_count < 20'd525000) begin //21 ms
            clk_count = clk_count + 1'b1;
        end else begin;
            step <= 4'd2;
            clk_count <= 20'd0;
        end
    end
    4'd2: begin
        if(clk_count < 20'd5) begin //200 ns
            clk_count = clk_count + 1'b1;
            pulse <= 1'b1;
        end else begin
            pulse <= 1'b0; //create
            step <= 4'd3;
            clk_count <= 20'd0;
        end 
    end
    4'd3: begin 
        if(initialized) begin
            power_on <= 1'b1;
        end
    end
    endcase
end

endmodule