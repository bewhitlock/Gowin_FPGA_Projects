module start_up (
    output reset,
    output started,
    output scl,
    inout sda,
    input meg25
); 
reg[19:0] clk_count;
reg[3:0] step;

reg resetb;
assign reset = resetb;

reg power_on;
assign started = power_on;

initial begin
    step = 4'd0;
    clk_count = 20'd0;
    resetb = 1'b0;
    pulse = 1'b0; //create
end




always @(posedge meg25) begin
    if(~power_on) begin
        case(step)
        4'd0: begin
            if(clk_count < 20'd50000) begin //2 ms
                clk_count <= clk_count + 1'b1;
                resetb <= 1'b0;
            end else begin
                clk_count <= 20'd0;
                resetb <= 1'bz; //physical pullup resistor
            end
        end
        4'd1: begin
            if(clk_count < 20'd525000) begin //21 ms
                clk_count <= clk_count + 1'b1;
            end else begin
                clk_count <= 20'd0;
                pulse <= 1'b1; //create
                step <= 4'd2;
            end
        end
        4'd2: begin
            if(clk_count < 20'd5) begin //200 ns
                clk_count <= clk_count + 1'b1;
            end else begin
                clk_count <= 20'd0;
                pulse <= 1'b0; //create
                step <= 4'd3;
            end 
        end
        4'd3: begin 
            if(initialized) begin
                power_on <= 1'b1;
            end
        end
        endcase
    end
end

endmodule