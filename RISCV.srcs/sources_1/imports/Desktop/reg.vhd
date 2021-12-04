----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/11/17 10:25:43
-- Design Name: 
-- Module Name: reg - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg is
  Port (
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
end reg;

architecture Behavioral of reg is
type rom is array(0 to 31) of std_logic_vector(31 downto 0);
signal r: rom;

begin

process(rst, we)begin
    if(rst='0')then
        for n in 0 to 31 loop
            r(n) <= (others => '0');
        end loop;
    elsif(we'event and we='1')then
        r(to_integer(unsigned(rd_addr))) <= rd_data_in;
    end if;
end process;

process(rst, re)begin
    if(rst='0')then
        rs1_data <= (others => '0');
        rs2_data <= (others => '0');
    elsif(re'event and re='1')then
        rs1_data <= r(to_integer(unsigned(rs1_addr)));
        rs2_data <= r(to_integer(unsigned(rs2_addr)));
    end if;
end process;


end Behavioral;
