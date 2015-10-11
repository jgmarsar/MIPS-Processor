library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port (
		opcode : in std_logic_vector(5 downto 0);
		ALUop : out std_logic_vector(2 downto 0);
		wr : out std_logic
	);
end entity control;

architecture BHV of control is
	
begin
	process(opcode)
	begin
		ALUop <= "000";
		wr <= '0';
		
		case opcode is
			when "000000" =>
				ALUop <= "010";
				wr <= '1';
			when others => null;
		end case;
		
	end process;
end architecture BHV;

