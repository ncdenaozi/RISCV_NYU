--Final PJ by zy2158 N16950767
--VHDL
--Control Unit-testbench

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity ctu_test is
	--Port();
end ctu_test;

architecture tests of ctu_test is
	component Control_Unit port (
		-- globle input
		clk:		in std_logic;
		rst:		in std_logic;
		-- operation input
		bc:			in std_logic;
		instruction:	in std_logic_vector(31 downto 0);
		--PC control signals
		s_pc_in:		out std_logic;
		s_rd_data_in:	out std_logic;
		we_pc:			out std_logic;
		--Instruction mem control signals
		rd_im:			out std_logic;
		--Regfile control signals
		re_regfile:		out std_logic;
		we_regfile:		out std_logic;
		--ALU control signals
		s_rs1:			out std_logic;
		s_rs2:			out std_logic;
		op_bc:			out std_logic_vector(3 downto 0);
		op_imm_ext:		out std_logic_vector(2 downto 0);
		op_alu:			out std_logic_vector(4 downto 0);
		--Data mem control signals
		mc:				out std_logic_vector(1 downto 0);
		rd_dm:			out std_logic;
		s_data_ext:		out std_logic;
		funct3:			out std_logic_vector(2 downto 0);
		--exposed instruction values
		opcode:			out std_logic_vector(6 downto 0)
		);
	end component;
	signal t_clk:			std_logic:='0';
	signal t_rst:			std_logic:='0';
	signal t_bc:			std_logic:='0';
	signal t_instruction:	std_logic_vector(31 downto 0);
	signal t_s_pc_in:		std_logic:='0';
	signal t_s_rd_data_in:	std_logic:='0';
	signal t_we_pc:			std_logic:='0';
	signal t_rd_im:			std_logic:='0';
	signal t_re_regfile:	std_logic:='0';
	signal t_we_regfile:	std_logic:='0';
	signal t_s_rs1:			std_logic:='0';
	signal t_s_rs2:			std_logic:='0';
	signal t_op_bc:			std_logic_vector(3 downto 0);
	signal t_op_imm_ext:	std_logic_vector(2 downto 0);
	signal t_op_alu:		std_logic_vector(4 downto 0);
	signal t_mc:			std_logic_vector(1 downto 0);
	signal t_rd_dm:			std_logic:='0';
	signal t_s_data_ext:	std_logic:='0';
	signal t_funct3:		std_logic_vector(2 downto 0);
	signal t_opcode:		std_logic_vector(6 downto 0);
begin
	dut: Control_Unit port map(
		clk => t_clk,
		rst => t_rst,
		bc => t_bc,
		instruction => t_instruction,
		s_pc_in => t_s_pc_in,
		s_rd_data_in => t_s_rd_data_in,
		we_pc => t_we_pc,
		rd_im => t_rd_im,
		re_regfile => t_re_regfile,
		we_regfile => t_we_regfile,
		s_rs1 => t_s_rs1,
		s_rs2 => t_s_rs2,
		op_bc => t_op_bc,
		op_imm_ext => t_op_imm_ext,
		op_alu => t_op_alu,
		mc => t_mc,
		rd_dm => t_rd_dm,
		s_data_ext => t_s_data_ext,
		funct3 => t_funct3,
		opcode => t_opcode
		);

	CLK_GEN: process begin
		t_clk <= '0';
		wait for 5ns;
		t_clk <= '1';   
		wait for 5ns;
	end process;

	TEST_CASES: process begin
		t_rst<='0';
		wait until falling_edge(t_clk);
		assert(t_we_pc = '0') report"wrong pc enable" severity FAILURE;
		assert(t_rd_im = '0') report"wrong IM enable" severity FAILURE;
		assert(t_re_regfile = '0') report"wrong reg enable" severity FAILURE;
		assert(t_we_regfile = '0') report"wrong reg enable" severity FAILURE;
		assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
		wait for 1ns;
		t_rst<='1';

		t_bc<='0';
		report "Testing Instyuction: LUI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000011110000000110110111"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '0') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "101") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00000") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------

		t_bc<='0';
		report "Testing Instyuction: AUIPC ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000011110000000110010111"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '0') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '1') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "101") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00001") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: JAL ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000011110000000111101111"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '0') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '1') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "001") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00010") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '1') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '1') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: JALR ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000001000001001100111"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00011") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '1') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '1') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: BEQ ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001110001000001000100001100011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '1') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc = "1000") report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "011") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00100") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '0') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: FENCE/NOP ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000110000010011000110110001111"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '0') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc = "0000") report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "10001") report"wrong alu poeration" severity FAILURE;
			t_bc<='1';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '0') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: BLTU ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001110001000001110100001100011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '1') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc = "1110") report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "011") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00100") report"wrong alu poeration" severity FAILURE;
			t_bc<='1';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '0') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '1') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: LB ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000001000001000000011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00101") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "01") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '1') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '1') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: LH ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000001001001000000011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00101") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "10") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '1') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '1') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: LW ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000001010001000000011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00101") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "11") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '1') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '1') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: LBU ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000001100001000000011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00101") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "01") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '1') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '1') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: LHU ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000001101001000000011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00101") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "10") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '1') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '1') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: SB ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001110001000001000001000100011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "100") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00110") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "01") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '0') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: SH ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001110001000001001001000100011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "100") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00110") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "10") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '0') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: SW ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001110001000001010001000100011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "100") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00110") report"wrong alu poeration" severity FAILURE;
			t_bc<='0';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "11") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '0') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		t_bc<='0';
		report "Testing Instyuction: ECALL/EBREAK ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000000000000000000000001110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				--assert(t_s_rs1 = '1') report"wrong operater1 selection" severity FAILURE;
				--assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc = "0000") report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "10010") report"wrong alu poeration" severity FAILURE;
			t_bc<='1';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '0') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '0') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: After BREAK ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '0') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000011000110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '0') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				--assert(t_s_rs1 = '1') report"wrong operater1 selection" severity FAILURE;
				--assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				--assert(t_op_bc = "0000") report"wrong branching poeration" severity FAILURE;
				--assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				--assert(t_op_alu = "10010") report"wrong alu poeration" severity FAILURE;
			t_bc<='1';
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '0') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '0') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing rst to resume ";
		wait until falling_edge(t_clk);
		t_rst<='0';
		wait until falling_edge(t_clk);
		t_rst<='1';

-------------------------------------------------------------------------------------------------------

		report "Testing Instyuction: ADDI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000011000110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00111") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SLTI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000011010110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01000") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SLTIU ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000011011110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01001") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: XORI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000011100110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01010") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: ORI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000011110110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01011") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: ANDI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00001111000000011111110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01100") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SLLI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000000000000011001110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01101") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SRLI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000000000000011101110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01110") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SRAI ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="01000000000000011101110110010011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '1') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "010") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01111") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: ADD ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000001100000011000110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "00111") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SUB ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="01000001100000011000110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "10000") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SLL ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000001100000011001110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01101") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SLT ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000001100000011010110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01000") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SLTU ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000001100000011011110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01001") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: XOR ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000001100000011100110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01010") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SRL ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000001100000011101110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01110") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: SRA ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="01000001100000011101110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01111") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: OR ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000001100000011110110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01011") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------
		report "Testing Instyuction: AND ";
			wait until falling_edge(t_clk);			assert(t_rd_im = '1') report"wrong IM enable" severity FAILURE;	assert((t_we_pc or t_re_regfile or t_we_regfile) = '0') report"wrong enable in IM" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_ifid
				t_instruction<="00000001100000011111110110110011"; 	
			wait until falling_edge(t_clk);			assert((t_rd_im or t_we_regfile or t_we_pc) = '0') report"wrong enable in reg read" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_readreg
				assert(t_re_regfile = '1') report"wrong reg read  enable" severity FAILURE;			
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in alu" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_alu
				assert(t_s_rs1 = '0') report"wrong operater1 selection" severity FAILURE;
				assert(t_s_rs2 = '0') report"wrong operater2 selection " severity FAILURE;
				assert(t_op_bc(3) = '0') report"wrong branching poeration" severity FAILURE;
				assert(t_op_imm_ext = "000") report"wrong imm poeration" severity FAILURE;
				assert(t_op_alu = "01100") report"wrong alu poeration" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_regfile or t_we_pc) = '0') report"wrong enable in mem" severity FAILURE;
				--st_mem	
				assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				assert(t_rd_dm = '0') report"wrong read DM selection" severity FAILURE;
				assert(t_s_data_ext = '0') report"wrong write back data selection" severity FAILURE;
			wait until falling_edge(t_clk);			assert((t_rd_im or t_re_regfile or t_we_pc) = '0') report"wrong enable in write back" severity FAILURE;	assert(t_mc = "00") report"wrong DM enable" severity FAILURE;
				--st_writeback
				assert(t_we_regfile = '1') report"wrong reg write enable" severity FAILURE;		
			wait until falling_edge(t_clk);			assert(t_we_pc = '1') report"wrong reg read  enable" severity FAILURE;	assert((t_rd_im or t_re_regfile or t_we_regfile) = '0') report"wrong enable in pc update" severity FAILURE;
				--st_pc	
				assert(t_s_pc_in = '0') report"wrong brenching enable" severity FAILURE;
				assert(t_s_rd_data_in = '0') report"wrong link enable" severity FAILURE;
			report "Pass this instruction";
-------------------------------------------------------------------------------------------------------		
		report "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$";
		report "$$$$$$$$$All tests passed$$$$$$$$";
		report "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$";
		std.env.stop;
	end process;
end tests;

