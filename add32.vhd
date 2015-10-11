library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add32 is
  port (
    in0     : in  std_logic_vector(31 downto 0);
    in1     : in  std_logic_vector(31 downto 0);
    cin     : in  std_logic;
    sum     : out std_logic_vector(31 downto 0);
    cout    : out std_logic;
    V		: out std_logic);
end add32;

architecture BHV of add32 is 
	signal carry : std_logic_vector(32 downto 0);
begin
    
    carry(0) <= cin;
    
    GEN_FA : for i in 0 to 31 generate
    	U_FA : entity work.fa
    		port map(
    			input1    => in0(i),
    			input2    => in1(i),
    			carry_in  => carry(i),
    			sum       => sum(i),
    			carry_out => carry(i+1)
    		);
    end generate GEN_FA;
    
    cout <= carry(32);
    
    process(carry)
    begin
    	if (carry(31) /= carry(32)) then
    		--overflow
    		V <= '1';
    	else
    		V <= '0';
    	end if;
    end process;
end BHV;