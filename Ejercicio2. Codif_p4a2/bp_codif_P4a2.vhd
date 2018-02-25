library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bp_codif_P4a2 is
	constant MAX_COMB : integer := 16; -- Num. combinac. entrada (2**4)
	constant DELAY : time := 20 ns; -- Retardo usado en el test
end entity bp_codif_P4a2;



architecture bp_codif_P4a2 of bp_codif_P4a2 is
-- Salidas UUT
	signal activo : std_logic;
	signal codigo : std_logic_vector(1 downto 0);
-- Entradas UUT
	signal x : std_logic_vector(3 downto 0);


	component codif_P4a2 is
		port (  codigo : out std_logic_vector(1 downto 0);
		        activo : out std_logic;
			x      : in std_logic_vector(3 downto 0) );
	end component codif_P4a2;

begin   -- Cuerpo de la arquitectura
	UUT : component codif_P4a2 port map (codigo,activo,x);

	main : process is

		variable esperado_activo : std_logic;
		variable esperado_codigo : std_logic_vector(1 downto 0);
		variable error_count     : integer := 0;	

	begin
		report "Comienza la simulacion";

		-- Generar todos los posibles valores de entrada
		for i in 0 to (MAX_COMB-1) loop
			x <= std_logic_vector(TO_UNSIGNED(i,4));
		
		-- Calcular el valor esperado
			if (i=0) then
				esperado_activo := '0';
				esperado_codigo := "00";
			else
				esperado_activo := '1';
				if (i=1) then esperado_codigo := "00";
				elsif (i<=3) then esperado_codigo := "01";
				elsif (i<=7) then esperado_codigo := "10";
				else esperado_codigo := "11";
				end if;
			end if;

			wait for DELAY; -- Espera y compara con las salidas de UUT
			if ( esperado_activo /= activo ) then
				report "ERROR en la salida valida. Valor esperado: " &
				std_logic'image(esperado_activo) &
				", valor actual: " &
				std_logic'image(activo) &
				" en el instante: " &
				time'image(now);
				error_count := error_count + 1;
			end if;

			if ( esperado_codigo /= codigo ) then
				report "ERROR en la salida codificada. Valor esperado: " &
				std_logic'image(esperado_codigo(1)) &
				std_logic'image(esperado_codigo(0)) &
				", valor actual: " &
				std_logic'image(codigo(1)) &
				std_logic'image(codigo(0)) &
				" en el instante: " &
				time'image(now);
			error_count := error_count + 1;
			end if;
		end loop; -- Final del bucle for de posibles valores de entrada

		-- Informe del numero total de errores
		report "Hay " &
		integer'image(error_count) &
		" errores.";
		wait; -- Final de la simulacion

	end process main;
end architecture bp_codif_P4a2;
