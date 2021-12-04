--Final PJ by zy2158 N16950767
--VHDL
--Control Unit

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity Control_Unit is
	port (
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
			opcode:			out std_logic_vector(6 downto 0)
		);

end Control_Unit;

architecture CTU of Control_Unit is
	--defin states for FSM
	type s_type is (st_idle, st_ifid, st_readreg, st_alu, st_mem, st_writeback, st_pc);
	signal state: s_type:=st_idle;
	--decode signals
	signal ins_opcode: std_logic_vector(6 downto 0);
	signal ins_funct: std_logic_vector(2 downto 0);
	signal end_of_execution: std_logic:='0';
	signal is_brench: std_logic:='0';
	signal is_auipc: std_logic:='0';
	signal is_jalr: std_logic:='0';
	signal is_jal: std_logic:='0';
	signal is_load: std_logic:='0';
	signal is_store: std_logic:='0';


begin
	FSM: PROCESS(rst, clk) BEGIN
		if (rst='0') then
			state<=st_idle;
			--end_of_execution<='0';
		elsif (clk'EVENT and clk='1') then
			if (end_of_execution='0') then
				case(state) is
					when st_idle => 
						state<=st_ifid;
					when st_ifid => 
						state<=st_readreg;
					when st_readreg => 
						state<=st_alu;
					when st_alu => 
						state<=st_mem;
					when st_mem => 
						state<=st_writeback;
					when st_writeback => 
						state<=st_pc;
					when st_pc => 
						state<=st_ifid;

					when others =>
						null;
				end case;
			else
				state<=st_idle;
			end if;
		end if;
	END PROCESS FSM;

--------------------------------------------------Instruction Fetch and decode
	PROCESS(state) begin
		if (state=st_ifid) then
			rd_im<='1';
		else
			rd_im<='0';
		end if;
	END PROCESS;
	ins_opcode <= instruction(6 downto 0);
	ins_funct <= instruction(14 downto 12);
	opcode <= ins_opcode;
	funct3 <= ins_funct;

--------------------------------------------------Implement HALT for ECALL and EBREAK
	PROCESS(clk, state) begin
	   if(clk'EVENT and clk='1') then
		if (state=st_ifid or state=st_readreg) then
		      if(ins_opcode="1110011") then
			     end_of_execution<='1';
			  end if;
		elsif(state=st_idle) then
		      if(rst='0') then
		          end_of_execution<='0';
		      end if;
		end if;
        end if;
	END PROCESS;

--------------------------------------------------read regfile nomater what's the address  
	PROCESS(state) begin
		if (state=st_readreg) then
			if (ins_opcode(3 downto 0)="0011") then
				re_regfile<='1';
			elsif (ins_opcode="1100111") then
				re_regfile<='1';
			else
				re_regfile<='0';
			end if;
		else
			re_regfile<='0';
		end if;
	END PROCESS;

--------------------------------------------------Do ALU operations
	--handling branching
	PROCESS(ins_opcode) begin
		is_brench<='0';
		is_auipc<='0';
		is_jalr<='0';
		is_jal<='0';
		if (ins_opcode="1100011") then
			is_brench<='1';
		end if;
		if (ins_opcode="0010111") then
			is_auipc<='1';
		end if;
		if (ins_opcode="1100111") then
			is_jalr<='1';
		end if;
		if (ins_opcode="1101111") then
			is_jal<='1';
		end if;
	END PROCESS;
	op_bc <= is_brench & ins_funct;
	s_pc_in <= is_jalr or is_jal or (is_brench and bc);

	--ALU input selection
	s_rs1 <= is_auipc or is_jal or is_brench;
	PROCESS(ins_opcode) begin
		case ins_opcode is
			when "0110111"=>s_rs2<='1';
			when "0010111"=>s_rs2<='1';
			when "1101111"=>s_rs2<='1';
			when "1100111"=>s_rs2<='1';
			when "1100011"=>s_rs2<='1';
			when "0000011"=>s_rs2<='1';
			when "0100011"=>s_rs2<='1';
			when "0010011"=>s_rs2<='1';
			when others=>s_rs2<='0';
		end case;
	END PROCESS;

	--immdiate number extention
	PROCESS(ins_opcode) begin
		case ins_opcode is
			when "0110111"=>op_imm_ext<="101";
			when "0010111"=>op_imm_ext<="101";
			when "1101111"=>op_imm_ext<="001";
			when "1100111"=>op_imm_ext<="010";
			when "1100011"=>op_imm_ext<="011";
			when "0000011"=>op_imm_ext<="010";
			when "0100011"=>op_imm_ext<="100";
			when "0010011"=>op_imm_ext<="010";
			when "0110011"=>op_imm_ext<="000";
			when others=>op_imm_ext<="000";
		end case;
	END PROCESS;

	--ALU operation
	PROCESS(clk) begin
	if(clk'EVENT and clk='1') then
		if (ins_opcode="0110111") then		--LUI
			op_alu<="00000";
		elsif (ins_opcode="0010111") then	--AUIPC
			op_alu<="00001";
		elsif (ins_opcode="1101111") then	--JAL
			op_alu<="00010";
		elsif (ins_opcode="1100111") then	--JALR
			op_alu<="00011";
		elsif (ins_opcode="1100011") then	--Branch
			op_alu<="00100";
		elsif (ins_opcode="0000011") then	--Load
			op_alu<="00101";
		elsif (ins_opcode="0100011") then	--Store
			op_alu<="00110";
		elsif (ins_opcode="0010011") then	--operation with Immediate Number
			if (ins_funct="000") then		--ADDI
				op_alu<="00111";
			elsif (ins_funct="010") then	--SLTI
				op_alu<="01000";
			elsif (ins_funct="011") then	--SLTIU
				op_alu<="01001";
			elsif (ins_funct="100") then	--XORI
				op_alu<="01010";
			elsif (ins_funct="110") then	--ORI
				op_alu<="01011";
			elsif (ins_funct="111") then	--ANDI
				op_alu<="01100";
			elsif (ins_funct="001") then	--SLLI
				op_alu<="01101";
			elsif (ins_funct="101") then
				if (instruction(30)='0') then	--SRLI
					op_alu<="01110";
				else							--SRAI
					op_alu<="01111";
				end if;	
			end if;
		elsif (ins_opcode="0110011") then	--operation with no Immediate Number
			if (ins_funct="000") then		
				if (instruction(30)='0') then	--ADD
					op_alu<="00111";
				else							--SUB
					op_alu<="10000";
				end if;	
			elsif (ins_funct="010") then	--SLT
				op_alu<="01000";
			elsif (ins_funct="011") then	--SLTU
				op_alu<="01001";
			elsif (ins_funct="100") then	--XOR
				op_alu<="01010";
			elsif (ins_funct="110") then	--OR
				op_alu<="01011";
			elsif (ins_funct="111") then	--AND
				op_alu<="01100";
			elsif (ins_funct="001") then	--SLL
				op_alu<="01101";
			elsif (ins_funct="101") then
				if (instruction(30)='0') then	--SRL
					op_alu<="01110";
				else							--SRAI
					op_alu<="01111";
				end if;	
			end if;
		elsif (ins_opcode="0001111") then	--FENCE/NOP
			op_alu<="10001";
		elsif (ins_opcode="1110011") then	--FENCE/NOP
			op_alu<="10010";
		else
			op_alu<="00000";
		end if;
		end if;
	END PROCESS;

--------------------------------------------------Access memory
	PROCESS(ins_opcode) begin
		is_load<='0';
		is_store<='0';
		if (ins_opcode="0000011") then
			is_load<='1';
		elsif (ins_opcode="0100011") then
			is_store<='1';
		end if;
	END PROCESS;
	rd_dm <= is_load;
	s_data_ext <= is_load;
	PROCESS(state) begin
		if (state=st_mem) then
			if (is_load='1' or is_store='1') then
				case ins_funct(1 downto 0) is
				    when "00" => mc <= "01";
				    when "01" => mc <= "10";
				    when "10" => mc <= "11";
				    when others => mc <= "00";
				end case;
			else
				mc<="00";
			end if;
		else
			mc<="00";
		end if;
	END PROCESS;

--------------------------------------------------Write back to regfile
	s_rd_data_in <= is_jal or is_jalr;
	PROCESS(state) begin
		if (state=st_writeback) then
			case ins_opcode is
				when "0110111"=>we_regfile<='1';
				when "0010111"=>we_regfile<='1';
				when "1101111"=>we_regfile<='1';
				when "1100111"=>we_regfile<='1';
				when "0000011"=>we_regfile<='1';
				when "0010011"=>we_regfile<='1';
				when "0110011"=>we_regfile<='1';
				when others=>we_regfile<='0';
			end case;
		else
			we_regfile<='0';
		end if;
	END PROCESS;

--------------------------------------------------Update PC
	PROCESS(state) begin
		if (state=st_pc) then
			we_pc<='1';
		else
			we_pc<='0';
		end if;
	END PROCESS;	

end CTU;


























