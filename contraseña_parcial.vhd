library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity contraseña_parcial is
	Port(clock, reset           : in std_logic;
		Contraseña 		        : in std_logic_vector(3 downto 0);
		led_Verde, Led_Rojo	    : out std_logic);

end contraseña_parcial ; 

architecture arch of contraseña_parcial is



type State_Type is (std_Inicial_c, std_No_entra_1, std_No_entra_2, std_Entra);
signal current_state, next_state : State_Type;

begin
    STATE_MEMORY: PROCESS (clock, reset)

    begin 
	IF (reset ='1') then 
		    current_state <= std_Inicial_c;
	ELSIF (clock'event and clock='1') then 
		    current_state <= next_state;
	END IF;
    END PROCESS;


NEXT_STATE_LOGIC: PROCESS (current_state, Contraseña)
begin 
	CASE (current_state) is 
		when std_Inicial_c =>  if (Contraseña="1001") then
							next_state<=std_Entra;
							else 
							next_state<=std_No_entra_1;
							end if;
							
		when std_No_entra_1, =>  if (Contraseña="1001") then
							next_state<=std_Entra;
							else 
							next_state<=std_D;
							end if;
							
		when std_No_entra_2 =>  if (Contraseña="1001") then
							next_state<=std_Entra;
							else 
							next_state<=std_D;
							end if;
		
							
		when others => next_state<=current_state;
end case;
END PROCESS;




end architecture ;