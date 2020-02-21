----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2020 04:13:28 PM
-- Design Name: 
-- Module Name: test_max_pool_72 - Behavioral
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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_max_pool_72 IS
END test_max_pool_72;
 
ARCHITECTURE behavior OF test_max_pool_72 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT max_pool_72
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         in72 : IN  std_logic_vector(71 downto 0);
         out18 : OUT  std_logic_vector(17 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal in72 : std_logic_vector(71 downto 0) := (others => '0');

 	--Outputs
   signal out18 : std_logic_vector(17 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: max_pool_72 PORT MAP (
          clk => clk,
          rst => rst,
          in72 => in72,
          out18 => out18
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
 wait for 100 ns;	    -- insert stimulus here 
			in72 <= "000000000000000000001000000000000000100000000000000001100000000000000100";
			rst <= '0';
    
	 wait for 100 ns;	
			rst <= '1';
      wait;
   end process;

END;
