--
-- Written by Ryan Kim, Digilent Inc.
-- Modified by Michael Mattioli
--
-- Description: Top level controller that controls the OLED display.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity oled_ctrl is
    port (  clk         : in std_logic;
            rst         : in std_logic;
        --    btn         : in  std_logic_vector(1 downto 0);
            col         : out std_logic_vector(3 downto 0);
            row         : in std_logic_vector(3 downto 0);
            oled_cs     : out std_logic;
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic);
end oled_ctrl;

architecture behavioral of oled_ctrl is
   
    component Decoder is
      PORT(
        clk : in std_logic;
        row : in std_logic_vector(3 downto 0);
        col : out std_logic_vector(3 downto 0);
        press :out std_logic;
        DecodeOut : out std_logic_vector(3 downto 0));
    end component;
   
    component oled_init is
        port (  clk         : in std_logic;
                rst         : in std_logic;
                en          : in std_logic;
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                oled_dc     : out std_logic;
                oled_res    : out std_logic;
                oled_vbat   : out std_logic;
                oled_vdd    : out std_logic;
                fin         : out std_logic);
    end component;

    component oled_ex is
        port (  clk         : in std_logic;
                rst         : in std_logic;
                en          : in std_logic;
               count_out   :  in std_logic_vector(1 downto 0);
               state_num :     in  std_logic_vector(2 downto 0);
                sdout       : out std_logic;
                oled_sclk   : out std_logic;
                oled_dc     : out std_logic;
                fin         : out std_logic);
    end component;
    
    component lock is 
        port ( val_in : in std_logic_vector (3 downto 0);
        clk, press : in std_logic;
        count_out : out std_logic_vector(1 downto 0);
        state_num : out std_logic_vector (2 downto 0));
    end component;
    
    
--    component conversion  is  
--        port( clk : in std_logic;
--              row: in std_logic_vector(3 downto 0);
--       col : out std_logic_vector(3 downto 0);
--           --raw_value : in std_logic_vector(3 downto 0);
--              --press :in std_logic;
--              value_ascii1 : out std_logic_vector(7 downto 0);
--              value_ascii2 : out std_logic_vector(7 downto 0);
--              value_ascii3 : out std_logic_vector(7 downto 0);
--              value_ascii4 : out std_logic_vector(7 downto 0));
             
--    end component;

    type states is (Idle, OledInitialize, OledExample, Done);

    signal current_state : states := Idle;

    signal init_en          : std_logic := '0';
    signal init_done        : std_logic;
    signal init_sdata       : std_logic;
    signal init_spi_clk     : std_logic;
    signal init_dc          : std_logic;

    signal example_en       : std_logic := '1';
    signal example_sdata    : std_logic;
    signal example_spi_clk  : std_logic;
    signal example_dc       : std_logic;
    signal example_done     : std_logic;

   signal count_temp : std_logic_vector(1 downto 0);
   signal state_num_temp :std_logic_vector(2 downto 0);
   signal press_temp : std_logic;
   --signal value1, value2, value3 , value4 :std_logic_vector(7 downto 0);
   -- signal val_converted : std_logic_vector(31 downto 0) := "00110000001100010011001000110011";
  
    signal keypad_out : std_logic_vector(3 downto 0);
    
    
    
begin

    oled_cs <= '0';

   
    Initialize: oled_init port map (clk,
                                    rst,
                                    init_en,
                                    init_sdata,
                                    init_spi_clk,
                                    init_dc,
                                    oled_res,
                                    oled_vbat,
                                    oled_vdd,
                                    init_done);

    display : oled_ex port map ( clk,
                                rst,
                                example_en,
                                count_temp,
                                state_num_temp,
                                example_sdata,
                                example_spi_clk,
                                example_dc,
                                example_done);
                                
                           
    
   
          decode : Decoder port map(
                         clk =>  clk,
                         row => row,
                         col => col,
                         press => press_temp,
                         DecodeOut => keypad_out);
                         
                         
            
         key_lock: lock port map( val_in => keypad_out,
                                   clk => clk,
                                   press => press_temp,
                                   count_out =>count_temp,
                                   state_num => state_num_temp);
                                   
                         
  

     
                                 
    -- MUXes to indicate which outputs are routed out depending on which block is enabled
    oled_sdin <= init_sdata when current_state = OledInitialize else example_sdata;
    oled_sclk <= init_spi_clk when current_state = OledInitialize else example_spi_clk;
    oled_dc <= init_dc when current_state = OledInitialize else example_dc;
    -- End output MUXes

    -- MUXes that enable blocks when in the proper states
    init_en <= '1' when current_state = OledInitialize else '0';
    example_en <= '1' when current_state = OledExample else '0';
    -- End enable MUXes
   
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= Idle;
            else
                case current_state is
                    when Idle =>
                        current_state <= OledInitialize;
                    -- Go through the initialization sequence
                    when OledInitialize =>
                        if init_done = '1' then
                            current_state <= OledExample;
                        end if;
                    -- Do example and do nothing when finished
                    when OledExample =>
                        if example_done = '1' then
                            current_state <= Done;
                        end if;
                    -- Do nthing
                    when Done =>
                        current_state <= Done;
                    when others =>
                        current_state <= Idle;
                end case;
            end if;
        end if;
    end process;
end behavioral;