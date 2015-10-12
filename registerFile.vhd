library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFile is
	port(
		rr0 : in std_logic_vector(4 downto 0);
		rr1 : in std_logic_vector(4 downto 0);
		rw : in std_logic_vector(4 downto 0);
		d : in std_logic_vector(31 downto 0);
		clk : in std_logic;
		wr : in std_logic;
		rst : in std_logic;
		
		q0 : out std_logic_vector(31 downto 0);
		q1 : out std_logic_vector(31 downto 0)
	);
end registerFile;

architecture BHV of registerFile is
	type registerarray is array(31 downto 0) of std_logic_vector(31 downto 0);
	signal ra: registerarray;
begin
	process(rr0, rr1, ra)
	begin
		q0 <= ra(to_integer(unsigned(rr0)));
		q1 <= ra(to_integer(unsigned(rr1)));
	end process;
	
	process(clk, wr, rst, rw)
	begin
		if (rst = '1') then
			for i in 1 to 31 loop
				ra(i) <= (others => '0');
			end loop;
		elsif (rising_edge(clk) and (wr='1') and (rw /= "00000")) then
			ra(to_integer(unsigned(rw))) <= d;
		end if;
		ra(0) <= (others => '0');		--register 0 always contains zero
	end process;
end BHV;