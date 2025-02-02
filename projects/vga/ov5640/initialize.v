///////////////////////////////////////////////////////
//Registers to write / research from datasheet:
//AHHHHHHHHHHHHHHHHHHHHHHHHH
//
//
//
//
//
//
//
//
//
//
////////////////////////////////////////////////////////











module initialize (
    input meg25,
    input pulse_send,
    input reset,
    inout sda,
    output scl,
    output initial_done,
    output i2c_done_test,
    output[7:0] step_test,
    output ack_test
);
wire ack; //i2c failed sending bytes
wire i2c_done; //i2c finished sending bytes
wire[23:0] send_dat;
wire sendit;

assign i2c_done_test = i2c_done; //for testing
assign step_test = step; //for testing
assign ack_test = ack;
reg[23:0] dat;
assign send_dat = dat;

reg send_i2c;
assign sendit = send_i2c;

reg initialized;
assign initial_done = initialized;
reg send;
reg[7:0] step;

initial begin
    initialized = 1'b0;
    send = 1'b0;
    step = 8'd0;
    send_i2c = 1'b0;
    dat = 24'd0;
end

i2c bruh (
            .meg25(meg25),
            .reset(reset),
            .sda(sda),
            .scl(scl),
            .ack(ack),
            .done(i2c_done),
            .send_dat(send_dat),
            .sendit(sendit)
);

always @(posedge ack) begin //check ack cases ****************************************
    send <= 1'b1;
    initialized <= 1'b0;
    step <= 8'd0;
end

always @(posedge i2c_done) begin
    if(step == 8'd1) begin
        send <= 1'b0;
        initialized <= 1'b1;
        send_i2c <= 1'b0; //sets sda, and scl high
    end
    step <= step + 1'b1;
end

always @(posedge meg25) begin
    if(pulse_send) begin
        send <= 1'b1;
        initialized <= 1'b0;
    end
    if(send) begin
        case (step)
            8'd0: dat <= 24'h83;
            8'd1: dat <= 24'b000000000000000000000000;
        endcase
        send_i2c <= 1'b1;
    end
end
endmodule

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

module i2c (
    input meg25, // 25MHz
    input[23:0] send_dat,
    input sendit,
    input reset,
    inout sda,
    output scl,
    output ack, //1 when byte send unsuccesful
    output done,
    output [6:0] send_count_out
);
parameter i2c_address = 7'h78; //0x78 for write address
reg done_reg;
reg ack_reg;
reg sda_clk; // put data out on posedge of this
reg scl_clk; //pulses in between sda_clk
reg[5:0] send_count;
reg sda_reg;
reg scl_reg;
reg ack_clk;
assign sda = sda_reg? 1'bz : 1'b0; //pullup on resistor, change z to 1 to test
assign scl = ( (6'd4 > send_count) | (send_count > 6'd39) )?scl_reg:scl_clk;
assign done = done_reg;
assign ack = ack_reg;
initial begin
    sda_clk = 1'b0;
    scl_clk = 1'b0;
    clk_count = 7'd0;
    send_count = 6'd0;
    done_reg = 1'b0;
    sda_reg = 1'b1;
    scl_reg = 1'b1;
    ack_reg = 1'b0;
    ack_clk = 1'b0;
end
assign send_count_out = send_count; //for testing
reg[6:0] clk_count;
always @(posedge meg25) begin //create main timing
    if(clk_count < 7'd125) begin
     clk_count = clk_count + 1'b1;
    end else begin
        clk_count = 7'd0;
    end
    if(clk_count == 7'd62) begin
        sda_clk <= 1'b1;
    end
    if(clk_count == 7'd72) begin
       scl_clk <= 1'b1;
    end
    if(clk_count == 7'd83) begin
        ack_clk <= 1'b1;
    end
    if(clk_count == 7'd104) begin
        ack_clk <= 1'b0;
    end
    if(clk_count == 7'd115) begin
        scl_clk <= 1'b0;
    end
    if(clk_count == 7'd0) begin
        sda_clk <= 1'b0; 
    end
end
always @(posedge ack_clk or negedge ack_clk) begin
    if ( (send_count == (6'd12)) || (send_count == (6'd21)) || (send_count == (6'd30)) || (send_count == (6'd39))) begin
        ack_reg <= (ack_reg || sda); 
    end
end
always @(posedge reset) begin
    ack_reg <= 1'b0;
end
always @(negedge sda_clk) begin
    if(sendit) begin
        if (send_count < 6'd43) begin
            send_count <= send_count + 1'b1;
        end else begin
            send_count <= 6'd0;
        end
    end
end
always @(posedge sda_clk or posedge reset) begin
    if(reset) begin
        send_count <= 6'd0;
    end else begin
        if(sendit) begin
            case(send_count)
                0: begin
                    ack_reg <= 1'b0;
                    sda_reg <= 1'b1;
                    scl_reg <= 1'b1;
                    done_reg = 1'b0;
                end
                1: begin
                    sda_reg <= 1'b0;
                    scl_reg <= 1'b1;
                end
                2: begin
                    sda_reg <= 1'b0;
                    scl_reg <= 1'b0;
                end
                3: begin
                    sda_reg <= 1'b0;
                    scl_reg <= 1'b0;
                end
                4:sda_reg <= i2c_address[6];
                5:sda_reg <= i2c_address[5];
                6:sda_reg <= i2c_address[4];
                7:sda_reg <= i2c_address[3];
                8:sda_reg <= i2c_address[2];
                9:sda_reg <= i2c_address[1];
                10:sda_reg <= i2c_address[0];
                11:sda_reg <= 1'b0; // r/w bit
                //12:sda_reg <= 1'b1; //1 for z uncomment for synthesis
                12:sda_reg <= 1'b0; //comment out for synthesis
                13:sda_reg <= send_dat[23];
                14:sda_reg <= send_dat[22];
                15:sda_reg <= send_dat[21];
                16:sda_reg <= send_dat[20];
                17:sda_reg <= send_dat[19];
                18:sda_reg <= send_dat[18];
                19:sda_reg <= send_dat[17];
                20:sda_reg <= send_dat[16]; //skip 21, ack bit
                //21:sda_reg <= 1'b1; //1 for z uncomment for synthesis
                21:sda_reg <= 1'b0; //comment out for synthesis
                22:sda_reg <= send_dat[15];
                23:sda_reg <= send_dat[14];
                24:sda_reg <= send_dat[13];
                25:sda_reg <= send_dat[12];
                26:sda_reg <= send_dat[11];
                27:sda_reg <= send_dat[10];
                28:sda_reg <= send_dat[9];
                29:sda_reg <= send_dat[8]; //skip 30, ack bit
                //30:sda_reg <= 1'b1; //1 for z uncomment for synthesis
                30:sda_reg <= 1'b0; //comment out for synthesis
                31:sda_reg <= send_dat[7];
                32:sda_reg <= send_dat[6];
                33:sda_reg <= send_dat[5];
                34:sda_reg <= send_dat[4];
                35:sda_reg <= send_dat[3];
                36:sda_reg <= send_dat[2];
                37:sda_reg <= send_dat[1];
                38:sda_reg <= send_dat[0]; //skip 39, ack bit
                //39:sda_reg <= 1'b1; //1 for z uncomment for synthesis
                39:sda_reg <= 1'b0; //comment out for synthesis
                40:sda_reg <= 1'b0;
                41:scl_reg <= 1'b1;
                42:sda_reg <= 1'b1;
                43:done_reg <= 1'b1;
                endcase

        end else begin //if sendit == 0;
            send_count <= 6'd0;
            done_reg <= 1'b0;
            sda_reg <= 1'b1;
            scl_reg <= 1'b1;
        end
    end
end
endmodule