--Final PJ by zy2158 N16950767
--VHDL
--PC

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity PC is
	port (
			clk:		in std_logic:='0';
			rst:		in std_logic:='0';
			s_pc_in:		in std_logic:='0';
			s_rd_data_in:	in std_logic:='0';
			we_pc:		in std_logic:='0';
			
			alu_out:	in std_logic_vector(31 downto 0);
			rd_data:	in std_logic_vector(31 downto 0);

			rd_data_in:	out std_logic_vector(31 downto 0);
			pc_now:	out std_logic_vector(31 downto 0);
			pc_next:	out std_logic_vector(31 downto 0)
		);

end PC;

architecture pc_func of PC is
	signal pc_reg:		std_logic_vector(31 downto 0);
	signal pc_plus_4: 	std_logic_vector(31 downto 0);
	signal pc_temp: 	std_logic_vector(31 downto 0);
begin
	pc_plus_4 <= pc_reg + 4;
	process(s_rd_data_in, pc_plus_4, rd_data) begin
		case s_rd_data_in is
			when '1'=>rd_data_in<=pc_plus_4;
			when '0'=>rd_data_in<=rd_data;
			when others=>rd_data_in<=rd_data;
		end case;
	end process;


	process(s_pc_in, pc_plus_4, alu_out) begin
		case s_pc_in is
			when '1'=>pc_temp<=alu_out;
			when '0'=>pc_temp<=pc_plus_4;
			when others=>pc_temp<=pc_plus_4;
		end case;
	end process;

	process(clk,rst, we_pc) begin
		if (rst='0') then
			pc_reg <= "00000001000000000000000000000000";
		--elsif (we_pc='1') then
			elsif (we_pc'EVENT and we_pc='1') then
				pc_reg<=pc_temp;
			--end if;
		end if;
	end process;
	pc_now <= pc_reg;
	pc_next <= pc_plus_4;

end pc_func;