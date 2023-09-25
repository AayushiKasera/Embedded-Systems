----------------------------------------------------------------------------------
-- Company: Digilent Inc 2011
-- Engineer: Michelle Yu  
-- Create Date:      17:18:24 08/23/2011 
--
-- Module Name:    Decoder - Behavioral 
-- Project Name:  PmodKYPD
-- Target Devices: Nexys3
-- Tool versions: Xilinx ISE 13.2
-- Description: 
--	This file defines a component Decoder for the demo project PmodKYPD. 
-- The Decoder scans each column by asserting a low to the pin corresponding to the column 
-- at 1KHz. After a column is asserted low, each row pin is checked. 
-- When a row pin is detected to be low, the key that was pressed could be determined.
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decoder is
    Port (
			  clk : in  STD_LOGIC;
          Row : in  STD_LOGIC_VECTOR (3 downto 0);
			 Col : out  STD_LOGIC_VECTOR (3 downto 0);
		   press :out std_logic; --1 if something is pressed 
           DecodeOut : out STD_LOGIC_VECTOR (3 downto 0));
end Decoder;

architecture Behavioral of Decoder is


    
signal LAG : integer := 10;                   
	signal scan_timer :std_logic_vector(19 downto 0);                  
	signal col_select :std_logic_vector(1 downto 0);   
	signal col_press :std_logic := '0';       
	
begin


	process
	begin
	if clk'event and clk = '1' then       
		if(to_integer(unsigned(scan_timer)) = 99999) then   
			scan_timer <= "00000000000000000000";
			col_select <= std_logic_vector(unsigned(col_select) + 1);
		
		else
			scan_timer <= std_logic_vector(unsigned(scan_timer) + 1);
	    end if;
	end if;

   
	if clk'event and clk = '1' then       
		case(col_select) is
			when "00" =>
					   col <= "0111";
					  --press <= '0';
					   if (to_integer(unsigned(scan_timer)) = 10) then
						  case (row) is
						  
						        when   "0111" =>	DecodeOut <= "0001"; col_press <= '1';--"00110001";--"0001"; 1
						        when   "1011" =>	DecodeOut <="0100";  col_press <= '1';-- "00110100";--"0100"; 4
						        when   "1101" =>	DecodeOut <="0111";  col_press <= '1';-- "00110111";--"0111"; 7
						        when   "1110" =>	DecodeOut <="0000";  col_press <= '1';--"00110000";--"0000"; 
						      --  when    "1111" =>   col_press <= '0';
						        when others => col_press <= '0';   
						  end case;
					   end if;
		    when "01" =>
					   col <= "1011";
					 --  press <= '1';
					   if(to_integer(unsigned(scan_timer)) = 10) then
						  case (row) is
						        when   "0111" =>	DecodeOut <= "0010"; col_press <= '1';--"00110010"; ---"0010";
						        when   "1011" =>	DecodeOut <= "0101"; col_press <= '1';--"00110101";--"0101";
						        when   "1101" =>	DecodeOut <= "1000"; col_press <= '1';--"00111000";-- "1000";
						        when   "1110" =>	DecodeOut <= "1111"; col_press <= '1';--"01000110";-- "1111";
						        
						      --  when    "1111" =>   press <= '0';
						        when others => null;     
						  end case;
					   end if;
	        when "10" =>
					   col <= "1101";
					  -- press <= '1';
					   if(to_integer(unsigned(scan_timer)) = 10) then
						  case (row) is
						        when   "0111" =>	DecodeOut <= "0011"; col_press <= '1';--"00110011";--"0011";
						        when   "1011" =>	DecodeOut <= "0110"; col_press <= '1';-- "00110100";-- "0110";
						        when   "1101" =>	DecodeOut <= "1001"; col_press <= '1';--"00111001" ;--"1001";
						        when   "1110" =>	DecodeOut <= "1110"; col_press <= '1';--"01000101"; --"1110";
						        --when    "1111" =>   press <= '0';
						        when others => null;     
						  end case;
					   end if;
		    when "11" =>
					   col <= "1110";
					 --  press <= '1';
					   if(to_integer(unsigned(scan_timer)) = 10) then
					   
						  case (row) is
						        when   "0111" =>	DecodeOut <= "1010"; press <= '1';--"01000001";--"1010";
						        when   "1011" =>	DecodeOut <= "1011"; press <= '1';--"01000010"; --"1011";
						        when   "1101" =>	DecodeOut <="1100"; press <= '1';-- "01000011";--"1100";
						        when   "1110" =>	DecodeOut <= "1101"; press <= '1';--"01000100";--"1101";
						        --when    "1111" =>   
						        when others => press <= col_press;    
						  end case;
					   end if;
		
        end case;
        end if;
       
		end process;
	 
						 
end Behavioral;





