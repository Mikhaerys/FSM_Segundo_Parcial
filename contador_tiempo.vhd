library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_tiempo is
    Port ( clk, reset, enable : in STD_LOGIC;
            pagos : out integer
            );
end contador_tiempo;

architecture Behavioral of contador_tiempo is
    signal count_reg : integer range 0 to 30;
    signal pagar : integer range 0 to 7;
begin
    process (clk, reset)
    begin
        if reset = '0' then
            count_reg <= 0;
        elsif enable = '0' then
            count_reg <= 0;
            
        elsif rising_edge(clk) then
            if enable = '1' then
                count_reg <= count_reg + 1;
                if count_reg mod 5 = 0 then
                    pagar <= pagar + 1;
                    if count_reg =30 then
                        count_reg<= 0;
                    end if;                        
                end if;
            end if;
        end if;
        pagos <= pagar;
    end process;
end architecture;