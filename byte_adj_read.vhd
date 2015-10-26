library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity byte_adj_read is
	port (
		dataIn : in std_logic_vector(31 downto 0);
		byteEnable : in std_logic_vector(3 downto 0);
		dataOut : out std_logic_vector(31 downto 0)
	);
end entity byte_adj_read;

architecture BHV of byte_adj_read is
begin
	process(dataIn, byteEnable)
		variable tempData : std_logic_vector(31 downto 0);
		
	begin
		tempData := x"00000000";
		if (byteEnable(0) = '1') then			--data being read from lowest byte of word; no shift necessary
			tempData := dataIn;
		elsif (byteEnable(1) = '1') then		--data being read from second byte of word; shift data right one byte before storage
			tempData := std_logic_vector(unsigned(dataIn) srl 8);
		elsif (byteEnable(2) = '1') then		--data being read from third byte of word; shift data right two bytes before storage
			tempData := std_logic_vector(unsigned(dataIn) srl 16);
		elsif (byteEnable(3) = '1') then		--data being read from highest byte of word; shift data right three bytes before storage
			tempData := std_logic_vector(unsigned(dataIn) srl 24);
		end if;
		
		if (byteEnable /= "1111") then			--need byte or halfword; must mask upper bytes
			if ((byteEnable(3 downto 2) = "11") or (byteEnable(2 downto 1) = "11") or (byteEnable(1 downto 0) = "11")) then
				--reading halfword; mask top two bytes
				tempData := tempData and x"0000FFFF";
			else 
				--reading byte, mask top 3 bytes
				tempData := tempData and x"000000FF";
			end if;
		end if;
		
		dataOut <= tempData;
	end process;
end BHV;
