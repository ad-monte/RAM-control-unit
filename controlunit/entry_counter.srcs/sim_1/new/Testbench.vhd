----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/24/2025 05:44:19 PM
-- Design Name: 
-- Module Name: Testbench - Behavioral
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


entity Testbench is
end Testbench;

architecture Behavioral of Testbench is

component RAM is
    generic(
        RAM_WIDTH : integer := 8;
        RAM_DEPTH : integer := 32;
        RAM_ADD   : integer := 5;
        INIT_FILE : string := "memory.mem"
    );
    port(
        ADDR : in std_logic_vector(RAM_ADD-1 downto 0);                          -- Address bus, width determined from RAM_DEPTH
        DIN  : in std_logic_vector(RAM_WIDTH-1 downto 0);                                  -- RAM input data
        CLK  : in std_logic;                                                                 -- Clock
        WE   : in std_logic;                                                                 -- Write enable
        EN   : in std_logic;                                                                 -- RAM Enable, for additional power savings, disable port when not in use
        DOUT : out std_logic_vector(RAM_WIDTH-1 downto 0)                                  -- RAM output data
    );
end component;

component control_unit is
Port ( clk, rst, start: in std_logic;
       RAMDout: in std_logic_vector (7 downto 0);
        add, data_out: out std_logic_vector (4 downto 0);
       en, we: out std_logic;
       RAMDin : out std_logic_vector (7 downto 0));
end component;

signal en_s, we_s, clk_s, rst_s, start: std_logic;
signal add_s, output: std_logic_vector (4 downto 0);
signal RAMDout_s, RAMDin_s: std_logic_vector (7 downto 0);
CONSTANT ClockPeriod : TIME := 6 ns;


begin
memory: RAM generic map( RAM_WIDTH => 8, 
                         RAM_DEPTH => 32, 
                         RAM_ADD => 5, 
                         INIT_FILE => "memory.mem") 
             port map(ADDR=>add_s,
                      DIN=>RAMDin_s,   
                      CLK=>clk_s,
                      WE=>we_s,
                      EN => en_s,
                      DOUT=>RAMDout_s);
                      
ctrlunit: control_unit port map (start=> start,
                                 rst=> rst_s,
                                 clk=> clk_s,
                                 RAMDout=>RAMDout_s,
                                 add=>add_s,
                                 WE=>we_s,
                                 EN => en_s,
                                 RAMDin=>RAMDin_s, 
                                 data_out => output);



ClkProcess: PROCESS
   BEGIN
      Clk_s <= '0';
      WAIT FOR (ClockPeriod/2);
      Clk_s <= '1'; 
      WAIT FOR (ClockPeriod/2);
   END PROCESS ClkProcess;
   
test: process
    begin
    rst_s <= '1';start<='0'; wait for 12 ns;
    rst_s <= '0'; wait for 2 ns;
    
    
    start<='1'; wait for 30 ns;
    start<='0'; wait for 220 ns;
    
           
    start<='1'; wait for 30 ns;
    start<='0'; wait for 50 ns;
    
    rst_s <= '1';start<='0'; wait for 15 ns;
    rst_s <= '0'; wait for 2 ns;
    
    start<='1'; wait for 30 ns;
    start<='0'; wait for 50 ns;   
    wait;
    end process test;
   
   
end Behavioral;














