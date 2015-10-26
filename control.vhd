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
		ext_sel : out std_logic;
		WriteDataSel : out std_logic;
		MemWrite : out std_logic;
		sizeSel : out std_logic_vector(1 downto 0)
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
	--WriteDataSel
	constant C_ALU : std_logic := '0';
	constant C_MEM : std_logic := '1';
	--byte sizeSel
	constant C_WORD : std_logic_vector(1 downto 0) := "10";
	constant C_HALF : std_logic_vector(1 downto 0) := "01";
	constant C_BYTE : std_logic_vector(1 downto 0) := "00";
begin
	process(opcode)
	begin
		ALUop <= "000";
		wr <= '0';
		ALUSrc <= '0';
		regDst <= '0';
		ext_sel <= '0';
		WriteDataSel <= '0';
		MemWrite <= '0';
		sizeSel <= "00";
		
		case opcode is
			when "000000" =>			--R-type
				ALUop <= "010";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_Q1;
				regDst <= C_RD;
			when "001000" =>			--ADDI
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
			when "001001" =>			--ADDIU
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
			when "001010" =>			--SLTI
				ALUop <= "101";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
			when "001011" =>			--SLTIU
				ALUop <= "110";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
			when "001100" =>			--ANDI
				ALUop <= "011";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
			when "001101" =>			--ORI
				ALUop <= "100";
				wr <= '1';
				WriteDataSel <= C_ALU;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_ZERO;
			when "100011" =>			--LW
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_MEM;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
				sizeSel <= C_WORD;
			when "100100" =>			--LBU
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_MEM;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
				sizeSel <= C_BYTE;
			when "100101" =>			--LHU
				ALUop <= "000";
				wr <= '1';
				WriteDataSel <= C_MEM;
				ALUSrc <= C_IMM;
				regDst <= C_RT;
				ext_sel <= C_SIGN;
				sizeSel <= C_HALF;
			when "101000" =>			--SB
				ALUop <= "000";
				ALUSrc <= C_IMM;
				ext_sel <= C_SIGN;
				MemWrite <= '1';
				sizeSel <= C_BYTE;
			when "101001" =>			--SH
				ALUop <= "000";
				ALUSrc <= C_IMM;
				ext_sel <= C_SIGN;
				MemWrite <= '1';
				sizeSel <= C_HALF;
			when "101011" =>			--SW
				ALUop <= "000";
				ALUSrc <= C_IMM;
				ext_sel <= C_SIGN;
				MemWrite <= '1';
				sizeSel <= C_WORD;
			when others => null;
		end case;
		
	end process;
end architecture BHV;

