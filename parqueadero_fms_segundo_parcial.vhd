library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity parqueadero_fms_segundo_parcial is
    port (
        password    : in std_logic_vector(3 downto 0);
        parqueadero : in std_logic_vector(7 downto 0);
        reloj 		: in std_logic;
		pulsador   : in std_logic;
		selector	: in std_logic;
        Front_Sensor, Back_Sensor : in std_logic;
		Numero		: out std_logic_vector(6 downto 0);
		Display_Pago: out std_logic_vector(6 downto 0);
        Led_Verde, Led_Rojo : out std_logic;
		rst 		: in STD_LOGIC;
        libres      : out std_logic_vector(6 downto 0);
		puestos_con	: out std_logic_vector(4 downto 0)
    ) ;
end parqueadero_fms_segundo_parcial ; 

architecture arch of parqueadero_fms_segundo_parcial is
    
    type State_Type is (std_Inicial, std_contrasena_parcial, Std_Espera,std_estacionar);
    signal current_state, next_state : State_Type;
	signal rst_contrasena : STD_LOGIC;
    signal bandera_ledverde : STD_LOGIC;
	signal ld	: STD_LOGIC := '1';
	signal clock: STD_LOGIC;
	signal contador_int : integer range 1 to 9 := 1;
	signal opcion : integer range 1 to 8;
    signal count : integer := 0;

    signal pay_1 : integer;
	signal pay_2 : integer;
	signal pay_3 : integer;
	signal pay_4 : integer;
	signal pay_5 : integer;
	signal pay_6 : integer;
	signal pay_7 : integer;
	signal pay_8 : integer;

    signal Pago : integer range 0 to 9;
    signal enable_P : std_logic_vector(7 downto 0) := "00000000";
    signal l_verde : std_logic;
    signal l_rojo  : std_logic;

	signal otro_led : std_logic;

    
-------------------------------------------------------------------------------------------------   
    component Contador_Tiempo
    Port ( clk, reset, enable : in STD_LOGIC;
            pagos	          : out integer);
    end component;

    component freq_divider
	Port (clk : in STD_LOGIC;     -- Señal de reloj de entrada
		out_clk : out STD_LOGIC -- Señal de reloj de salida
	);
	end component;

    component contrasena_parcial
		PORT (
        clk        : in std_logic;              			-- Entrada del reloj
        rset       : in std_logic;              			-- Entrada de reinicio
        contrasena : in std_logic_vector(3 downto 0);  	    -- Entrada de la contraseÃƒÆ’Ã‚Â±a
        pulsador   : in std_logic;              			-- Entrada del pulsador
        led_V      : out std_logic;             			-- Salida del LED V (verde)
        led_R      : out std_logic;              			-- Salida del LED R (rojo)
		  l_puesto   : out std_logic_vector(4 downto 0); 	    -- Salida posicion contraseÃƒÆ’Ã‚Â±a
		  l_verdecorrecto : out std_logic);
	 end component;
    
begin
    
    Reloj_1_segundo: freq_divider port map (clk => reloj, out_clk => clock);

    STATE_MEMORY: PROCESS (clock, rst)


    begin 
		IF (rst ='1') then 
			current_state <= std_Inicial;
		ELSIF (clock'event and clock='1') then 
			current_state <= next_state;
		END IF;
    END PROCESS;
    

    NEXT_STATE_LOGIC: PROCESS (current_state, Front_Sensor, Back_Sensor)

    begin 
		CASE (current_state) is 
			when std_Inicial =>  if (Front_Sensor ='1' and Back_Sensor ='0') then
								next_state<=std_contrasena_parcial;
				    			else 
					    		next_state<=std_Inicial;
						    	end if;
    
	    	when std_contrasena_parcial =>  if ( Back_Sensor ='1' and l_verde = '1'  ) then
		    					next_state<=std_estacionar;
			    				else 
				    			next_state<= Std_Espera;
					    		end if;
			when Std_Espera =>  if (Back_Sensor ='1' and l_verde = '1' ) then
								next_state<=std_estacionar;
								else 
								next_state<=Std_Espera;
								end if;	
									
            
            when std_estacionar =>  if (Front_Sensor ='0' and Back_Sensor ='0' ) then
		    					next_state<=std_Inicial;
			    				else 
				    			next_state<=std_estacionar;
					    		end if;	
    
    
	    	when others => next_state<=std_Inicial;
    
        end case;
    END PROCESS;

    OUTPUT_LOGIC : process (current_state, Front_Sensor, Back_Sensor)
	begin
		case (current_state) is
			when std_Inicial => 
				if (Front_Sensor = '0' and Back_Sensor = '0') then
					Led_Verde <= '0';
					Led_Rojo <= '0';
				end if;
			when std_contrasena_parcial =>  
				if (Front_Sensor = '1' and Back_Sensor = '0') then
					Led_Verde <= l_verde;
					Led_Rojo <= l_rojo;
				end if;
			when Std_Espera =>  
				if (Back_Sensor ='1' and otro_led = '1' ) then
					Led_Verde <= l_verde;
					Led_Rojo <= l_rojo;
				end if;
			when std_estacionar =>  
				if (Back_Sensor = '1' and otro_led = '1') then
					enable_P <= parqueadero;
				end if;
			when others => 
				led_Verde <= '0';
				led_Rojo <= '0';
		end case;
	end process;

    Contrasena: contrasena_parcial port map (clk =>reloj, rset => rst, contrasena => password, pulsador =>pulsador, Led_V => l_verde, Led_R => l_rojo, l_puesto => puestos_con, l_verdecorrecto => otro_led);

--------------------------------------------------------------------------------------------------
    --Vehiculo 1
	
	P1 : Contador_Tiempo port map (clk => clock, reset => rst, enable => enable_P(0), pagos => pay_1);
	
	--Vehiculo 2
	
	P2 : Contador_Tiempo port map (clk => clock, reset => rst, enable => enable_P(1), pagos => pay_2);
	
	--Vehiculo 3
	
	P3 : Contador_Tiempo port map (clk => clock, reset => rst, enable => enable_P(2), pagos => pay_3);
	
	--Vehiculo 4
	
	P4 : Contador_Tiempo port map (clk => clock, reset => rst, enable => enable_P(3), pagos => pay_4);
	
	--Vehiculo 5
	
	P5 : Contador_Tiempo port map (clk => clock, reset => rst, enable => enable_P(4), pagos => pay_5);
	
	--Vehiculo 6
	
	P6 : Contador_Tiempo port map (clk => clock, reset => rst, enable => enable_P(5), pagos => pay_6);
	
	--Vehiculo 7
	
	P7 : Contador_Tiempo port map (clk => clock, reset => rst, enable => enable_P(6), pagos => pay_7);
	
	--Vehiculo 8
	
	P8 : Contador_Tiempo port map (clk => clock, reset => rst, enable => enable_P(7), pagos => pay_8);

--------------------------------------------------------------------------------------------------
    COUNT_ZEROS: process (parqueadero)
    begin

		count <= 0;

        for i in parqueadero'range loop
            if parqueadero(i) = '0' then
                count <= count + 1;
            end if;
        end loop;

    end process;
--------------------------------------------------------------------------------------------------
    --Contador del selector

    process(selector)
    begin
        if rising_edge(selector) then
            if contador_int > 8 then
                contador_int <= 1;
            else
                contador_int <= contador_int + 1;
            end if;
        end if;
        opcion <= contador_int;
    end process;

    with opcion select
    Pago <= pay_1 when 1,
            pay_2 when 2,
            pay_3 when 3,
            pay_4 when 4,
            pay_5 when 5,		
            pay_6 when 6,
            pay_7 when 7,
            pay_8 when 8;
            
----------------------------------------------------------------------------------------------
    --Decodificador

	process (Pago) begin
		case Pago is 
			when 0 =>Display_Pago<= "0000001";
			when 1 =>Display_Pago<= "1001111";
			when 2 =>Display_Pago<= "0010010";
			when 3 =>Display_Pago<= "0000110";
			when 4 =>Display_Pago<= "1001100";
			when 5 =>Display_Pago<= "0100100";
			when 6 =>Display_Pago<= "0100000";
			when 7 =>Display_Pago<= "0001111";
			when 8 =>Display_Pago<= "0000000";
			when 9 =>Display_Pago<= "0000100";
			when others  =>Display_Pago<= "1111111";
		end case;
	end process;

    process (opcion) begin
		case opcion is 
			when 1 =>Numero<= "1001111";
			when 2 =>Numero<= "0010010";
			when 3 =>Numero<= "0000110";
			when 4 =>Numero<= "1001100";
			when 5 =>Numero<= "0100100";
			when 6 =>Numero<= "0100000";
			when 7 =>Numero<= "0001111";
			when 8 =>Numero<= "0000000";
			when others  =>Numero<= "1111111";
		end case;
	end process;

    process (count) begin	
		case count is 
			when 0 =>libres<= "0000001";
			when 1 =>libres<= "1001111";
			when 2 =>libres<= "0010010";
			when 3 =>libres<= "0000110";
			when 4 =>libres<= "1001100";
			when 5 =>libres<= "0100100";
			when 6 =>libres<= "0100000";
			when 7 =>libres<= "0001111";
			when 8 =>libres<= "0000000";
			when 9 =>libres<= "0000100";
			when others  =>libres<= "1111111";
		end case;
	end process;
    

end architecture ;
