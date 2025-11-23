library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity elevador is
    port (
        CLOCK     : in  std_logic;	-- clock do sistema
        RESET     : in  std_logic;  -- ,aster reset
        andar_req : in  std_logic_vector(3 downto 0);  -- o andar desejado
		  BTN_CLOCK : in  std_logic;	-- o botão do clock
        LEDR      : out std_logic_vector(2 downto 0);	-- os leds
        HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(6 downto 0);	-- os displays de 7 segmentos, um pra dezena e outro pra unidade, pro andar que queremos e pro que estamos
		  and_atual : out std_logic_vector(3 downto 0)
	 );
end entity;

-- comportamento do elevador
architecture Behavioral of elevador is
    -- uso do debouncer
	 -- usado pra eliminar o ruído do clock
--    component debounce is
--        port (
--            clk    : in  std_logic;    -- clock de 50MHZ do sistema
--            btn_in : in  std_logic;    -- sinal do clock em um botão
--            pulse  : out std_logic     -- pulso limpo (1 ciclo)
--        );
--    end component;


    -- função de conversão para 7 segmentos
	 -- eu acho que é mais fácil fazer isso pros 9 primeiros segmentos
	 -- daí pros segmentos 10 em diante a gente vai pro segundo caso, lá em baixo
	 -- vamos usar ela pros displays depois
    function to_7seg(b : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        case b is
            when "0000" => seg := "1000000"; -- 0
            when "0001" => seg := "1111001"; -- 1
            when "0010" => seg := "0100100"; -- 2
            when "0011" => seg := "0110000"; -- 3
            when "0100" => seg := "0011001"; -- 4
            when "0101" => seg := "0010010"; -- 5
            when "0110" => seg := "0000010"; -- 6
            when "0111" => seg := "1111000"; -- 7
            when "1000" => seg := "0000000"; -- 8
            when "1001" => seg := "0010000"; -- 9
            when others => seg := "1111111"; -- segundo caso
        end case;
        return seg;
    end function;

    -- estados: parado, subindo (1 andar por vez), descendo (1 andar por vez)
    type estado_type is (PARADO, SUBINDO, DESCENDO);
    signal estado : estado_type := PARADO;

    signal andar_atual     : unsigned(3 downto 0) := (others => '0');
    signal andar_desejado  : unsigned(3 downto 0);
    signal clock_pulse     : std_logic := '0';	-- pulso do debounce

	 -- sinais auxiliares pro display, que vai separar dezenas e unidades
    signal dez_atual, uni_atual : std_logic_vector(3 downto 0);
    signal dez_req, uni_req     : std_logic_vector(3 downto 0);

begin

    andar_desejado <= unsigned(andar_req);

	 -- usando, de facto, o debounce
	 -- conectamos o BTN_CLOCK pro SW[17]
	 -- e geramos o sinal limpo (clock_pulse)
--    u1: debounce
--        port map (
--            clk    => CLOCK,
--            btn_in => BTN_CLOCK,  -- botão físico ou switch
--            pulse  => clock_pulse
--        );
	 
    process (CLOCK, RESET)
    begin
		  -- se o reset for ativado, então o elevador vai ir pro andar 0 e ficar parado
        if RESET = '1' then
            andar_atual <= (others => '0');
            estado <= PARADO;
				
        elsif rising_edge(CLOCK) then
--          if clock_pulse = '1' then -- o código só vai executar quando o pulso de subida ocorrer
                case estado is
						
						  -- quando o elevador estiver parado:
						  -- se o andar desejado for acima, ele vai subir
						  -- se o andar desejado for abaixo, ele vai descer
						  -- e se já estiver no andar desejado, ele vai permanecer parado
                    when PARADO =>
                        if andar_desejado > andar_atual then
                            estado <= SUBINDO;
                        elsif andar_desejado < andar_atual then
                            estado <= DESCENDO;
                        else
                            estado <= PARADO;
                        end if;
							
						  -- se ele estiver subindo:
						  -- caso o andar desejado for acima, ele vai subir em 1
						  -- senão, ele já chegou, então ele fica parado
                    when SUBINDO =>
                        if andar_atual < andar_desejado then
                            andar_atual <= andar_atual + 1;
                        else
                            estado <= PARADO;
                        end if;
						  
						  -- se ele estiver descendo:
						  -- caso o andar desejado for abaixo, ele vai descer em 1
						  -- senão, ele já chegou, então ele fica parado
                    when DESCENDO =>
                        if andar_atual > andar_desejado then
                            andar_atual <= andar_atual - 1;
                        else
                            estado <= PARADO;
                        end if;
                end case;
--            end if;
        end if;
    end process;

    -- LEDS pra dizer quando ele estiver parado, subindo ou descendo
    LEDR <= "001" when estado = PARADO else
            "010" when estado = SUBINDO else
            "100";

    -- o melhor jeito que eu achei para separar dezenas e unidades foi utilizando resto
	 -- então aqui a gente vai separar um do outro
	 -- daí cada display vai mostrar somente um dígito
    dez_atual <= std_logic_vector(to_unsigned(to_integer(andar_atual) / 10, 4));
    uni_atual <= std_logic_vector(to_unsigned(to_integer(andar_atual) mod 10, 4));

    dez_req <= std_logic_vector(to_unsigned(to_integer(andar_desejado) / 10, 4));
    uni_req <= std_logic_vector(to_unsigned(to_integer(andar_desejado) mod 10, 4));
	 
	 and_atual <= std_logic_vector(andar_atual);

    -- e aqui a gente vai colocar as saídas para o display
    HEX1 <= to_7seg(dez_atual); -- dezena andar atual
    HEX0 <= to_7seg(uni_atual); -- unidade andar atual

    HEX3 <= to_7seg(dez_req);   -- dezena andar desejado
    HEX2 <= to_7seg(uni_req);   -- unidade andar desejado

end Behavioral;