library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity contrasena_parcial is
	Port (
        clk        : in std_logic;              			-- Entrada del reloj
        rset       : in std_logic;              			-- Entrada de reinicio
        contrasena : in std_logic_vector(3 downto 0);  	    -- Entrada de la contraseÃ±a
        pulsador   : in std_logic;              			-- Entrada del pulsador
        led_V      : out std_logic;             			-- Salida del LED V (verde)
        led_R      : out std_logic;              			-- Salida del LED R (rojo)
		l_puesto   : out std_logic_vector(4 downto 0); 	    -- Salida posicion contraseÃ±a
		l_verdecorrecto : out std_logic
    );
end contrasena_parcial;

    --                                        Datos de entradas
	-- ====================================================================================================
	
	    --  clk				Entrada del reloj          	Entrada FBGA G21 de 50MHz
        -- 	rset			Entrada de reinicio			Entrada con boton, si se presiona se resetea la maquina deestados y vuelve a estado inicial
        -- 	contrasena		Entrada de la contraseÃ±a	Entrada con Switch, vector de 4 espacios, contraseÃ±a correcta (1001)
        -- 	pulsador		Entrada del pulsador		Entrada con boton, si se presiona verifica la contraseÃ±a y hace pasar al siguiente estado

architecture arch of contrasena_parcial is

    --                                   DeclaraciÃ³n de los estados posibles
	-- ====================================================================================================
    type State_Type is (std_Inicial_c, std_No_entra_1, std_No_entra_2, std_No_entra_3, std_Entra);
    signal current_state, next_state : State_Type;
    signal password_attempts : integer range 0 to 3 := 0; 						-- Contador de intentos de contraseÃ±a

    --                                   Salida para controlar la talanquera
	-- ====================================================================================================
    signal talanquera : std_logic;


    --                                ParÃ¡metros para el divisor de frecuencia
	-- ====================================================================================================
    constant DIVIDER_VALUE : integer := 25000000;  								-- Valor para obtener un parpadeo de 2 veces cada medio segundo
    signal divider_counter : integer range 0 to DIVIDER_VALUE - 1 := 0;
    signal blink_enable : std_logic := '0';

begin

    --                           Proceso para el almacenamiento del estado actual
    -- ====================================================================================================

    STATE_MEMORY: PROCESS (pulsador, rset)
    begin 
        IF (rset = '0') then 
            current_state <= std_Inicial_c;    -- Reiniciar al estado inicial en caso de reinicio
            password_attempts <= 0;            -- Reiniciar el contador de intentos de contraseÃ±a
        ELSIF (falling_edge(pulsador)) then    -- TransiciÃ³n de estado en el flanco de bajada de el pulsador
            current_state <= next_state;       -- Actualizar el estado actual al siguiente estado
        END IF;
    END PROCESS STATE_MEMORY;


    --                           Proceso para la lÃ³gica de transiciÃ³n de estados
    -- ====================================================================================================

    NEXT_STATE_LOGIC: PROCESS (current_state, contrasena, pulsador)
	
    begin
	
        CASE (current_state) is
            
            when std_Inicial_c =>                				-- Estado inicial
				l_puesto <= "10000";										-- Puesto actual de la maquina de estados contraseÃ±a
                    
					if (contrasena = "1001") then     				-- Verificar si la contraseÃ±a es correcta
						next_state <= std_Entra;      				-- Ir al estado de entrada si es correcta
						password_attempts <= 0;        				-- Reiniciar el contador de intentos de contraseÃ±a
					else 
						next_state <= std_No_entra_1; 				-- Volver al primer estado de no entrada si no es correcta
						password_attempts <= 1;        				-- Incrementar el contador de intentos de contraseÃ±a

					end if;
					
					
            when std_No_entra_1 =>                				    -- Primer estado de no entrada
				l_puesto <= "01000";								-- Puesto actual de la maquina de estados contraseÃ±a
				
					if (contrasena = "1001") then     				-- Verificar si la contraseÃ±a es correcta
						next_state <= std_Entra;      				-- Ir al estado de entrada si es correcta
						password_attempts <= 0;        				-- Reiniciar el contador de intentos de contraseÃ±a
                else 
                    next_state <= std_No_entra_2; 				    -- Ir al segundo estado de no entrada si no es correcta
                    password_attempts <= 2;        			    	-- Incrementar el contador de intentos de contraseÃ±a
                end if;

			
            when std_No_entra_2 =>                				    -- Segundo estado de no entrada
				l_puesto <= "00100";								-- Puesto actual de la maquina de estados contraseÃ±a

					if (contrasena = "1001") then     				-- Verificar si la contraseÃ±a es correcta
						next_state <= std_Entra;      				-- Ir al estado de entrada si es correcta
                        password_attempts <= 0;        				-- Reiniciar el contador de intentos de contraseÃ±a
					else 
                        next_state <= std_No_entra_3; 				-- Ir al tercer estado de no entrada si no es correcta
                        password_attempts <= 3;        				-- Incrementar el contador de intentos de contraseÃ±a
					end if;

					
            when std_No_entra_3 =>                				    -- Tercer estado de no entrada
				l_puesto <= "00010";								-- Puesto actual de la maquina de estados contraseÃ±a

					if (contrasena = "1001") then     				-- Verificar si la contraseÃ±a es correcta
						next_state <= std_Entra;      				-- Ir al estado de entrada si es correcta
						password_attempts <= 0;        				-- Reiniciar el contador de intentos de contraseÃ±a
					else 
						next_state <= std_Inicial_c;  				-- Volver al estado inicial si no es correcta
                password_attempts <= 0;        				        -- Reiniciar el contador de intentos de contraseÃ±a


            end if;
					
			when std_Entra =>
                l_puesto <= "00001";
        
            when others =>                        				    -- Otros estados
                next_state <= std_Inicial_c;       			        -- Volver al estado inicial por defecto
        end case;
    end process NEXT_STATE_LOGIC;

	
	
	
    --                           Proceso para el control del parpadeo de los LEDs
	-- ====================================================================================================
	
    LED_BLINK: PROCESS (clk)
    begin
	
        if (clk = '1' and clk'event) then
            if (divider_counter = DIVIDER_VALUE - 1) then
                -- Cambiar el estado de habilitaciÃ³n del parpadeo cada medio segundo
                blink_enable <= not blink_enable;
                divider_counter <= 0;
            else
                divider_counter <= divider_counter + 1;
            end if;
        end if;
    end process LED_BLINK;

	
	
	
    --                            Proceso para el control de las salidas de los LEDs
	-- ====================================================================================================
	
    LED_OUTPUTS: PROCESS (current_state, blink_enable, password_attempts)
    begin
        case current_state is
		
            when std_Entra =>
                led_V <= blink_enable;  -- LED verde parpadea en el estado inicial y de entrada
					 l_verdecorrecto <='1';
                led_R <= '0';           -- LED rojo apagado en el estado inicial y de entrada
					
            when std_No_entra_1 | std_No_entra_2 | std_No_entra_3 =>
                led_V <= '0';           -- LED verde apagado en los estados de no entrada
					 l_verdecorrecto <='0';
                led_R <= blink_enable;  -- LED rojo parpadea en los estados de no entrada
					
            when others =>
                led_V <= '0';           -- LED verde apagado por defecto en otros estados
					 l_verdecorrecto <='0';
                led_R <= '0';           -- LED rojo apagado por defecto en otros estados
        end case;
    end process LED_OUTPUTS;

end arch;