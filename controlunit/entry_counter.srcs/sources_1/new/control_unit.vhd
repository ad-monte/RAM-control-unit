----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/24/2025 04:15:46 PM
-- Design Name: 
-- Module Name: control_unit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;



entity control_unit is
Port ( clk, rst, start: in std_logic;
       RAMDout: in std_logic_vector (7 downto 0);
       add, data_out: out std_logic_vector (4 downto 0);
       en, we: out std_logic;
       RAMDin : out std_logic_vector (7 downto 0));
end control_unit;

architecture Behavioral of control_unit is

type state is (idle,first_read,reading);
signal currentstate, newstate: state;
signal count, newcount: unsigned (4 downto 0);
signal curraddress, newaddress: unsigned (4 downto 0);
signal firstentry: std_logic_vector (7 downto 0);

begin


controlreg: process (clk)
begin
if rising_edge (clk) then
if rst = '1' then 
currentstate<= idle;
curraddress <= (others =>'0');
count <=(others =>'0');
else 
currentstate<=newstate;
count <= newcount;
curraddress <= newaddress;
end if;
end if;
end process controlreg;

logicproc: process (currentstate, RAMDout, start, curraddress, count)
begin 
case currentstate is 
                    when idle=>                            
                            RAMDin <= (others =>'0');
                            en <= '0';
                            we <= '0';  
                            
                            if start='1' then
                            newcount <= (others =>'0');
                            newaddress <=(others =>'0');
                            newstate <= first_read;
                            else                                                       
                            newstate <= idle;                            
                            end if;                    
                    
                    when first_read=>
                            
                            
                            en<='1';
                            we<='0';
                            RAMDin <= (others =>'0');
                            add <= std_logic_vector(curraddress);
                            newstate <= reading;
                            newaddress <= curraddress + 1;
                            
                            
                    when reading=>
                            
                            en<='1';
                            we<='0';
                            RAMDin <= (others =>'0');
                            add <= std_logic_vector(curraddress);
                            newaddress <= curraddress + 1;
                            data_out<= std_logic_vector(count);
                            
                            if curraddress = 1 then
                            firstentry<=RAMDout;
                            newcount <= count+1;
                            elsif RAMDout = firstentry and curraddress /= 1 then
                            newcount <= count+1;
                            else 
                            newcount <= count;
                            end if;                      
                                                        
                            if curraddress = "11111" then 
                            newstate <= idle;
                            end if;
                            
end case;
end process logicproc;
end Behavioral;
