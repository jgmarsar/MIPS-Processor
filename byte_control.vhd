library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity byte_control is
	port (
		sizeSel : in std_logic_vector(1 downto 0);
		byteSel : in std_logic_vector(1 downto 0);
		byteEnable : out std_logic_vector(3 downto 0)
	);
end entity byte_control;

architecture BHV of byte_control is
	
begin
	process(sizeSel, byteSel)
	begin
		byteEnable <= "0000";
		if (sizeSel(1) = '1') then
			byteEnable <= "1111";		--word; enable all bytes
		else
			case byteSel is
				--byte or halfword; enable byte corresponding to lowest 2 bits of address (byteSel)
			when "00" =>
				byteEnable(0) <= '1';
				if (sizeSel(0) = '1') then
					byteEnable(1) <= '1';	--halfword, enable next highest byte
				end if;
			when "01" =>
				byteEnable(1) <= '1';
				if (sizeSel(0) = '1') then
					byteEnable(2) <= '1';	--halfword, enable next highest byte
				end if;
			when "10" =>
				byteEnable(2) <= '1';
				if (sizeSel(0) = '1') then
					byteEnable(3) <= '1';	--halfword, enable next highest byte
				end if;
			when "11" =>
				byteEnable(3) <= '1';
			when others => null;
			end case;
		end if;			
	end process;
	
end architecture BHV;

