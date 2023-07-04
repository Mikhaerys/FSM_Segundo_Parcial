LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY Contador IS
    PORT (clk : IN std_logic;
        reset : IN std_logic;
        enable: IN std_logic;
        count : OUT std_logic_vector(4 DOWNTO 0);
        d     : out std_logic_vector(6 downto 0);
        e     : out std_logic_vector(6 downto 0)
        );
END Contador;

ARCHITECTURE arch1 OF Contador IS

    SIGNAL cnt : UNSIGNED(4 DOWNTO 0);
    signal decenas   : UNSIGNED(4 downto 0);
    signal unidades   : UNSIGNED(4 downto 0);

begin

        pSeq : PROCESS (clk, reset) IS
            begin
            if reset = '1' THEN
                cnt <= (others => '0');
            elsif clk'event AND clk='1' THEN
                if enable='1' THEN
                    cnt <= cnt + 1;
                END if;
            END if;
        END PROCESS;
    
        count <= std_logic_vector(cnt);

        process(cnt) begin
            decenas <= cnt / 10;
            unidades <= cnt mod 10;
        end process;

        process (decenas) begin
            case decenas is   
                when "00000" =>d<= "0000001";
                when "00001" =>d<= "1001111";
                when "00010" =>d<= "0010010";
                when "00011" =>d<= "0000110";
                when "00100" =>d<= "1001100";
                when "00101" =>d<= "0100100";
                when "00110" =>d<= "0100000";
                when "00111" =>d<= "0001111";
                when "01000" =>d<= "0000000";
                when "01001" =>d<= "0000100";
                when others =>d<= "1111111";
            end case;   
        end process;

        process (unidades) begin
            case unidades is   
                when "00000" =>e<= "0000001";
                when "00001" =>e<= "1001111";
                when "00010" =>e<= "0010010";
                when "00011" =>e<= "0000110";
                when "00100" =>e<= "1001100";
                when "00101" =>e<= "0100100";
                when "00110" =>e<= "0100000";
                when "00111" =>e<= "0001111";
                when "01000" =>e<= "0000000";
                when "01001" =>e<= "0000100";
                when others =>e<= "1111111";
            end case;   
        end process;

END arch1;


