library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_control is
	port (
		BEQ : in std_logic;
		BNE : in std_logic;
		Z : in std_logic;
		branch : out std_logic
	);
end entity branch_control;

architecture RTL of branch_control is
	
begin
	branch <= (BEQ and Z) or (BNE and (not Z));
end architecture RTL;
