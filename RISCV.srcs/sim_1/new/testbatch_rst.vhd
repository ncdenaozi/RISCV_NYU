----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/12/09 13:28:34
-- Design Name: 
-- Module Name: testbatch - Behavioral
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

entity testbatch is
  --Port ( );
end testbatch;

architecture Behavioral of testbatch is
signal rst: std_logic;
signal output: std_logic_vector(31 downto 0);
signal clk: std_logic;
begin

dut: entity work.TOP port map(
clk => clk,
debug_out => output,
rst => rst
);

process begin
    clk <= '0';
    wait for 5ns;
    clk <= '1';
    wait for 5ns;
end process;

process begin
    rst <= '0';
    wait for 10ns;
    rst <= '1';
    wait for 56580ns;
    assert(output=x"00000096")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000095")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000067")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000059")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000053")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000052")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000031")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000028")report"sort"severity failure;
    rst <= '0';
    wait for 10ns;
    rst <= '1';
    wait for 56580ns;
    assert(output=x"00000096")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000095")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000067")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000059")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000053")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000052")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000031")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000028")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000016")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000012")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000010")report"sort"severity failure;
    wait for 60ns;
    assert(output=x"00000007")report"sort"severity failure;
    wait for 29520ns;
    assert(output=x"12345678")report"rc5"severity failure;
    wait for 60ns;
    assert(output=x"9abcdef0")report"rc5"severity failure;

    report "$$$$$$$$All tests passed$$$$$$$$";
    std.env.stop;
end process;


end Behavioral;
