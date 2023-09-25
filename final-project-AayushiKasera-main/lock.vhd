----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/04/2023 02:35:40 PM
-- Design Name: 
-- Module Name: lock - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lock is
 Port ( val_in : in std_logic_vector (3 downto 0);
        clk, press : in std_logic;
        count_out : out std_logic_vector(1 downto 0);
        state_num : out std_logic_vector (2 downto 0));
end lock;

architecture Behavioral of lock is


 -- States for state machine
    type states is (Locked,
                    keys,
                    Unlocked,
                    check,
                    Idle
--                    Option,
--                    buff1,
--                    buff2,
--                    Reset
                    );
--     type key_array is array (0 to 3) of std_logic_vector(3 downto 0);
        signal count : std_logic_vector (1 downto 0);
--     signal passcode : key_array := ( "0000", "0000", "0000", "0000");
--     constant right_passcode : key_array := ("0001", "0010", "0011", "0100");
       signal passcode : std_logic_vector(0 to 15) := "0000000000000000";
       signal right_passcode : std_logic_vector(0 to 15) :=  "0001001000110100"; --1234
       signal reset_passcode : std_logic_vector(0 to 15) := "0000000000000000";
       signal current_state : states := Locked;
       --signal reset : std_logic_vector (1 downto 0);
       -- signal 
     
begin

 process(clk) begin 
    
     if rising_edge(clk) then
            case current_state is
                
               
                when Locked => 
                 state_num <= "000";
                 if (press ='1') then
                  current_state <= keys;
                  count <= "00";
                 end if;
                 
                 when keys => 
                 state_num <= "001";
                  if (press ='0') then 
                   current_state <= Idle;
                  else
                    passcode(to_integer(unsigned(count))*4  to  to_integer(unsigned(count))*4 + 3) <= val_in;
                  end if;
                  
                 when Idle => 
                   state_num <= "001";
                   if (press = '1') then 
                        if (count /= "10") then
                            count <= std_logic_vector(unsigned(count) + 1);
                            current_state <= keys;
                        else 
                            current_state <= check;
                            passcode(to_integer(unsigned(count))*4+4  to  to_integer(unsigned(count))*4 + 7) <= val_in;
                        end if;
                    end if;
                      
                  when check  => 
                  if(press ='0') then 
                   if ( passcode = right_passcode ) then
                            current_state <= Unlocked;
                            count <= "00";
                        else 
                            current_state <= Locked;
                            count <= "00";
                        end if;
                   end if;
                   
                   
                 when Unlocked => 
                  state_num <= "010";
--                  current_state <= Option;
--                  count <= "00";
                  
--                  when Option =>
--                    state_num <= "011";
--                   if( press ='1') then
--                     if( val_in = "0001") then --if 1
--                        current_state <= locked;
--                     elsif( val_in = "0010") then --if 2
--                        current_state <= Reset;
--                     end if;
--                   end if;
                    
--                   when buff1 =>
--                   if(press ='1') then
                    
--                     if (press = '0') then 
--                        if (count /= "10") then
--                            count <= std_logic_vector(unsigned(count) + 1);
--                            --current_state <= Reset;
--                        else 
--                             right_passcode <= reset_passcode;
--                            current_state <= locked;
                           
--                        end if;
--                    end if;
                    
--                   when buff2 => 
                    
--                   when Reset =>
--                      reset_passcode(to_integer(unsigned(count))*4+4  to  to_integer(unsigned(count))*4 + 7) <= val_in; 
--                      current_state <= buff1;
--                     --end if;
                   
                  
                  
           end case;
        
        end if;
                 
 
 end process;

  count_out  <= count;
 
 end Behavioral;
