`timescale 1ns / 1ps
module DM_testbench();

reg t_clk;
reg t_rst;
reg[1:0] t_mc;
reg t_rd;
reg[31:0] t_alu_out;
reg[31:0] t_data_in;
wire[31:0] t_dm_out;

DataMemory dut(
.clk(t_clk),
.rst(t_rst),
.mc(t_mc),         
.alu_out(t_alu_out),	
.data_in(t_data_in),   
.rd(t_rd),      	
.dm_out(t_dm_out)
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
        t_rst=1; //rst
        #10;
        t_rst=0;
        #10;
        t_alu_out=32'h00100000; //N number1
        #10;
        if(t_dm_out != 32'h12289631)$warning("failure");

        t_alu_out=32'h00100004; //N number2
        #10;
        if(t_dm_out != 32'h16950767) $warning("failure");

        t_alu_out=32'h00100008; //N number3
        #10;
        if(t_dm_out != 32'h10535259) $warning("failure");

        #10;
        //store word
        t_rd=0;
        t_mc=2'b11;
        t_alu_out=32'h80000000;
        t_data_in=32'h12345678;
        #10;
        //store byte
        t_rd=0;
        t_mc=2'b01;
        t_alu_out=32'h80000004;
        t_data_in=32'h00000003;
        #10;
        //store half word
        t_rd=0;
        t_mc=2'b10;
        t_alu_out=32'h80000005;
        t_data_in=32'h00000102;
        #10;
        t_data_in=32'h00000000;
        //load word
        t_rd=1;
        t_mc=2'b11;
        t_alu_out=32'h80000000;
        #10;
        if(t_dm_out != 32'h12345678) $warning("failure");

        //load word
        t_rd=1;
        t_mc=2'b11;
        t_alu_out=32'h80000004;
        #10;
        if(t_dm_out != 32'h00010203) $warning("failure");
        
    $display("End of DM testbenches");
    $finish;

end


endmodule
