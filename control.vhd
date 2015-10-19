library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port (
		opcode : in std_logic_vector(5 downto 0);
		ALUop : out std_logic_vector(2 downto 0);
		wr : out std_logic;
		ALUSrc : out std_logic;
		regDst : out std_logic;
		ext_sel : out std_logic
	);
end entity control;

architecture BHV of control is
	--regDst select
	constant C_RT : std_logic := '0';
	constant C_RD : std_logic := '1';
	--ALUSrc select
	constant C_Q1 : std_logic := '0';
	constant C_IMM : std_logic := '1';
	--ext_sel select
	constant C_ZERO : std_logic := '0';
	constant C_SIGN : std_logic := '1';
begin
	process(opcode)
	begin
		ALUop <= "000";
		wr <= '0';
		ALUSrc <= '0';
		regDst <= '0';
		ext_sel <= '0';
		
		case opcode is
			when "000000" =>			--R-type
				ALUop <= "010";
				wr <= '1';
				ALUSrc <= C_Q1;
				regDst <= C_RD;
			when "001000" =>			--ADDI
				ALUop <= "000";
				wr <= '1';
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
			when "001001" =>			--ADDIU
				ALUop <= "000";
				wr <= '1';
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
			when others => null;
		end case;
		
	end process;
end architecture BHV;

