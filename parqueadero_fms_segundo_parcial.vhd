library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity parqueadero_fms_segundo_parcial is
    port (
        Contraseña  : in std_logic_vector(3 downto 0);
        reloj 		: in std_logic;
		selector	: in std_logic;
        Front_Sensor, Back_Sensor : in std_logic;
        Led_Verde, Led_Rojo : out std_logic
    ) ;
end parqueadero_fms_segundo_parcial ; 

architecture arch of parqueadero_fms_segundo_parcial is
    
	signal clock: STD_LOGIC;
	signal clock_2: STD_LOGIC;
    signal enable_P0 : std_logic;
    signal enable_P1 : std_logic;
    signal enable_P2 : std_logic;
    signal enable_P3 : std_logic;
    signal enable_P4 : std_logic;
    signal enable_P5 : std_logic;
    signal enable_P6 : std_logic;
    signal enable_P7 : std_logic;
    
    
    component Contador_Tiempo
    Port ( clk, reset, enable, load : in STD_LOGIC;
           count_out_D : out integer;
           count_out_U : out integer;
           pay         : out integer);
    end component;

    component freq_divider
		PORT (  clk : IN STD_LOGIC;
				out1, out2 : BUFFER STD_LOGIC);
	end component;

    component contraseña_parcial
        Port(clock, reset           : in std_logic;
            Contraseña 		        : in std_logic_vector(3 downto 0);
            led_Verde, Led_Rojo	    : out std_logic);
    end component;
     
begin

    Relog_1_segundo: freq_divider port map (clk => reloj, out1 => clock, out2 =>clock_2);


end architecture ;
