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
	
	--instruction signals
	signal instruction : std_logic_vector(31 downto 0);
	signal ext_imm : std_logic_vector(31 downto 0);
	
	--control signals
	signal ALUop : std_logic_vector(2 downto 0);
	signal regWrite : std_logic;
	signal ALUSrc : std_logic;
	signal regDst : std_logic;
	signal ext_sel : std_logic;
	signal WriteDataSel : std_logic;
	signal MemWrite : std_logic;
	signal sizeSel : std_logic_vector(1 downto 0);
	
	--register file signals
	signal rw : std_logic_vector(4 downto 0);
	signal q0 : std_logic_vector(31 downto 0);
	signal q1 : std_logic_vector(31 downto 0);
	signal WBData : std_logic_vector(31 downto 0);
	
	--ALU I/O signals
	signal srcb : std_logic_vector(31 downto 0);
	signal shdir : std_logic;
	signal ALUcont : std_logic_vector(3 downto 0);
	signal ALUout : std_logic_vector(31 downto 0);
	signal C : std_logic;
	signal V : std_logic;
	signal S : std_logic;
	signal Z : std_logic;
	
	--data memory signals
	signal readData : std_logic_vector(31 downto 0);
	signal byteEnable : std_logic_vector(3 downto 0);
	signal writeData : std_logic_vector(31 downto 0);
	signal readDataAdj : std_logic_vector(31 downto 0);
	
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
			rw  => rw,							--destination register from MUX
			d   => WBData,
			clk => clk,
			wr  => regWrite,
			rst => rst,
			q0  => q0,
			q1  => q1
		);
		
	U_REG_MUX : entity work.mux5
		port map(
			in0 => instruction(20 downto 16),
			in1 => instruction(15 downto 11),
			Sel => regDst,
			O   => rw
		);
		
	U_CONTROL : entity work.control
		port map(
			opcode => instruction(31 downto 26),
			ALUop  => ALUop,
			wr     => regWrite,
			ALUSrc => ALUSrc,
			regDst => regDst,
			ext_sel => ext_sel,
			WriteDataSel => WriteDataSel,
			MemWrite => MemWrite,
			sizeSel => sizeSel
		);
		
	U_ALU_CONT : entity work.alu32control
		port map(
			ALUop   => ALUop,
			func    => instruction(5 downto 0),
			control => ALUcont,
			shdir   => shdir
		);
		
	U_EXT : entity work.extender
		port map(
			in0  => instruction(15 downto 0),		--immediate
			Sel => ext_sel,
			out0 => ext_imm
		);
		
	--INSTRUCTION EXECUTE
	U_ALU : entity work.alu32
		port map(
			ia      => q0,
			ib      => srcb,
			control => ALUcont,
			shamt   => instruction(10 downto 6),
			shdir   => shdir,
			o       => ALUout,
			C       => C,
			Z       => Z,
			V       => V,
			S       => S
		);
		
	U_ALU_MUX : entity work.mux32
		port map(
			in0 => q1,
			in1 => ext_imm,
			Sel => ALUSrc,
			O   => srcb
		);
	
	U_BYTE_CONT : entity work.byte_control
		port map(
			sizeSel    => sizeSel,
			byteSel    => ALUout(1 downto 0),
			byteEnable => byteEnable
		);
		
	U_BYTE_ADJ_WR : entity work.byte_adj_write
		port map(
			dataIn     => q1,
			byteEnable => byteEnable,
			dataOut    => writeData
		);
		
	--WRITE BACK
	U_DATA_MEM : entity work.data_mem
		port map(
			address => ALUout(9 downto 2),		--word addressed; ignore 2 LSBs
			byteena => byteEnable,
			clock   => mclk,
			data    => writeData,
			wren    => MemWrite,
			q       => readData
		);
		
	U_BYTE_ADJ_RD : entity work.byte_adj_read
		port map(
			dataIn     => readData,
			byteEnable => byteEnable,
			dataOut    => readDataAdj
		);
		
	U_WB_MUX : entity work.mux32
		port map(
			in0 => ALUout,
			in1 => readDataAdj,
			Sel => WriteDataSel,
			O   => WBData
		);
end architecture STR;

