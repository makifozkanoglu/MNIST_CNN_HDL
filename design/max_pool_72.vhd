----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2020 04:11:12 PM
-- Design Name: 
-- Module Name: max_pool_72 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity max_pool_72 is

port (clk, rst : in std_ulogic;
		in72 : in std_logic_vector (71 downto 0);
		out18 : out std_logic_vector (17 downto 0)
			);
			
end max_pool_72;

architecture Behavioral of max_pool_72 is

	signal matrix11, matrix12, matrix21, matrix22 : std_logic_vector (17 downto 0);
	signal larger1, larger2 : std_logic_vector (17 downto 0) := (others => '0');

begin

	matrix11 <= in72(71 downto 54);
	matrix12 <= in72(53 downto 36);
	matrix21 <= in72(35 downto 18);
	matrix22 <= in72(17 downto 0);


		process (matrix11, matrix12, matrix21, matrix22, larger1, larger2, clk, rst)
		begin 
		
			if rising_edge(clk) then
				if rst = '0' then
				
							if matrix11 > matrix12 then
								larger1 <= matrix11;
							elsif matrix12 > matrix11 then
								larger1 <= matrix12;
							end if;
		
							if matrix21 > matrix22 then
								larger2 <= matrix21;
							elsif matrix22 > matrix21 then
								larger2 <= matrix22;
							end if;
		
							if larger1 > larger2 then
								out18 <= larger1;
							elsif larger2 > larger1 then
								out18 <= larger2;
							end if;
				
				elsif rst ='1' then 
					out18 <= "000000000000000000";
				end if;
			end if;
		end process;
	

end Behavioral;
