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
assign sda = sda_reg? 1'b1 : 1'b0; //pullup on resistor, change z to 1 to test
//always @(*) begin
    //if (6'd38 < send_count < 6'd2) begin
        //scl = scl_reg;
    //end else begin
        //scl = scl_clk;
    //end
//end
assign scl = ( (6'd2 > send_count) | (send_count > 6'd38) )?scl_reg:scl_clk;


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
    if(clk_count == 7'd115) begin
      scl_clk <= 1'b0;
    end
    if(clk_count == 7'd0) begin
       sda_clk <= 1'b0; 
    end
end

always @(posedge scl_clk or negedge scl_clk or posedge reset) begin
    if (reset) begin
        ack_reg <= 1'b0;
    end else begin
        if (send_count == 6'd11 | 6'd20 | 6'd29 | 6'd38) begin
            ack_reg <= (ack_reg | sda);
        end
    end
end

always @(negedge sda_clk) begin
    if (send_count < 6'd41) begin
        send_count <= send_count + 1'b1;
    end else begin
        send_count <= 6'd0;
    end
end
always @(posedge sda_clk or posedge reset) begin
    if(reset) begin
        send_count <= 6'd0;
    end else begin
        if(sendit) begin
            case(send_count)
                0: begin
                    sda_reg <= 1'b0;
                    scl_reg <= 1'b1;
                    done_reg = 1'b0;
                end
                1: begin
                    sda_reg <= 1'b0;
                    scl_reg <= 1'b0;
                end
                2: begin
                    sda_reg <= 1'b0;
                    scl_reg <= 1'b0;
                end
                3:sda_reg <= i2c_address[6];
                4:sda_reg <= i2c_address[5];
                5:sda_reg <= i2c_address[4];
                6:sda_reg <= i2c_address[3];
                7:sda_reg <= i2c_address[2];
                8:sda_reg <= i2c_address[1];
                9:sda_reg <= i2c_address[0];
                10:sda_reg <= 1'b0; //skip 11, ack bit
                12:sda_reg <= send_dat[23];
                13:sda_reg <= send_dat[22];
                14:sda_reg <= send_dat[21];
                15:sda_reg <= send_dat[20];
                16:sda_reg <= send_dat[19];
                17:sda_reg <= send_dat[18];
                18:sda_reg <= send_dat[17];
                19:sda_reg <= send_dat[16]; //skip 20, ack bit
                21:sda_reg <= send_dat[15];
                22:sda_reg <= send_dat[14];
                23:sda_reg <= send_dat[13];
                24:sda_reg <= send_dat[12];
                25:sda_reg <= send_dat[11];
                26:sda_reg <= send_dat[10];
                27:sda_reg <= send_dat[9];
                28:sda_reg <= send_dat[8]; //skip 29, ack bit
                30:sda_reg <= send_dat[7];
                31:sda_reg <= send_dat[6];
                32:sda_reg <= send_dat[5];
                33:sda_reg <= send_dat[4];
                34:sda_reg <= send_dat[3];
                35:sda_reg <= send_dat[2];
                36:sda_reg <= send_dat[1];
                37:sda_reg <= send_dat[0]; //skip 38, ack bit
                39:sda_reg <= 1'b0;
                40:scl_reg <= 1'b1;
                41:begin 
                    sda_reg <= 1'b1;
                    done_reg <= 1'b1;
                end
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