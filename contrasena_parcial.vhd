library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity contrasena_parcial is
	Port(clk, rset           : in std_logic;
		contrasena 		     : in std_logic_vector(3 downto 0);
		led_V, led_R	    : out std_logic);

end contrasena_parcial ; 

architecture arch of contrasena_parcial is



type State_Type is (std_Inicial_c, std_No_entra_1, std_No_entra_2, std_Entra);
signal current_state, next_state : State_Type;

begin
    STATE_MEMORY: PROCESS (clk, rset)

    begin 
	IF (rset ='1') then 
		    current_state <= std_Inicial_c;
	ELSIF (clk'event and clk='1') then 
		    current_state <= next_state;
	END IF;
    END PROCESS;


NEXT_STATE_LOGIC: PROCESS (current_state, contrasena)
begin 	
	CASE (current_state) is 
		when std_Inicial_c =>  if (contrasena="1001") then
							next_state<=std_Entra;
							else 
							next_state<=std_No_entra_1;
							end if;
							
		when std_No_entra_1  =>  if (contrasena="1001") then
							next_state<=std_Entra;
							else 
							next_state<=std_No_entra_2;
							end if;
							
		when std_No_entra_2 =>  if (contrasena="1001") then
							next_state<=std_Entra;
							else 
							next_state<=std_Inicial_c;
							end if;
		
							
		when others => next_state<=std_Inicial_c;
    
end case;
END PROCESS;

OUTPUT_LOGIC : process (current_state, contrasena)
	begin
			case (current_state) is
				when std_Inicial_c =>
					if (contrasena="1001") then
						led_V <= '1'; led_R <= '0';
					else
						led_V <= '0'; led_R <= '1';
					end if;
				when std_No_entra_1 => 	
					if (contrasena="1001") then
						led_V <= '1'; led_R <= '0';
					else
						led_V <= '0'; led_R <= '1';
					end if;
				when std_No_entra_2 => 	
					if (contrasena="1001") then
						led_V <= '1'; led_R <= '0';
					else
						led_V <= '0'; led_R <= '1';
					end if;
				when others => led_V <= '0'; led_R <= '0';
			end case;
		end process;



end arch ;