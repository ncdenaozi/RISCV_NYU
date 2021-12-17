----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/11/18 09:49:31
-- Design Name: 
-- Module Name: test_alu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use ieee.std_logic_textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_alu is
  Port ( 
  clk: in std_logic
  );
end test_alu;

architecture Behavioral of test_alu is
signal rst:std_logic;
signal op_bc:std_logic_vector(3 downto 0);
signal op_ext:std_logic_vector(2 downto 0);
signal op_alu:std_logic_vector(4 downto 0);
signal s_rs1:std_logic;
signal s_rs2:std_logic;
signal rs1_data:std_logic_vector(31 downto 0);
signal rs2_data:std_logic_vector(31 downto 0);
signal instr_alu:std_logic_vector(31 downto 0);
signal pc_out:std_logic_vector(31 downto 0);
signal alu_out:std_logic_vector(31 downto 0);
signal bc:std_logic;

file file_pointer:text;

begin

dut: entity work.alu port map(
  clk => clk,
  rst => rst,
  op_bc => op_bc,
  op_ext => op_ext,
  op_alu => op_alu,
  s_rs1 => s_rs1,
  s_rs2 => s_rs2,
  rs1_data => rs1_data,
  rs2_data => rs2_data,
  instr_alu => instr_alu,
  pc_out => pc_out,
  alu_out => alu_out,
  bc => bc
);

rs1_data <= "00000000000000000000000000000001";
rs2_data <= "00000000000000000000000000000010";
pc_out <= "00000001000000000001000000000100";

    process 
        variable file_line:line;
        variable s1:std_logic;
        variable s2:std_logic;
        variable opbc:std_logic_vector(3 downto 0);
        variable opext:std_logic_vector(2 downto 0);
        variable opalu:std_logic_vector(4 downto 0);
        variable bcout:std_logic;
        variable ins:std_logic_vector(31 downto 0);
        variable aluout:std_logic_vector(31 downto 0);
        variable data_space:character;
    begin
        file_open(file_pointer,"test_alu.txt",read_mode);
        rst <= '0';
        wait for 10ns;
        rst <= '1';
        while not endfile(file_pointer) loop    
            readline(file_pointer,file_line);
            read(file_line,s1);
            read(file_line,data_space);
            read(file_line,s2);
            read(file_line,data_space);
            read(file_line,opbc);
            read(file_line,data_space);
            read(file_line,opext);
            read(file_line,data_space);
            read(file_line,opalu);
            read(file_line,data_space);
            read(file_line,bcout);
            read(file_line,data_space);
            read(file_line,ins);
            read(file_line,data_space);
            read(file_line,aluout);
            op_bc <= opbc;
            op_ext <= opext;
            op_alu <= opalu;
            s_rs1 <= s1;
            s_rs2 <= s2;
            instr_alu <= ins;
            wait for 6ns;
            assert(aluout=alu_out)report"aluout error"severity error;  
            assert(bcout=bc)report"bc error"severity error;  
            wait for 4ns;
        end loop; 
            
    end process;


end Behavioral;
