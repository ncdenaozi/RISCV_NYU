----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/11/18 09:49:11
-- Design Name: 
-- Module Name: test_reg - Behavioral
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

entity test_reg is
  Port ( 
  clk: in std_logic
  );
end test_reg;

architecture Behavioral of test_reg is
signal rst:std_logic;
signal re:std_logic;
signal we:std_logic;
signal rd_data_in:std_logic_vector(31 downto 0);
signal rd_addr:std_logic_vector(4 downto 0);
signal rs1_addr:std_logic_vector(4 downto 0);
signal rs2_addr:std_logic_vector(4 downto 0);
signal rs1_data:std_logic_vector(31 downto 0);
signal rs2_data:std_logic_vector(31 downto 0);

file file_pointer:text;

begin

dut: entity work.reg port map(
  clk => clk,
  rst => rst,
  re => re,
  we => we,
  rd_data_in => rd_data_in,
  rd_addr => rd_addr,
  rs1_addr => rs1_addr,
  rs2_addr => rs2_addr,
  rs1_data => rs1_data,
  rs2_data => rs2_data
);

    process 
        variable file_line:line;
        variable r:std_logic_vector(4 downto 0);
        variable data:std_logic_vector(31 downto 0);
        variable data_space:character;
    begin
        file_open(file_pointer,"test_reg.txt",read_mode);
        rst <= '0';
        re <= '0';
        we <= '0';
        rd_data_in <= (others => '0');
        rd_addr <= (others => '0');
        rs1_addr <= (others => '0');
        rs2_addr <= (others => '0');
        wait for 10ns;
        rst <= '1';
        while not endfile(file_pointer) loop    
            readline(file_pointer,file_line);
            read(file_line,r);
            read(file_line,data_space);
            read(file_line,data);
            rd_data_in <= data;
            rd_addr <= r;
            wait for 10ns;
            we <= '1';
            wait for 10ns;
            we <= '0';
            rs1_addr <= "00000";
            rs2_addr <= r;
            wait for 10ns;
            re <= '1';
            wait for 5ns;
            assert(rs1_data="00000000000000000000000000000000")report"R0 error"severity error;
            assert(rs2_data=data)report"Rx error"severity error;            
            wait for 5ns;
            re <= '0';
        end loop; 
            
    end process;

end Behavioral;
