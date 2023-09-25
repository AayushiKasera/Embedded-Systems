----------------------------------------------------------------------------------
-- Company:
-- Engineer:
-- 
-- Create Date: 04/29/2023 09:19:06 PM
-- Design Name:
-- Module Name: conversion - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conversion is
    Port( clk : in std_logic;
         
       --   raw_value : in std_logic_vector(3 downto 0);
       row: in std_logic_vector(3 downto 0);
       col : out std_logic_vector(3 downto 0);
          value_ascii1 : out std_logic_vector(7 downto 0);
        value_ascii2 : out std_logic_vector(7 downto 0);
      value_ascii3 : out std_logic_vector(7 downto 0);
        value_ascii4 : out std_logic_vector(7 downto 0));
         -- op1_ascii   : out std_logic_vector(15 downto 0);
        --  operation_ascii : out std_logic_vector(15 downto 0);
         -- op2_ascii : out std_logic_vector(15 downto 0));
end conversion;

architecture behavioral of conversion is

    component Decoder is
      PORT(
        clk : in std_logic;
        row : in std_logic_vector(3 downto 0);
        col : out std_logic_vector(3 downto 0);
       press :out std_logic;
        DecodeOut : out std_logic_vector(3 downto 0));
    end component;


    signal value1, value2, value3, value4, value : std_logic_vector (3 downto 0);
    
    
    
  --  signal row,col : std_logic_vector( 3 downto 0); 
    
    type ascii_array is array (0 to 15) of std_logic_vector(7 downto 0); -- Mod array for ASCII codes
    signal count: integer := 0;
   signal valueTemp2 : integer;
   -- signal operation_ascii_temp : std_logic_vector(15 downto 0);
    constant ascii_table : ascii_array := ("00110000", "00110001", "00110010", "00110011", "00110100", "00110101", "00110110", "00110111", "00111000", "00111001","01000001","01000010","01000011", "01000100","01000101","01000110"); -- Mod array for ASCII codes
      
begin

  process(clk) begin 
  
  end process;
        --   valueTemp2 <= to_integer(unsigned(raw_value));
        process(clk) begin   
           -- value_ascii(15 downto 8) <=  std_logic_vector(ascii_table((valueTemp2 mod 100) / 10)); -- generate tens digit
       --    if( press ='1') then 
        --  if(count =0) then --and press = '1') then 
            value_ascii1(7 downto 0) <=  std_logic_vector(ascii_table(to_integer(unsigned(value1)))); -- count <= count + 1; 
        --  elsif (count =1 ) then -- and press = '1') then -
           value_ascii2(7 downto 0) <=  std_logic_vector(ascii_table(to_integer(unsigned(value2))));  -- count <= count + 1; 
         -- elsif (count =2 ) then --and press = '1') then 
      value_ascii3(7 downto 0) <=  std_logic_vector(ascii_table(to_integer(unsigned(value3)))); -- count <= count + 1; 
         -- elsif (count =3 ) then --and press = '1') then 
        value_ascii4(7 downto 0) <=  std_logic_vector(ascii_table(to_integer(unsigned(value4))));
         ---  end if;-- generate ones digit
        --   end if;
--            value_ascii(15 downto 8) <=  std_logic_vector(ascii_table(valueTemp2)); -- generate ones digit 
--            value_ascii(23 downto 16) <=  std_logic_vector(ascii_table(valueTemp2)); -- generate ones digit 
--            value_ascii(31 downto 24) <=  std_logic_vector(ascii_table(valueTemp2)); -- generate ones digit            

        --end if;
       
    end process;
 
   key1 : Decoder port map(
                         clk =>  clk,
                         row => row,
                         col => col,
                         DecodeOut => value);   
    
  
--    key2 : Decoder port map(
--                         clk =>  clk,
--                         row => row,
--                         col => col,
--                         DecodeOut => value2);   
--    key3 : Decoder port map(
--                         clk =>  clk,
--                         row => row,
--                         col => col,
--                         DecodeOut => value3);   
--    key4 : Decoder port map(
--                         clk =>  clk,
--                         row => row,
--                         col => col,
--                         DecodeOut => value4);   
    
    
    
end architecture behavioral;