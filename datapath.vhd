library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	port (
		clk : in std_logic;
		mclk : in std_logic;
		rst : in std_logic
	);
end entity datapath;

architecture STR of datapath is
	--Program Counter signals
	signal PC : std_logic_vector(31 downto 0);
	signal PC_next : std_logic_vector(31 downto 0);
	
	signal instruction : std_logic_vector(31 downto 0);
	
	--control signals
	signal ALUop : std_logic_vector(2 downto 0);
	signal regWrite : std_logic;
	
	--register file signals
	signal q0 : std_logic_vector(31 downto 0);
	signal q1 : std_logic_vector(31 downto 0);
	
	--ALU I/O signals
	signal shdir : std_logic;
	signal ALUcont : std_logic_vector(3 downto 0);
	signal ALUout : std_logic_vector(31 downto 0);
	signal C : std_logic;
	signal V : std_logic;
	signal S : std_logic;
	signal Z : std_logic;
	
begin
	--INSTRUCTION FETCH
	U_PC : entity work.reg32
		generic map(
			reset => x"00400000"
		)
		port map(
			D   => PC_next,
			wr  => '1',
			Clk => clk,
			clr => rst,
			Q   => PC
		);
		
	U_ADD4 : entity work.add32
		port map(
			in0  => PC,
			in1  => x"00000004",
			cin  => '0',
			sum  => PC_next,
			cout => open,
			V    => open
		);
		
	U_INST_MEM : entity work.inst_mem
		port map(
			address => PC(9 downto 2),			--8-bit address; increments of 4 only, so ignore lowest 2 bits
			clock   => mclk,
			data    => (others => '0'),
			wren    => '0',
			q       => instruction
		);
		
	--INSTRUCTION DECODE
	U_REGS : entity work.registerFile
		port map(
			rr0 => instruction(25 downto 21),	--source register
			rr1 => instruction(20 downto 16),	--source register
			rw  => instruction(15 downto 11),	--destination register
			d   => ALUout,
			clk => clk,
			wr  => regWrite,
			rst => rst,
			q0  => q0,
			q1  => q1
		);
		
	U_CONTROL : entity work.control
		port map(
			opcode => instruction(31 downto 26),
			ALUop  => ALUop,
			wr     => regWrite
		);
		
	U_ALU_CONT : entity work.alu32control
		port map(
			ALUop   => ALUop,
			func    => instruction(5 downto 0),
			control => ALUcont,
			shdir   => shdir
		);
		
	--INSTRUCTION EXECUTE
	U_ALU : entity work.alu32
		port map(
			ia      => q0,
			ib      => q1,
			control => ALUcont,
			shamt   => instruction(10 downto 6),
			shdir   => shdir,
			o       => ALUout,
			C       => C,
			Z       => Z,
			V       => V,
			S       => S
		);
	
end architecture STR;

