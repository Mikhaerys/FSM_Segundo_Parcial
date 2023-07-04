library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

   --                                        Entradas y salidas
	-- ====================================================================================================
	
entity freq_divider is

    Port ( clk : in STD_LOGIC;     -- Señal de reloj de entrada
           out_clk : out STD_LOGIC -- Señal de reloj de salida
           );
		
end freq_divider;

    --                                    Datos de entradas y salidas
	-- ====================================================================================================

    -- clk      Una señal de entrada de 50MHz incluida dentro de FPGA
    -- out_clk  Una señal de salida de 1Hz o 1 segundo

    --                                Declaracion de señales y cosntantes
	-- ====================================================================================================
	
architecture Behavioral of freq_divider is
    constant CLK_FREQUENCY : integer := 49999999;  -- Frecuencia de reloj de entrada
    constant COUNT_MAX : integer := CLK_FREQUENCY * 1;  -- Valor máximo del contador
    signal count : integer range 0 to COUNT_MAX-1;  -- Contador
    signal out_internal : std_logic;  -- Señal de reloj interna
	 
	 
   --                                      Divisor de frecuencia
	-- ====================================================================================================
	
begin

    process (clk)
    begin
        if rising_edge(clk) then  -- Detectar flanco de subida en la señal de reloj de entrada
            count <= count + 1;  -- Incrementar el contador
            
            if count = COUNT_MAX-1 then  -- Verificar si se ha alcanzado el valor máximo del contador
                count <= 0;  -- Reiniciar el contador
                out_internal <= NOT out_internal;  -- Invertir la señal de reloj interna
            end if;
        end if;
    end process;

    out_clk <= out_internal;  -- Asignar la señal de reloj interna a la señal de reloj de salida
	 
	 
end Behavioral;
