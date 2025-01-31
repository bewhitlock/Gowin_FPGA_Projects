// From https://github.com/YJ-Guan/Xilinx-NEXYS4_DDR-Drives-OV5640/blob/master/Camera.srcs/sources_1/new/i2c_com.v


//Dirven witn 20kHz
module i2c_com(clock_i2c, //input 20kHz clock       
               camera_rstn, //camera reset pin     
               ack,       //acknowledge flag, does nothing lol?       
               i2c_data,    //32 bits parallel data to send,
               //             concatenate address, then the 
               //             register and data to write like this:
               // i2c_data <= {8'h78,reg_data};
               //8-bit cam i2c address << 8-bit reg addr << 16 bit reg-data
               start,       //start flag from rest of the modules      
               tr_end, //transmission end flag for the rest of the modules    
               i2c_sclk,      //i2c pin scl
               i2c_sdat);     //i2c pin sda  
    input [31:0]i2c_data;
    input camera_rstn;
    input clock_i2c;
    output ack; //acknowledge, doesnt get used in the driving module, but 
    //           would show if the transmit failed when ack = 1'b1;
    input start;
    output tr_end;
    output i2c_sclk;
    inout i2c_sdat;
    reg [5:0] cyc_count;
    reg reg_sdat;
    reg sclk;
    reg ack1,ack2,ack3;
    reg tr_end;
 
   
    wire i2c_sclk;
    wire i2c_sdat;
    wire ack;
   
    assign ack=ack1|ack2|ack3;
    assign i2c_sclk=sclk|(((cyc_count>=4)&(cyc_count<=39))?~clock_i2c:0);
    assign i2c_sdat=reg_sdat?1'bz:0; //physical pull up on sda
   
    always@(posedge clock_i2c or  negedge camera_rstn)
    begin
       if(!camera_rstn)
         cyc_count<=6'b111111;
       else 
		   begin
           if(start==0)
             cyc_count<=0;
           else if(cyc_count<6'b111111)
             cyc_count<=cyc_count+1;
         end
    end
	 
	 
    always@(posedge clock_i2c or negedge camera_rstn)
    begin
       if(!camera_rstn)
       begin
          tr_end<=0;
          ack1<=1;
          ack2<=1;
          ack3<=1;
          sclk<=1;
          reg_sdat<=1;
       end
       else
          case(cyc_count)
          0:begin ack1<=1;ack2<=1;ack3<=1;tr_end<=0;sclk<=1;reg_sdat<=1;end
          1:reg_sdat<=0;  //initiate sending               
          2:sclk<=0;
          3:reg_sdat<=i2c_data[31]; // doesnt get read
          4:reg_sdat<=i2c_data[30];
          5:reg_sdat<=i2c_data[29];
          6:reg_sdat<=i2c_data[28];
          7:reg_sdat<=i2c_data[27];
          8:reg_sdat<=i2c_data[26];
          9:reg_sdat<=i2c_data[25];
          10:reg_sdat<=i2c_data[24];
          11:reg_sdat<=1;    //write fn            
          12:begin reg_sdat<=i2c_data[23];ack1<=i2c_sdat;end
          13:reg_sdat<=i2c_data[22];
          14:reg_sdat<=i2c_data[21];
          15:reg_sdat<=i2c_data[20];
          16:reg_sdat<=i2c_data[19];
          17:reg_sdat<=i2c_data[18];
          18:reg_sdat<=i2c_data[17];
          19:reg_sdat<=i2c_data[16];
          20:reg_sdat<=1;                      
          21:begin reg_sdat<=i2c_data[15];ack1<=i2c_sdat;end
          22:reg_sdat<=i2c_data[14];
          23:reg_sdat<=i2c_data[13];
          24:reg_sdat<=i2c_data[12];
          25:reg_sdat<=i2c_data[11];
          26:reg_sdat<=i2c_data[10];
          27:reg_sdat<=i2c_data[9];
          28:reg_sdat<=i2c_data[8];
          29:reg_sdat<=1;                     
          30:begin reg_sdat<=i2c_data[7];ack2<=i2c_sdat;end
          31:reg_sdat<=i2c_data[6];
          32:reg_sdat<=i2c_data[5];
          33:reg_sdat<=i2c_data[4];
          34:reg_sdat<=i2c_data[3];
          35:reg_sdat<=i2c_data[2];
          36:reg_sdat<=i2c_data[1];
          37:reg_sdat<=i2c_data[0];
          38:reg_sdat<=1;                      
          39:begin ack3<=i2c_sdat;sclk<=0;reg_sdat<=0;end
          40:sclk<=1;
          41:begin reg_sdat<=1;tr_end<=1;end
          endcase
       
end
endmodule

