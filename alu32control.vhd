library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu32control is
	port(
		ALUop : in std_logic_vector(2 downto 0);
		func : in std_logic_vector(5 downto 0);
		control : out std_logic_vector(3 downto 0);
		shdir : out std_logic;
		sh16 : out std_logic
	);
end alu32control;

architecture BHV of alu32control is
begin
	process(ALUop, func)
	begin
		control <= "0000";
		shdir <= '0';
		sh16 <= '0';
		case ALUop is
			when "000" => --addi, addiu, lbu, lhu, lw, sb, sh, sw (All imm add functions)
				control <= "0010";
			when "001" => --beq, bne (imm sub functions)
				control <= "0110";
			when "010" =>
				case func is
					when "000000" => --sll
						control <= "0011";
						shdir <= '0';
					when "000010" => --srl
						control <= "0011";
						shdir <= '1';
					when "001000" => --jr
						control <= "0010";
					when "100000" => --add
						control <= "0010";
					when "100001" => --addu
						control <= "0010";
					when "100010" => --sub
						control <= "0110";
					when "100011" => --subu
						control <= "0110";
					when "100100" => --and
						control <= "0000";
					when "100101" => --or
						control <= "0001";
					when "100111" => --nor
						control <= "1100";
					when "101010" => --slt
						control <= "0111";
					when "101011" => --sltu
						control <= "1111";
					when others => null;
				end case;
			when "011" => --andi
				control <= "0000";
			when "100" => --ori
				control <= "0001";
			when "101" => --slti
				control <= "0111";
			when "110" => --stliu
				control <= "1111";
			when "111" => --lui
				control <= "0011";
				sh16 <= '1';
			when others => null;
		end case;
		
	end process;
end BHV;