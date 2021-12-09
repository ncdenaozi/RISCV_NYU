`timescale 1ns / 1ps

module DataMemory(
input wire	clk,
input wire	rst,
input wire[1:0]	    mc,         //Byte-01 HalfWord-10£¬Word-11£¬Nop-00
input wire[31:0]	alu_out,	//=>address &mux, can be not 4-aligned address
input wire[31:0]	data_in,    //=>data_in
input wire	        rd,      	//1:Load£»0:Store
input wire[2:0]	    op,  		//Use in mux for write_back //same as funct3 
input wire	        s_data_ext,	//Use in mux for write_back //0: alu_out=>dm_out; 1: data_ext=>dm_out
output reg[31:0]   dm_out
);
               
reg[31:0] DM[1023:0];       //RAM 1024*4B=4096B
wire[9:0] Addr_offset;     //12 digit -2  1111 1111 11XX
wire[1:0]  Word_offset;     // 2 digit 00,01,10,11
reg[31:0] temp_out;
reg[31:0] ext_out;

integer i;
initial begin
for (i=0;i<=1023;i=i+1)
    DM[i] = 0;
end
////
//////////
////////////////
///////////////////
//////////////////////
//////////////////////////////
//////////////////////////////////////
assign Word_offset=alu_out[1:0]; //allow not-4-aligned address
assign Addr_offset=alu_out[11:2]; //RAM index 10 bit, 0-1023

always @(posedge clk,rst) begin
    if(rst==0) begin
    for (i=0;i<=1023;i=i+1)
        DM[i] = 0;
        DM[0] = 32'h46F8E8C5;
        DM[1] = 32'h460C6085;
        DM[2] = 32'h70F83B8A;
        DM[3] = 32'h284B8303;
        DM[4] = 32'h513E1454;
        DM[5] = 32'hF621ED22;
        DM[6] = 32'h3125065D;
        DM[7] = 32'h11A83A5D;
        DM[8] = 32'hD427686B;
        DM[9] = 32'h713AD82D;
        DM[10] = 32'h4B792F99;
        DM[11] = 32'h2799A4DD;
        DM[12] = 32'hA7901C49;
        DM[13] = 32'hDEDE871A;
        DM[14] = 32'h36C03196;
        DM[15] = 32'hA7EFC249;
        DM[16] = 32'h61A78BB8;
        DM[17] = 32'h3B0A1D2B;
        DM[18] = 32'h4DBFCA76;
        DM[19] = 32'hAE162167;
        DM[20] = 32'h30D76B0A;
        DM[21] = 32'h43192304;
        DM[22] = 32'hF6CC1431;
        DM[23] = 32'h65046380; 
        
        DM[24] = 32'h12345678;
        DM[25] = 32'h9abcdef0;
    end
    else begin 
        if(alu_out==32'h00100000) begin
            temp_out <=32'h12289631; //N12289631
        end
        else if(alu_out==32'h00100004) begin
            temp_out <=32'h16950767; //zy2158-N16950767
        end
        else if(alu_out==32'h00100008) begin
            temp_out <=32'h10535259;//lx2004-N10535259
        end
        else begin
            if(alu_out[31:16]==16'h8000) begin
                if(rd==1) begin       //Load section
                case(mc)
                    2'b00:begin
                        temp_out<=temp_out;
                    end
                    2'b01: begin //load byte
                        case(Word_offset)
                            2'b00: temp_out<=DM[Addr_offset][7:0];
                            2'b01: temp_out<=DM[Addr_offset][15:8];
                            2'b10: temp_out<=DM[Addr_offset][23:16];
                            2'b11: temp_out<=DM[Addr_offset][31:24];
                        endcase
                    end
                    2'b10: begin //load half word
                        case(Word_offset)
                            2'b00: temp_out<=DM[Addr_offset][15:0];
                            2'b01: temp_out<=DM[Addr_offset][23:8];
                            2'b10: temp_out<=DM[Addr_offset][31:16];
                            2'b11: temp_out<={DM[Addr_offset+1][7:0],DM[Addr_offset][31:24]};
                        endcase
                    end
                    2'b11:begin  //load word
                        case(Word_offset)
                            2'b00: temp_out<=DM[Addr_offset][31:0];
                            2'b01: temp_out<={DM[Addr_offset+1][7:0],DM[Addr_offset][31:8]};
                            2'b10: temp_out<={DM[Addr_offset+1][15:0],DM[Addr_offset][31:16]};
                            2'b11: temp_out<={DM[Addr_offset+1][23:0],DM[Addr_offset][31:24]};
                        endcase
                    end
                    default: temp_out<=32'h0;
                endcase
                end
                else if(rd==0) begin  //Store section
                case(mc)
                    //2'b00,//nop
                    2'b01:  begin //store byte
                        case(Word_offset)
                            2'b00: DM[Addr_offset][7:0]<=data_in[7:0];
                            2'b01: DM[Addr_offset][15:8]<=data_in[7:0];
                            2'b10: DM[Addr_offset][23:16]<=data_in[7:0];
                            2'b11: DM[Addr_offset][31:24]<=data_in[7:0];
                        endcase
                    end
                    2'b10: begin//store half word
                        case(Word_offset)
                            2'b00: DM[Addr_offset][15:0]<=data_in[15:0];
                            2'b01: DM[Addr_offset][23:8]<=data_in[15:0];
                            2'b10: DM[Addr_offset][31:16]<=data_in[15:0];
                            2'b11: begin
                                DM[Addr_offset+1][7:0]<=data_in[7:0];
                                DM[Addr_offset][31:24]<=data_in[15:8];
                            end
                        endcase
                    end 
                    2'b11: begin  //store word
                        case(Word_offset)
                            2'b00: DM[Addr_offset]<=data_in;
                            2'b01: begin
                                DM[Addr_offset][31:8]<=data_in[23:0];
                                DM[Addr_offset+1][7:0]<=data_in[31:24];
                            end
                            2'b10: begin
                                DM[Addr_offset][31:16]<=data_in[15:0];
                                DM[Addr_offset+1][15:0]<=data_in[31:16];
                            end
                            2'b11: begin
                                DM[Addr_offset][31:24]<=data_in[7:0];
                                DM[Addr_offset+1][23:0]<=data_in[31:8];
                            end
                        endcase
                    end
                    default: temp_out<=32'h0;
                endcase
                end
            end
        end
        
//        case(op)
//            3'b000:begin //LB 8->32 signed ext
//                ext_out<={{24{temp_out[7]}},temp_out[7:0]};
//            end
//            3'b001:begin //LH 16->32 signed ext
//                ext_out<={{16{temp_out[7]}},temp_out[15:0]};
//            end
//            3'b010:begin//LW 
//                ext_out<=temp_out;
//            end
//            3'b100:begin//LBU [7:0] zero ext
//                ext_out<={24'b0,temp_out[7:0]};
//            end
//            3'b101:begin//LHU [15:0], zero ext
//                ext_out<={16'b0,temp_out[15:0]};
//            end
//        endcase
        
//        case(s_data_ext)
//            1'b0: begin
//                dm_out<=alu_out;
//            end
//            default: begin
//                dm_out<=ext_out;
//            end
//        endcase
    end
    
end

always@(alu_out, ext_out, s_data_ext)begin
        case(s_data_ext)
            1'b0: begin
                dm_out<=alu_out;
            end
            default: begin
                dm_out<=ext_out;
            end
        endcase
end

always@(op, temp_out)begin
        case(op)
            3'b000:begin //LB 8->32 signed ext
                ext_out<={{24{temp_out[7]}},temp_out[7:0]};
            end
            3'b001:begin //LH 16->32 signed ext
                ext_out<={{16{temp_out[7]}},temp_out[15:0]};
            end
            3'b010:begin//LW 
                ext_out<=temp_out;
            end
            3'b100:begin//LBU [7:0] zero ext
                ext_out<={24'b0,temp_out[7:0]};
            end
            3'b101:begin//LHU [15:0], zero ext
                ext_out<={16'b0,temp_out[15:0]};
            end
        endcase
end


endmodule