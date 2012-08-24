--
-- Interrupt.vhd
--
-- FPGA Logic for Z80 system
--
-- Nibbles Lab. 2009
--

--
-- Register maps
--
--           +----+----+---+----+---+---+---+---+
-- A=0 (R/W) |         Interrupt Vector         |
--           +----+----+---+----+---+---+---+---+
-- A=1 (R)   |INTi|AUTH|IEI|INTo|IEO| 0 | 0 |EN |
--           +----+----+---+----+---+---+---+---+
-- A=1 (W)   | *  | *  | * |CLR | * | * | * |EN |
--           +----+----+---+----+---+---+---+---+
--
-- EN=1 & RD=1 then read register to DO port and DOEN<=1
--		& WR=1 then write register from DI port
-- INTI=1 then interrupt occurs and INTO<=1
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Interrupt is
    Port ( 	A		: in std_logic;
			DI		: in std_logic_vector(7 downto 0);
			EN		: in std_logic;
			RD		: in std_logic;
			WR		: in std_logic;
			XIORQ	: in std_logic;		-- same as Z80
			XMREQ   : in std_logic;		-- same as Z80
			XM1		: in std_logic;		-- same as Z80
			IEI		: in std_logic;		-- same as Z80
			INTI	: in std_logic;
			DO		: out std_logic_vector(7 downto 0);
			DOEN	: out std_logic;
			INTO	: out std_logic;	-- inverted from original
			IEO		: out std_logic;	-- same as Z80
			RESET	: in std_logic);
end Interrupt;

architecture Behavioral of Interrupt is

-----------------------------------------------------------------------------------
-- Signals
-----------------------------------------------------------------------------------

signal VECT : std_logic_vector(7 downto 0);
signal IREQ : std_logic;
signal IAUTH : std_logic;
signal AUTHRES : std_logic;
signal IED1 : std_logic;
signal IED2 : std_logic;
signal ICB : std_logic;
signal I4D : std_logic;
signal FETCH : std_logic;
signal INTA : std_logic;
signal IENB : std_logic;
signal VECTEN : std_logic;
signal STATEN : std_logic;
signal iINT : std_logic;
signal iIEO : std_logic;
signal AUTHMRES : std_logic;

begin

	--
	-- External signals
	--
	INTO<=iINT;
	IEO<=iIEO;
	DO<=VECT 							  when VECTEN='1' else
		INTI&IAUTH&IEI&iINT&iIEO&"00"&IENB when STATEN='1' else (others=>'0');
	DOEN<=VECTEN or STATEN;

	--
	-- Internal signals
	--
	iINT<='1' when IEI='1' and IREQ='1' and IAUTH='0' else '0';
	iIEO<=not (((not IED1) and IREQ) or IAUTH or (not IEI));
	INTA<=((not XM1) and (not XIORQ) and IEI);
	AUTHRES<=RESET or (IEI and IED2 and I4D) or AUTHMRES;
	FETCH<=XM1 or XMREQ;
	IREQ<=INTI and IENB;
	VECTEN<='1' when ( INTA='1' and IEI='1' and IAUTH='1' ) or ( RD='1' and EN='1' and A='0' ) else '0';
	STATEN<='1' when RD='1' and EN='1' and A='1' else '0';
	AUTHMRES<='1' when WR='1' and EN='1' and A='1' and DI(4)='1' else '0';

	--
	-- Internal Register Access
	--
	process( RESET, WR ) begin
		if RESET='1' then
			VECT<=(others=>'0');
			IENB<='0';
		elsif WR'event and WR='1' then
			if EN='1' then
				if A='0' then
					VECT<=DI;
				else
					IENB<=DI(0);
				end if;
			end if;
		end if;
	end process;

	--
	-- Interrupt Acknowledge
	--
	process( AUTHRES, INTA ) begin
		if AUTHRES='1' then
			IAUTH<='0';
		elsif INTA'event and  INTA='1' then
			IAUTH<=IREQ;
		end if;
	end process;

	--
	-- Fetch 'RETI'
	--
	process( RESET, FETCH ) begin
		if RESET='1' then
			IED1<='0';
			IED2<='0';
			ICB<='0';
			I4D<='0';
		elsif FETCH'event and FETCH='1' then
			IED2<=IED1;
			if DI=X"ED" and ICB='0' then
				IED1<='1';
			else
				IED1<='0';
			end if;
			if DI=X"CB" then
				ICB<='1';
			else
				ICB<='0';
			end if;
			if DI=X"4D" then
				I4D<=IEI;
			else
				I4D<='0';
			end if;
		end if;
	end process;

end Behavioral;
