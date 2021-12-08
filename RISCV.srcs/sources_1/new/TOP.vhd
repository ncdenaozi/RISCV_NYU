library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is
  Port ( 
clk:		in std_logic:='0';
rst:		in std_logic:='0'
  );
end TOP;

architecture Behavioral of TOP is

COMPONENT pc is
PORT(
            clk:		in std_logic:='0';
			rst:		in std_logic:='0';
			s_pc_in:		in std_logic:='0';
			s_rd_data_in:	in std_logic:='0';
			we_pc:		in std_logic:='0';
			
			alu_out:	in std_logic_vector(31 downto 0);
			rd_data:	in std_logic_vector(31 downto 0);

			rd_data_in:	out std_logic_vector(31 downto 0);
			pc_now:	out std_logic_vector(31 downto 0);
			pc_next:	out std_logic_vector(31 downto 0));
END COMPONENT;

COMPONENT control_unit is 
PORT(
-- globle input
			clk:		in std_logic:='0';
			rst:		in std_logic:='0';
			-- operation input
			bc:			in std_logic:='0';
			instruction:	in std_logic_vector(31 downto 0);
			--PC control signals
			s_pc_in:		out std_logic:='0';
			s_rd_data_in:	out std_logic:='0';
			we_pc:			out std_logic:='0';
			--Instruction mem control signals
			rd_im:			out std_logic:='0';
			--Regfile control signals
			re_regfile:		out std_logic:='0';
			we_regfile:		out std_logic:='0';
			--ALU control signals
			s_rs1:			out std_logic:='0';
			s_rs2:			out std_logic:='0';
			op_bc:			out std_logic_vector(3 downto 0);
			op_imm_ext:		out std_logic_vector(2 downto 0);
			op_alu:			out std_logic_vector(4 downto 0);
			--Data mem control signals
			mc:				out std_logic_vector(1 downto 0);
			rd_dm:			out std_logic:='0';
			s_data_ext:		out std_logic:='0';
			funct3:			out std_logic_vector(2 downto 0);
			--exposed instruction values
			opcode:			out std_logic_vector(6 downto 0));
END COMPONENT;


COMPONENT reg is
PORT(
  clk: in std_logic;
  rst: in std_logic;
  re: in std_logic;
  we: in std_logic;
  rd_data_in: in std_logic_vector(31 downto 0);
  rd_addr: in std_logic_vector(4 downto 0);
  rs1_addr: in std_logic_vector(4 downto 0);
  rs2_addr: in std_logic_vector(4 downto 0);
  rs1_data: out std_logic_vector(31 downto 0);
  rs2_data: out std_logic_vector(31 downto 0)
);
END COMPONENT;

COMPONENT alu is
PORT(
clk: in std_logic;
  rst: in std_logic;
  op_bc: in std_logic_vector(3 downto 0);
  op_ext:in std_logic_vector(2 downto 0);
  op_alu: in std_logic_vector(4 downto 0);
  s_rs1: in std_logic;
  s_rs2:in std_logic;
  rs1_data: in std_logic_vector(31 downto 0);
  rs2_data: in std_logic_vector(31 downto 0);
  instr_alu: in std_logic_vector(31 downto 0);
  pc_out: in std_logic_vector(31 downto 0);
  alu_out: out std_logic_vector(31 downto 0);
  bc: out std_logic);
END COMPONENT;

COMPONENT datamemory is 
PORT(
clk:in std_logic;
rst:in std_logic;
mc:in std_logic_vector(1 downto 0);	  --Byte-01 HalfWord-10£¬Word-11£¬Nop-00
alu_out:in std_logic_vector(31 downto 0); --address &mux, can be not 4-aligned address
data_in:in std_logic_vector(31 downto 0); --data_in
rd: in std_logic;      	--1:Load£»0:Store
op: in std_logic_vector(2 downto 0); --Use in mux for write_back //same as funct3 
s_data_ext: in std_logic; --Use in mux for write_back //0: alu_out=>dm_out; 1: data_ext=>dm_out
dm_out: out std_logic_vector(31 downto 0)   
);
END COMPONENT;

COMPONENT instructionmemory is 
PORT(
clk:in std_logic;
rst:in std_logic;
addr:in std_logic_vector(31 downto 0);             --instruction address, from PC
funct7:out std_logic_vector(6 downto 0);
funct3:out std_logic_vector(2 downto 0);
Opcode:out std_logic_vector(6 downto 0);
rd_addr:out std_logic_vector(4 downto 0);     	 -- decode out Rd address
rs1_addr:out std_logic_vector(4 downto 0);	     --decode out Rs1 address
rs2_addr:out std_logic_vector(4 downto 0);	     --decode out Rs2 address
instruction:out std_logic_vector(31 downto 0)  
);
END COMPONENT;

--pc in, initial
signal  PC_s_pc_in:		 std_logic:='0';
signal	PC_s_rd_data_in:	 std_logic:='0';
signal	PC_we_pc:       std_logic:='0';
signal	PC_alu_out:	    std_logic_vector(31 downto 0);
signal	PC_rd_data:	   std_logic_vector(31 downto 0);
--pc out
signal	PC_rd_data_in:	 std_logic_vector(31 downto 0);
signal	PC_pc_now:	     std_logic_vector(31 downto 0);
signal	PC_pc_next:     std_logic_vector(31 downto 0);

--control unit in
signal          CU_bc:			std_logic:='0';
signal			CU_instruction:	 std_logic_vector(31 downto 0);
--control unit out
            --PC control signals
signal          CU_s_pc_in:		 std_logic:='0';
signal	        CU_s_rd_data_in:	 std_logic:='0';
signal	        CU_we_pc:		     std_logic:='0';
			--Instruction mem control signals
signal			CU_rd_im:			 std_logic:='0';
			--Regfile control signals
signal			CU_re_regfile:		 std_logic:='0';
signal			CU_we_regfile:		 std_logic:='0';
			--ALU control signals
signal			CU_s_rs1:			 std_logic:='0';
signal			CU_s_rs2:			 std_logic:='0';
signal			CU_op_bc:			 std_logic_vector(3 downto 0);
signal			CU_op_imm_ext:		 std_logic_vector(2 downto 0);
signal			CU_op_alu:			 std_logic_vector(4 downto 0);
			--Data mem control signals
signal			CU_mc:				 std_logic_vector(1 downto 0);
signal			CU_rd_dm:			 std_logic:='0';
signal			CU_s_data_ext:		 std_logic:='0';
signal			CU_funct3:			 std_logic_vector(2 downto 0);
			--exposed instruction values
signal			CU_opcode:			 std_logic_vector(6 downto 0);

--IM in
signal IM_addr:     std_logic_vector(31 downto 0);
signal IM_clk:      std_logic:='0';
--IM out
signal IM_funct7:      std_logic_vector(6 downto 0);
signal IM_funct3:      std_logic_vector(2 downto 0);
signal IM_Opcode:      std_logic_vector(6 downto 0);
signal IM_rd_addr:     std_logic_vector(4 downto 0);     	 -- decode out Rd address
signal IM_rs1_addr:    std_logic_vector(4 downto 0);	     --decode out Rs1 address
signal IM_rs2_addr:    std_logic_vector(4 downto 0);	     --decode out Rs2 address
signal IM_instruction: std_logic_vector(31 downto 0);  

--reg in
signal  REG_re:         std_logic;
signal  REG_we:         std_logic;
signal  REG_rd_data_in: std_logic_vector(31 downto 0);
signal  REG_rd_addr:    std_logic_vector(4 downto 0);
signal  REG_rs1_addr:   std_logic_vector(4 downto 0);
signal  REG_rs2_addr:   std_logic_vector(4 downto 0);
--reg out  
signal  REG_rs1_data:  std_logic_vector(31 downto 0);
signal  REG_rs2_data:  std_logic_vector(31 downto 0);

--alu in
signal  ALU_op_bc:      std_logic_vector(3 downto 0);
signal  ALU_op_ext:     std_logic_vector(2 downto 0);
signal  ALU_op_alu:     std_logic_vector(4 downto 0);
signal  ALU_s_rs1:      std_logic;
signal  ALU_s_rs2:      std_logic;
signal  ALU_rs1_data:   std_logic_vector(31 downto 0);
signal  ALU_rs2_data:   std_logic_vector(31 downto 0);
signal  ALU_instr_alu:  std_logic_vector(31 downto 0);
signal  ALU_pc_out:     std_logic_vector(31 downto 0);
--alu out
signal  ALU_alu_out:    std_logic_vector(31 downto 0);
signal  ALU_bc:         std_logic;

--dm in
signal  DM_mc:         std_logic_vector(1 downto 0);	  --Byte-01 HalfWord-10£¬Word-11£¬Nop-00
signal  DM_alu_out:    std_logic_vector(31 downto 0); --address &mux, can be not 4-aligned address
signal  DM_data_in:    std_logic_vector(31 downto 0); --data_in
signal  DM_rd:         std_logic;      	--1:Load£»0:Store
signal  DM_op:         std_logic_vector(2 downto 0); --Use in mux for write_back //same as funct3 
signal  DM_s_data_ext: std_logic; --Use in mux for write_back //0: alu_out=>dm_out; 1: data_ext=>dm_out
--dm out
signal  DM_dm_out:     std_logic_vector(31 downto 0); 

    			
begin
--PC
REG_rd_data_in<=PC_rd_data_in;
IM_addr<=PC_pc_now;
ALU_pc_out<=PC_pc_now;
--IM
REG_rd_addr<=IM_rd_addr;
REG_rs1_addr<=IM_rs1_addr;
REG_rs2_addr<=IM_rs2_addr;
CU_instruction<=IM_instruction;
ALU_instr_alu<=IM_instruction;
--CU
PC_s_pc_in<=CU_s_pc_in;
PC_s_rd_data_in<=CU_s_rd_data_in;
PC_we_pc<=CU_we_pc;
IM_clk<=clk and CU_rd_im;
REG_re<=CU_re_regfile;
REG_we<=CU_we_regfile;
ALU_s_rs1<=CU_s_rs1;
ALU_s_rs2<=CU_s_rs2;
ALU_op_bc<=CU_op_bc;
ALU_op_ext<=CU_op_imm_ext;
ALU_op_alu<=CU_op_alu;
DM_mc<=CU_mc;
DM_rd<=CU_rd_dm;
DM_s_data_ext<=CU_s_data_ext;
DM_op<=CU_funct3;


--REG
ALU_rs1_data<=REG_rs1_data;
ALU_rs2_data<=REG_rs2_data;
--ALU
DM_alu_out<=ALU_alu_out;
PC_alu_out<=ALU_alu_out;
CU_bc<=ALU_bc;
--DM
PC_rd_data<=DM_dm_out;


U2: control_unit PORT MAP(
            clk=>clk,
			rst=>rst,
			bc=>CU_bc,
			instruction=>CU_instruction,
			s_pc_in=>CU_s_pc_in,
			s_rd_data_in=>CU_s_rd_data_in,
			we_pc=>CU_we_pc,
			rd_im=>CU_rd_im,
			re_regfile=>CU_re_regfile,
			we_regfile=>CU_we_regfile,
			s_rs1=>CU_s_rs1,
			s_rs2=>CU_s_rs2,
			op_bc=>CU_op_bc,
			op_imm_ext=>CU_op_imm_ext,
			op_alu=>CU_op_alu,
			mc=>CU_mc,
			rd_dm=>CU_rd_dm,
			s_data_ext=>CU_s_data_ext,
			funct3=>CU_funct3,
			opcode=>CU_opcode);
			
			

U1: pc PORT MAP(
            clk=>clk,
            rst=>rst,
			s_pc_in=>PC_s_pc_in,
			s_rd_data_in=>PC_s_rd_data_in,
			we_pc=>PC_we_pc,			
			alu_out=>PC_alu_out,
			rd_data=>PC_rd_data,
			rd_data_in=>PC_rd_data_in,
			pc_now=>PC_pc_now,
			pc_next=>PC_pc_next);



U3: reg PORT MAP(
  clk=>clk,
  rst=>rst,
  re=>REG_re,
  we=>REG_we,
  rd_data_in=>REG_rd_data_in,
  rd_addr=>REG_rd_addr,
  rs1_addr=>REG_rs1_addr,
  rs2_addr=>REG_rs2_addr,
  rs1_data=>REG_rs1_data,
  rs2_data=>REG_rs2_data);
  
U6: instructionmemory PORT MAP(
clk=>IM_clk,
rst=>rst,
addr=>IM_addr,
funct7=>IM_funct7,
funct3=>IM_funct3,
Opcode=>IM_Opcode,
rd_addr=>IM_rd_addr,
rs1_addr=>IM_rs1_addr,
rs2_addr=>IM_rs2_addr,
instruction=>IM_instruction);  
  
U4: alu PORT MAP(
  clk=>clk,
  rst=>rst,
  op_bc=>ALU_op_bc,
  op_ext=>ALU_op_ext,
  op_alu=>ALU_op_alu,
  s_rs1=>ALU_s_rs1,
  s_rs2=>ALU_s_rs2,
  rs1_data=>ALU_rs1_data,
  rs2_data=>ALU_rs2_data,
  instr_alu=>ALU_instr_alu,
  pc_out=>ALU_pc_out,
  alu_out=>ALU_alu_out,
  bc=>ALU_bc);
  
U5: datamemory PORT MAP(
clk=>clk,
rst=>rst,
mc=>DM_mc,
alu_out=>DM_alu_out,
data_in=>DM_data_in,
rd=>DM_rd,
op=>DM_op,
s_data_ext=>DM_s_data_ext,
dm_out=>DM_dm_out);

end Behavioral;
