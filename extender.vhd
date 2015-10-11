library ieee;
use ieee.std_logic_1164.all;

entity extender is
	port (
		in0 : in std_logic_vector(15 downto 0);
        Sel : in std_logic;
		out0 : out std_logic_vector(31 downto 0)
	);
end extender;

architecture STR of extender is
    signal zeroext_out : std_logic_vector(31 downto 0);
    signal signext_out : std_logic_vector(31 downto 0);
begin
			
    U_ZERO : entity work.zeroext
    port map (
        in0 => in0,
		out0 => zeroext_out);
        
    U_SIGN : entity work.signext
    port map (
        in0 => in0,
		out0 => signext_out);
        
    U_MUX : entity work.mux32
    port map (
        in0 => zeroext_out,
		in1 => signext_out,
		Sel => Sel,
		O => out0);
            
end STR;