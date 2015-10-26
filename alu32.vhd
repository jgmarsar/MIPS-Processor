library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu32 is
	port(
		ia : in std_logic_vector(31 downto 0);
		ib : in std_logic_vector(31 downto 0);
		control : in std_logic_vector(3 downto 0);
		shamt : in std_logic_vector(4 downto 0);
		shdir : in std_logic;
		sh16 : in std_logic;
		o : out std_logic_vector(31 downto 0);
		C : out std_logic;
		Z : out std_logic;
		V : out std_logic;
		S : out std_logic
	);
end alu32;

architecture ARC of alu32 is
	signal in1 : std_logic_vector(31 downto 0);
	signal cin : std_logic;
	signal sum : std_logic_vector(31 downto 0);
	signal Ctemp : std_logic;
	signal Vtemp : std_logic;
	signal o_temp : std_logic_vector(31 downto 0);
begin
	process(ia, ib, control, shamt, shdir, sh16, Ctemp, Vtemp, sum)
		variable temp_sum : std_logic_vector(31 downto 0); --necessary?
		--variable o_temp : std_logic_vector(31 downto 0);
	begin
		in1 <= (others => '0');
		cin <= '0';
		o_temp <= (others => '0');
		C <= '0';
		V <= '0';
		case control is
			when "0000" => --AND
				o_temp <= ia and ib;
			when "0001" => --OR
				o_temp <= ia or ib;
			when "0010" => --add
				in1 <= ib;
				cin <= '0';
				o_temp <= sum;
				C <= Ctemp;
				V <= Vtemp;
			when "0011" => --shift
				if (sh16 = '1') then
					o_temp <= std_logic_vector(unsigned(ib) sll 16);
				elsif (shdir = '0') then
					o_temp <= std_logic_vector(unsigned(ib) sll to_integer(unsigned(shamt)));
				else
					o_temp <= std_logic_vector(unsigned(ib) srl to_integer(unsigned(shamt)));
				end if;
			when "0110" => --subtract
				in1 <= not ib;
				cin <= '1';
				o_temp <= sum;
				C <= Ctemp;
				V <= Vtemp;
			when "0111" => --signed slt
				in1 <= not ib;
				cin <= '1';
				temp_sum := sum;
				if (temp_sum(31) = '1') then
					--if output is negative, a < b
					o_temp <= std_logic_vector(to_unsigned(1, 32));
				end if;	
				C <= Ctemp;
				V <= Vtemp;
			when "1100" =>
				o_temp <= ia nor ib;
			when "1111" =>
				in1 <= not ib;
				cin <= '1';
				if (Ctemp = '0') then
					--if carry out is 0, a < b (for unsigned subtraction)
					o_temp <= std_logic_vector(to_unsigned(1, 32));
				end if;	
				C <= Ctemp;
				V <= Vtemp;
			when others => null;
		end case;		 
	end process;
	
	S <= o_temp(31);
	o <= o_temp;
	with o_temp select
		Z <=
			'1' when x"00000000",
			'0' when others;
	

	U_ADD : entity work.add32
		port map(
			in0  => ia,
			in1  => in1,
			cin  => cin,
			sum  => sum,
			cout => Ctemp,
			V    => Vtemp
		);
	
end ARC;
