`timescale 1ns / 1ps
module IM_testbench();

reg t_clk;
reg t_rst;
reg[31:0] t_addr;
wire[31:0] t_instruction;
wire[6:0] t_funct7;
wire[2:0] t_funct3;
wire[6:0] t_Opcode;
wire[4:0] t_rd_addr;     	    
wire[4:0] t_rs1_addr;	    
wire[4:0] t_rs2_addr;

InstructionMemory dut(
    .clk(t_clk),
    .addr(t_addr),
    .rst(t_rst),
    .instruction(t_instruction),
    .funct7(t_funct7),
    .funct3(t_funct3),
    .Opcode(t_Opcode),
    .rd_addr(t_rd_addr),
    .rs1_addr(t_rs1_addr), 
    .rs2_addr(t_rs2_addr)
);

initial begin: CLK_GEN
    forever begin
        
        t_clk=0;
        #5;
        t_clk=1;
        #5;
    end
end

initial begin: TEST_CASES
        //t_rst=0; do not perform because we want hard-coded ROM remains
        #10;
        //t_rst=1; do not perform because we want hard-coded ROM remains
        #10;
        t_addr=32'h01000000; //access the first instruction
         #10;
        if(t_instruction != 32'h12345678) $warning("failure"); 
        
        t_addr=32'h01000004; //access the second instruction
        #10;
        if(t_instruction != 32'h23456789) $warning("failure"); 
        
        t_addr=32'h01000008; //access the third instruction
        #10;
        if(t_instruction != 32'h3456789A) $warning("failure"); 
  
    $display("End of IM testbenches");
    $finish;

end

endmodule

