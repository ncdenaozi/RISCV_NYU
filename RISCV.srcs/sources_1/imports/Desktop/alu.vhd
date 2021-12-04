----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/11/17 10:25:56
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
  Port ( 
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
  bc: out std_logic
  );
end alu;

architecture Behavioral of alu is

signal alu_1:std_logic_vector(31 downto 0);
signal alu_2:std_logic_vector(31 downto 0);
signal ext:std_logic_vector(31 downto 0);

begin

--process(clk, rst) begin
--    if(rst='0')then
--        alu_1 <= (others => '0');
--    elsif(clk'event and clk='1')then
--    case s_rs1 is
--        when '0' => alu_1 <= rs1_data;
--        when '1' => alu_1 <= pc_out;
--        when others => alu_1 <= (others => '0');
--    end case;
--    end if;
--end process;

process(rst, s_rs1, pc_out, rs1_data)begin
    if(rst='0')then
        alu_1 <= (others => '0');
    else
        case s_rs1 is
            when '0' => alu_1 <= rs1_data;
            when '1' => alu_1 <= pc_out;
            when others => alu_1 <= (others => '0');
        end case;
    end if;
end process;

--process(clk, rst) begin
--    if(rst='0')then
--        alu_2 <= (others => '0');
--    elsif(clk'event and clk='1')then
--    case s_rs2 is
--        when '0' => alu_2 <= rs2_data;
--        when '1' => alu_2 <= ext;
--        when others => alu_2 <= (others => '0');
--    end case;
--    end if;
--end process;

process(rst, s_rs2, rs2_data, ext) begin
    if(rst='0')then
        alu_2 <= (others => '0');
    else
        case s_rs2 is
            when '0' => alu_2 <= rs2_data;
            when '1' => alu_2 <= ext;
            when others => alu_2 <= (others => '0');
        end case;
    end if;
end process;

process(op_bc, rs1_data, rs2_data, rst) begin
    if(rst='0')then
        bc <= '0';
    else
    case op_bc(3) is
        when '1' => 
            case op_bc(2 downto 0) is
                when "000" => 
                    if(unsigned(rs1_data)=unsigned(rs2_data))then
                        bc <= '1';
                    else
                        bc <= '0';
                    end if;
                when "001" =>
                    if(unsigned(rs1_data)=unsigned(rs2_data))then
                        bc <= '0';
                    else
                        bc <= '1';
                    end if;
                when "100" =>
                    if(signed(rs1_data)<signed(rs2_data))then
                        bc <= '1';
                    else
                        bc <= '0';
                    end if;
                when "101" =>
                    if(signed(rs1_data)>=signed(rs2_data))then
                        bc <= '1';
                    else
                        bc <= '0';
                    end if;
                when "110" =>
                    if(unsigned(rs1_data)<unsigned(rs2_data))then
                        bc <= '1';
                    else
                        bc <= '0';
                    end if;
                when "111" =>
                    if(unsigned(rs1_data)>=unsigned(rs2_data))then
                        bc <= '1';
                    else
                        bc <= '0';
                    end if;
                when others => bc <= '0';
            end case;
        when others => bc <= '0';
    end case;
    end if;
end process;

process(instr_alu, rst) begin
    if(rst='0')then
        ext <= (others => '0');
    else
    case op_ext is
        when "001" =>
            if(instr_alu(31)='0')then
                ext <= "00000000000" & instr_alu(31) & instr_alu(19 downto 12) & instr_alu(20) & instr_alu(30 downto 21) & '0';
            else
                ext <= "11111111111" & instr_alu(31) & instr_alu(19 downto 12) & instr_alu(20) & instr_alu(30 downto 21) & '0';
            end if;
        when "010" =>
            if(instr_alu(31)='0')then
                ext <= "00000000000000000000" & instr_alu(31 downto 20);
            else
                ext <= "11111111111111111111" & instr_alu(31 downto 20);
            end if;
        when "011" =>
            if(instr_alu(31)='0')then
                ext <= "0000000000000000000" & instr_alu(31) & instr_alu(7) & instr_alu(30 downto 25) & instr_alu(11 downto 8) & '0';
            else
                ext <= "1111111111111111111" & instr_alu(31) & instr_alu(7) & instr_alu(30 downto 25) & instr_alu(11 downto 8) & '0';
            end if;
        when "100" =>
            if(instr_alu(31)='0')then
                ext <= "00000000000000000000" & instr_alu(31 downto 25) & instr_alu(11 downto 7);
            else
                ext <= "11111111111111111111" & instr_alu(31 downto 25) & instr_alu(11 downto 7);
            end if;
        when "101" =>
            if(instr_alu(31)='0')then
                ext <= "000000000000" & instr_alu(31 downto 12);
            else
                ext <= "111111111111" & instr_alu(31 downto 12);
            end if;
        when others => ext <= (others => '0');
    end case;
    end if;
end process;

process(alu_1, alu_2, op_alu, rst) begin
    if(rst='0')then
        alu_out <= (others => '0');
    else
    case op_alu is
        when "00000" =>
            alu_out <= alu_2(19 downto 0) & "000000000000";
        when "00001" =>
            alu_out <= std_logic_vector(unsigned(alu_2(19 downto 0) & "000000000000") + to_unsigned(to_integer(unsigned(alu_1))-4, 32));
        when "00010" =>
            --alu_out <= std_logic_vector(unsigned(alu_2(19 downto 0) & '0') + unsigned(alu_1));
            alu_out <= std_logic_vector(unsigned(alu_2) + unsigned(alu_1));
        when "00011" =>
            alu_out <= std_logic_vector(unsigned(alu_2(11 downto 0)) + unsigned(alu_1));
        when "00100" =>
            --alu_out <= std_logic_vector(unsigned(alu_2(11 downto 0) & '0') + unsigned(alu_1));
            alu_out <= std_logic_vector(unsigned(alu_2) + unsigned(alu_1));
        when "00101" =>
            alu_out <= std_logic_vector(unsigned(alu_2) + unsigned(alu_1));
        when "00110" =>
            alu_out <= std_logic_vector(unsigned(alu_2) + unsigned(alu_1));
        when "00111" =>
            alu_out <= std_logic_vector(unsigned(alu_2) + unsigned(alu_1));
        when "01000" =>
            if(signed(alu_1)<signed(alu_2))then
                alu_out <= "00000000000000000000000000000001";
            else
                alu_out <= "00000000000000000000000000000000";
            end if;
        when "01001" =>
            if(unsigned(alu_1)<unsigned(alu_2))then
                alu_out <= "00000000000000000000000000000001";
            else
                alu_out <= "00000000000000000000000000000000";
            end if;
        when "01010" =>
            alu_out <= alu_1 xor alu_2;
        when "01011" =>
            alu_out <= alu_1 or alu_2;
        when "01100" =>
            alu_out <= alu_1 and alu_2;
        when "01101" =>
            alu_out <= std_logic_vector(unsigned(alu_1) sll to_integer(unsigned(alu_2)));
        when "01110" =>
            alu_out <= std_logic_vector(unsigned(alu_1) srl to_integer(unsigned(alu_2)));
        when "01111" =>
            --alu_out <= std_logic_vector(signed(alu_1) srl to_integer(unsigned(alu_2)));
            alu_out <= std_logic_vector( shift_right(signed(alu_1), to_integer(unsigned(alu_2(4 downto 0)))) );
        when "10000" =>
            alu_out <= std_logic_vector(unsigned(alu_1) - unsigned(alu_2));
        --when "10001" =>
        --when "10010" =>
        when others => alu_out <= (others => '0');
    end case;
    end if;
end process;

end Behavioral;
