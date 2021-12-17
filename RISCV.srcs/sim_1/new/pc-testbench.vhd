--Final PJ by zy2158 N16950767
--VHDL
--PC-testbench

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity pc_test is
	--Port();
end pc_test;

architecture tests of pc_test is
	component pc port (
			clk:		in std_logic;
			rst:		in std_logic;
			s_pc_in:		in std_logic;
			s_rd_data_in:	in std_logic;
			we_pc:		in std_logic;
			
			alu_out:	in std_logic_vector(31 downto 0);
			rd_data:	in std_logic_vector(31 downto 0);

			rd_data_in:	out std_logic_vector(31 downto 0);
			pc_now:		out std_logic_vector(31 downto 0);
			pc_next:	out std_logic_vector(31 downto 0)
		);
	end component;
		signal t_clk:			std_logic:='0';
		signal t_rst:			std_logic:='0';
		signal t_s_pc_in:		std_logic:='0';
		signal t_s_rd_data_in:	std_logic:='0';
		signal t_we_pc:			std_logic:='0';
		
		signal t_alu_out:		std_logic_vector(31 downto 0);
		signal t_rd_data:		std_logic_vector(31 downto 0);

		signal t_rd_data_in:	std_logic_vector(31 downto 0);
		signal t_pc_now:		std_logic_vector(31 downto 0);
		signal t_pc_next:		std_logic_vector(31 downto 0);
begin
	dut: pc port map(
		clk 			=> t_clk,
		rst 			=> t_rst,
		s_pc_in			=> t_s_pc_in,
		s_rd_data_in 	=> t_s_rd_data_in,
		we_pc			=> t_we_pc,
		
		alu_out			=> t_alu_out,
		rd_data			=> t_rd_data,

		rd_data_in		=> t_rd_data_in,
		pc_now			=> t_pc_now,
		pc_next			=> t_pc_next
		);

	CLK_GEN: process begin
		t_clk <= '0';
		wait for 5ns;
		t_clk <= '1';   
		wait for 5ns;
	end process;

	TEST_CASES: process begin
		t_rst<='0';
		t_rd_data<="00010010001101000101011001111000"; --0x12345678
		t_alu_out<="00000011000000000000000000000000"; --0x03000000
		t_s_pc_in<='0';
		t_s_rd_data_in<='0';
		t_we_pc<='0';
		wait until rising_edge(t_clk);
		assert(t_pc_now = "00000001000000000000000000000000") report"reset failer" severity FAILURE;
		assert(t_pc_next = "00000001000000000000000000000100") report"reset failer" severity FAILURE;
		assert(t_rd_data_in = "00010010001101000101011001111000") report"reset failer" severity FAILURE;

		wait until rising_edge(t_clk);
		t_s_rd_data_in<='1';
		wait until rising_edge(t_clk);
		assert(t_rd_data_in = "00000001000000000000000000000100") report"rd_data selection fail" severity FAILURE;
		t_s_rd_data_in<='0';
		wait until rising_edge(t_clk);
		assert(t_rd_data_in = "00010010001101000101011001111000") report"rd_data selection fail" severity FAILURE;

		t_we_pc<='1';
		t_rst<='1';
		wait until rising_edge(t_clk);
		assert(t_pc_now = "00000001000000000000000000000100") report"counting failer" severity FAILURE;
		assert(t_pc_next = "00000001000000000000000000001000") report"counting failer" severity FAILURE;
		t_we_pc<='0';
		wait until falling_edge(t_clk);
		t_we_pc<='1';
		wait until rising_edge(t_clk);
		assert(t_pc_now = "00000001000000000000000000001000") report"counting failer" severity FAILURE;
		assert(t_pc_next = "00000001000000000000000000001100") report"counting failer" severity FAILURE;
		t_we_pc<='0';
		wait until falling_edge(t_clk);
		t_s_pc_in<='1';
		wait for 1ns;
		t_we_pc<='1';
		wait until rising_edge(t_clk);
		assert(t_pc_now = "00000011000000000000000000000000") report"brenching failer" severity FAILURE;
		assert(t_pc_next = "00000011000000000000000000000100") report"brenching failer" severity FAILURE;
		t_s_pc_in<='0';
		t_we_pc<='0';
		wait until falling_edge(t_clk);
		t_we_pc<='1';
		wait until rising_edge(t_clk);
		assert(t_pc_now = "00000011000000000000000000000100") report"counting failer after brenching" severity FAILURE;
		assert(t_pc_next = "00000011000000000000000000001000") report"counting failer after brenching" severity FAILURE;
		t_we_pc<='0';

		wait until rising_edge(t_clk);
		t_rst<='0';
		wait for 1ns;
		assert(t_pc_now = "00000001000000000000000000000000") report"restting failer" severity FAILURE;
		assert(t_pc_next = "00000001000000000000000000000100") report"restting failer" severity FAILURE;
		t_we_pc<='1';
		wait until rising_edge(t_clk);
		assert(t_pc_now = "00000001000000000000000000000000") report"restting failer" severity FAILURE;
		assert(t_pc_next = "00000001000000000000000000000100") report"restting failer" severity FAILURE;
		t_we_pc<='0';

		report "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$";
		report "$$$$$$$$OwO. All tests passed$$$$$$$$";
		report "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$";
		std.env.stop;
	end process;
end tests;










