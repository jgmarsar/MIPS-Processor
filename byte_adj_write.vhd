library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity byte_adj_write is
	port (
		dataIn : in std_logic_vector(31 downto 0);
		byteEnable : in std_logic_vector(3 downto 0);
		dataOut : out std_logic_vector(31 downto 0)
	);
end entity byte_adj_write;

architecture BHV of byte_adj_write is
begin
	process(dataIn, byteEnable)
	begin
		dataOut <= x"00000000";
		if (byteEnable(0) = '1') then			--data being stored in lowest byte of word; no shift necessary
			dataOut <= dataIn;
		elsif (byteEnable(1) = '1') then		--data being stored in second byte of word; shift data left one byte
			dataOut <= std_logic_vector(unsigned(dataIn) sll 8);
		elsif (byteEnable(2) = '1') then		--data being stored in third byte of word; shift data left two bytes
			dataOut <= std_logic_vector(unsigned(dataIn) sll 16);
		elsif (byteEnable(3) = '1') then		--data being stored in highest byte of word; shift data left three bytes
			dataOut <= std_logic_vector(unsigned(dataIn) sll 24);
		end if;
	end process;
end BHV;
