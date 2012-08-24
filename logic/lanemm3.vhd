--
-- lanemm3.vhd
--
-- CPLD Logic for access to Ethernet and EMM
-- for MZ-80B/80B2/2000/2200/700/800/1500/2500
--
-- Nibbles Lab. 2006-2010
--

--
-- Including access logics:
--               Address Address Address Data  Data    Mapping    SW
--               A19-A16 A15-A8   A7-A0  Write Read
-- EMM(2500)       $AC     $AC     $AD    $AD   $AD $00000-$9FFFF  1
-- ROM(2500)       $A8     $A8     $A9          $A9 $00000-$9FFFF  2
-- RAM FILE                $EB     $EB    $EA   $EA $90000-$9FFFF  3
-- EMM(700)        $02     $01     $00    $03   $03 $A0000-$EFFFF  4
-- EMM(80B/2000)   $A2     $A1     $A0    $A3   $A3 $A0000-$EFFFF  5
-- CMOS RAM                $A8     $A9    $AA   $A9 $F0000-$F7FFF  6
--   (Read only)           $F8     $F9          $F9 $F0000-$F7FFF  6
--                                        (Extended $F0000-$FE7FF)
-- Ex.ROM(700)   $E800-$EFFF                        $FE800-$FEFFF  7
-- FD ROM(700)   $F000-$FFFF                        $FF000-$FFFFF  8
--
-- W5100         $60-$63
-- INT. vector   $64
-- INT. status   $65
-- MEMO          $66
-- BUF-ADR/STAT  $68
-- E2P-BUF R/W   $69
-- UNLOCK        $6F
--
-- MZ-700 BANK   $E1 Disappear I/O and ROM
--               $E3 Appear I/O and ROM
--               $E4 Appear I/O and ROM
--
-- UFM contents
--  00    Settings
--		bit7 0/Setting valid 1/Invalid
--		bit6 Reserved
--		bit5 Reserved
--		bit4 Reserved
--		bit3 Reserved
--		bit2 Reserved
--		bit1 Reserved
--		bit0 0/Fix address 1/DHCP
--  01-04 GW address
--  05-08 Sub Net mask
--  09-0E MAC address
--  0F-12 IP address
--  13-16 DNS address
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lanemm3 is
    Port (
			-- for MZ-bus
			A		: in std_logic_vector(15 downto 0);
			D		: inout std_logic_vector(7 downto 0);
			XRD		: in std_logic;
			XWR		: in std_logic;
			XIORQ	: in std_logic;
			XMREQ	: in std_logic;
			XM1		: in std_logic;
			IEI		: in std_logic;
			XINTO	: out std_logic;
			IEO		: out std_logic;
			ZCLK	: in std_logic;
			RESET	: in std_logic;
			OEN		: out std_logic;
			-- for local bus(common)
			XWRO	: out std_logic;
--			TSTO	: out std_logic;
			-- for EMM
			AO		: out std_logic_vector(17 downto 0);
			XUB		: out std_logic;
			XLB		: out std_logic;
			XCSRAM1 : out std_logic;
			XCSRAM2 : out std_logic;
			-- for W5100/W3100A
			XCSLAN	: out std_logic;
			XINTI	: in std_logic;
			XRESET	: out std_logic;
			-- setting
			SW		: in std_logic_vector(1 to 8)
	);
end lanemm3;

architecture Behavioral of lanemm3 is

-----------------------------------------------------------------------------------
-- Signals
-----------------------------------------------------------------------------------

-- Extended Memory for MZ
signal CS00 : std_logic;
signal CS01 : std_logic;
signal CS02 : std_logic;
signal CS03 : std_logic;
signal CSA0 : std_logic;
signal CSA1 : std_logic;
signal CSA2 : std_logic;
signal CSA3 : std_logic;
signal CSA8 : std_logic;
signal CSA9 : std_logic;
signal CSAC : std_logic;
signal CSAD : std_logic;
signal CSE8 : std_logic;
signal CSEA : std_logic;
signal CSEB : std_logic;
signal CSF0 : std_logic;
signal CSF8 : std_logic;
signal CSF9 : std_logic;
signal CSFA : std_logic;
signal EMMREG : std_logic_vector(19 downto 8);
signal ROMREG : std_logic_vector(19 downto 8);
signal EMM2REG : std_logic_vector(18 downto 0);
signal CMOSREG : std_logic_vector(15 downto 0);
signal RFREG : std_logic_vector(15 downto 0);

-- BUS access control
signal XIOW : std_logic;
signal XIOR : std_logic;
--signal XIORW : std_logic;
signal IOW : std_logic;
signal IOR : std_logic;
--signal iIOW : std_logic;
--signal iIOR : std_logic;
signal CSBANK : std_logic;
signal ENROM : std_logic;

-- Local bus control
signal CSLOCK : std_logic;
signal CSLAN : std_logic;
signal CSPEN : std_logic;
signal CSMEN : std_logic;
signal CS0X : std_logic;
signal CSAX : std_logic;
signal AOREG : std_logic_vector(19 downto 0);
signal UP03 : std_logic;
signal UPEA : std_logic;
signal UPF9 : std_logic;
signal UPFA : std_logic;
signal WENROM : std_logic;
signal ENEMM : std_logic;
signal ENEXT : std_logic;
signal UNLOCK : std_logic;

-- Interrupt control
signal CSINT : std_logic;
signal DOINT : std_logic_vector(7 downto 0);
signal DOEN : std_logic;
signal INTI : std_logic;
signal INTO : std_logic;
signal IEOI : std_logic;

-- UFM control
signal CSCNFA : std_logic;
signal CSCNFD : std_logic;
--signal CSFSTS : std_logic;
signal CONFA : std_logic_vector(7 downto 0);
signal CNFRA : std_logic_vector(7 downto 0);
signal CNFWA : std_logic_vector(7 downto 0);
signal CNFWD : std_logic_vector(7 downto 0);
signal FER : std_logic;
signal FRE : std_logic;
signal FWR : std_logic;
signal FDVAL : std_logic;
signal FDOUT : std_logic_vector(7 downto 0);
signal FBUSY : std_logic;
signal PGEN : std_logic_vector(2 downto 0);
signal FREN : std_logic;
signal FWEN : std_logic;
signal FEEN : std_logic;
signal WPOFF : std_logic;
signal FDATA : std_logic_vector(7 downto 0);

-- Miscellaneous
signal RESMEMO : std_logic;
signal CSMEMO : std_logic;
signal MEMOREG : std_logic_vector(7 downto 0);
--signal CSTST : std_logic;

-----------------------------------------------------------------------------------
-- Components
-----------------------------------------------------------------------------------

component Interrupt
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
end component;

component flash
	PORT (	addr		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			datain		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			nerase		: IN STD_LOGIC ;
			nread		: IN STD_LOGIC ;
			nwrite		: IN STD_LOGIC ;
			data_valid	: OUT STD_LOGIC ;
			dataout		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			nbusy		: OUT STD_LOGIC);
end component;

begin

-----------------------------------------------------------------------------------
-- I/O and Memory access
-----------------------------------------------------------------------------------

	--
	-- Instantiation
	--
	U0 : Interrupt
    Port map (
		 	A	  => A(0),
			DI	  => D,
			EN	  => CSINT,
			RD	  => IOR,
			WR	  => IOW,
			XIORQ => XIORQ,
			XMREQ => XMREQ,
			XM1	  => XM1,
			IEI	  => IEI,
			INTI  => INTI,
			DO	  => DOINT,
			DOEN  => DOEN,
			INTO  => INTO,
			IEO	  => IEOI,
			RESET => RESET
	);

	U1 : flash
	Port map (
			addr	   => '0'&CONFA,
			datain	   => CNFWD,
			nerase	   => FER,
			nread	   => FRE,
			nwrite	   => FWR,
			data_valid => FDVAL,
			dataout	   => FDOUT,
			nbusy	   => FBUSY
	);

	--
	-- External signals
	--
	XCSRAM1<='0' when AOREG(19)='0' and ( CSAD='1' or CSA9='1' ) and XIORQ='0' else '1';
	XCSRAM2<='0' when AOREG(19)='1' and (
					( ( CSAD='1' or CSA9='1' or CS03='1' or CSA3='1' or ( CSF9='1' and XRD='0' ) or CSEA='1' or CSFA='1' ) and XIORQ='0' ) or
					( ( CSE8='1' or CSF0='1' ) and XMREQ='0' ) ) else '1';
	AO<=AOREG(17 downto 0);
	XLB<=AOREG(18);
	XUB<=not AOREG(18);
	XCSLAN<='0' when XIORQ='0' and CSLAN='1' else '1';
	XRESET<=not RESET;
--	XCSLAN<=FRE;
--	XRESET<=FREN;
	XINTO<='0' when INTO='1' else 'Z';
	IEO<='0' when IEOI='0' else 'Z';
	OEN<='1' when ( XRD='0' and ( ( XIORQ='0' and CSPEN='1' ) or ( XMREQ='0' and CSMEN='1' ) ) ) or DOEN='1' else '0';
	D<=DOINT when DOEN='1' else
	   EMM2REG(7 downto 0) when ( XIOR='0' and ( CS00='1' or CSA0='1' ) ) else
	   EMM2REG(15 downto 8) when ( XIOR='0' and ( CS01='1' or CSA1='1' ) ) else
	   "00000"&EMM2REG(18 downto 16) when ( XIOR='0' and ( CS02='1' or CSA2='1' ) ) else
	   MEMOREG when ( XIOR='0' and CSMEMO='1' ) else
	   WPOFF&"00000"&FDVAL&FBUSY when ( XIOR='0' and CSCNFA='1' ) else
	   FDATA when ( XIOR='0' and CSCNFD='1' ) else
--	   CNFWD when ( XIOR='0' and CSTST='1' ) else
	   (others=>'Z');
	XWRO<=XWR or ( ( CSE8 or CSF0 ) and WENROM );
--	XWRO<=XWR;

	--
	-- Internal signals
	--
	XIOW<=XIORQ or XWR;
	IOW<=not XIOW;
	XIOR<=XIORQ or XRD;
	IOR<=not XIOR;
--	XIORW<=XIORQ or ( XRD and XWR );
	CS0X<='1' when A(7 downto 2)="000000" and SW(4)='0' else '0';
	CS00<='1' when A(7 downto 0)=X"00" and SW(4)='0' else '0';
	CS01<='1' when A(7 downto 0)=X"01" and SW(4)='0' else '0';
	CS02<='1' when A(7 downto 0)=X"02" and SW(4)='0' else '0';
	CS03<='1' when A(7 downto 0)=X"03" and SW(4)='0' else '0';
	CSAX<='1' when A(7 downto 2)="101000" and SW(4)='0' else '0';
	CSA0<='1' when A(7 downto 0)=X"A0" and SW(5)='0' else '0';
	CSA1<='1' when A(7 downto 0)=X"A1" and SW(5)='0' else '0';
	CSA2<='1' when A(7 downto 0)=X"A2" and SW(5)='0' else '0';
	CSA3<='1' when A(7 downto 0)=X"A3" and SW(5)='0' else '0';
	CSA8<='1' when A(7 downto 0)=X"A8" and SW(2)='0' else '0';
	CSA9<='1' when A(7 downto 0)=X"A9" and SW(2)='0' else '0';
	CSAC<='1' when A(7 downto 0)=X"AC" and ( SW(1)='0' or ENEMM='1' ) else '0';
	CSAD<='1' when A(7 downto 0)=X"AD" and ( SW(1)='0' or ENEMM='1' ) else '0';
	CSEA<='1' when A(7 downto 0)=X"EA" and SW(3)='0' else '0';
	CSEB<='1' when A(7 downto 0)=X"EB" and SW(3)='0' else '0';
	CSF8<='1' when (A(7 downto 0)=X"F8" or A(7 downto 0)=X"A8") and SW(6)='0' else '0';
	CSF9<='1' when (A(7 downto 0)=X"F9" or A(7 downto 0)=X"A9") and SW(6)='0' else '0';
	CSFA<='1' when (A(7 downto 0)=X"AA") and SW(6)='0' else '0';
	CSE8<='1' when A(15 downto 11)="11101" and SW(7)='0' and ENROM='1' and XMREQ='0' else '0';
	CSF0<='1' when A(15 downto 12)="1111" and SW(8)='0' and ENROM='1' and XMREQ='0' else '0';
	CSBANK<='1' when A(7 downto 3)="11100" else '0';
	CSINT<='1' when A(7 downto 1)="0110010" else '0';
	RESMEMO<='1' when (A(7 downto 0)=X"60" and D(7)='1' and XIOW='0') or RESET='1' else '0';
	CSCNFA<='1' when A(7 downto 0)=X"68" else '0';
	CSCNFD<='1' when A(7 downto 0)=X"69" else '0';
--	CSFSTS<='1' when A(7 downto 0)=X"6A" else '0';
	CSMEMO<='1' when A(7 downto 0)=X"66" else '0';
--	CSTST<='1' when A(7 downto 0)=X"67" else '0';
	CSLOCK<='1' when A(7 downto 0)=X"6F" else '0';
	CSLAN<='1' when A(7 downto 2)="011000" else '0';
	CSPEN<=CS0X or CSAX or CSA9 or CSAD or CSEA or CSF9 or CSLAN or CSMEMO or CSCNFD or CSCNFA;
--	CSPEN<=CS0X or CSAX or CSA9 or CSAD or CSEA or CSF9 or CSLAN or CSMEMO or CSCNFD or CSCNFA or CSTST;
	CSMEN<=CSE8 or CSF0;
	AOREG<="1111"&A when CSE8='1' or CSF0='1' else
		   EMMREG&A(15 downto 8) when CSAD='1' else
		   ROMREG&A(15 downto 8) when CSA9='1' else
		   '1'&(EMM2REG(18 downto 16)+"010")&EMM2REG(15 downto 0) when CSA3='1' or CS03='1' else
		   "1111"&CMOSREG when CSFA='1' or CSF9='1' else
		   "1001"&RFREG when CSEA='1' else
		   (others=>'0');
	INTI<=not XINTI;
	CONFA<=CNFRA when FREN='0' else CNFWA when FWEN='0' else (others=>'0');
	FER<=PGEN(2) or FEEN;
	FRE<=PGEN(2) or FREN;
	FWR<=PGEN(2) or FWEN;

	--
	-- Internal Register Access
	--
	process( RESET, RESMEMO, ZCLK ) begin
		if RESET='1' then
			EMMREG<=(others=>'0');
			EMM2REG<=(others=>'0');
			CMOSREG<=(others=>'0');
			ROMREG<=(others=>'0');
			RFREG<=(others=>'0');
			ENEXT<='0';
			ENEMM<='0';
			WENROM<='1';
			UNLOCK<='0';
			ENROM<='1';
			UP03<='0';
			UPEA<='0';
			UPF9<='0';
			UPFA<='0';
			PGEN<=(others=>'1');
			FREN<='1';
			FEEN<='1';
			FWEN<='1';
			WPOFF<='0';
			CNFWD<=(others=>'0');
			CNFRA<=(others=>'0');
			CNFWA<=(others=>'0');
		elsif RESMEMO='1' then
			MEMOREG<=(others=>'0');
		elsif ZCLK'event and ZCLK='1' then
			if XIORQ='0' then

				-- I/O write access
				if XWR='0' then
					if CS00='1' or CSA0='1' then
						EMM2REG(7 downto 0)<=D;
					end if;
					if CS01='1' or CSA1='1' then
						EMM2REG(15 downto 8)<=D;
					end if;
					if CS02='1' or CSA2='1' then
						EMM2REG(18 downto 16)<=D(2 downto 0);
					end if;
					if CSA8='1' then
						ROMREG(19 downto 16)<=A(11 downto 8);
						ROMREG(15 downto 8)<=D;
					end if;
					if CSAC='1' then
						EMMREG(19 downto 16)<=A(11 downto 8);
						EMMREG(15 downto 8)<=D;
					end if;
					if CSBANK='1' then
						case A(2 downto 0) is
							when "001" => ENROM<='0';
							when "011" => ENROM<='1';
							when "100" => ENROM<='1';
							when others => ENROM<=ENROM;
						end case;
					end if;
					if CSEB='1' then
						RFREG(15 downto 8)<=A(15 downto 8);
						RFREG(7 downto 0)<=D;
					end if;
					if CSF8='1' then
						CMOSREG(15 downto 8)<=(ENEXT and D(7))&D(6 downto 0);
					end if;
					if CSF9='1' then
						CMOSREG(7 downto 0)<=D;
					end if;
					if CSFA='1' then
						UPFA<='1';
					end if;
					if CSLOCK='1' then
						case D is
							when X"D1" =>	-- UNLOCK keyword
								UNLOCK<='1';
							when X"12" => 	-- CMOS RAM extended Add. (MZ-1R12)
								if UNLOCK='1' then
									ENEXT<='1';
									UNLOCK<='0';
								end if;
							when X"37" => 	-- EMM enable(MZ-1R37)
								if UNLOCK='1' then
									ENEMM<='1';
									UNLOCK<='0';
								end if;
							when X"05" => 	-- ROM write enable(MZ-700)
								if UNLOCK='1' then
									WENROM<='0';
									UNLOCK<='0';
								end if;
							when X"57" =>	-- UFM Erase
								if UNLOCK='1' then
									PGEN<="111";
									FEEN<='0';
									UNLOCK<='0';
								end if;
							when X"0F" =>	-- UFM Write protect off
								if UNLOCK='1' then
									WPOFF<=not WPOFF;
									UNLOCK<='0';
								end if;
							when others => UNLOCK<='0';
						end case;
					end if;
					if CSMEMO='1' then
						MEMOREG<=D;
					end if;
					if CSCNFA='1' then
						CNFRA<=D;
						CNFWA<=D;
						PGEN<="111";
						FREN<='0';
					end if;
					if CSCNFD='1' and WPOFF='1' then
						CNFWD<=D;
						PGEN<="111";
						FWEN<='0';
					end if;
				end if;

				-- I/O read access
				if XRD='0' then
					if CSF9='1' then
						UPF9<='1';
					end if;
					if CSF8='1' then
						CMOSREG<=(others=>'0');
					end if;
					if CSCNFD='1' then
						PGEN<="111";
						FREN<='0';
					end if;
				end if;

			-- Both access
				if CS03='1' or CSA3='1' then
					UP03<='1';
				end if;
				if CSEA='1' then
					UPEA<='1';
				end if;

			-- Address count up
			else		--	XIORQ='1'
				if UPFA='1' or UPF9='1' then
					if ENEXT='1' then
						CMOSREG<=CMOSREG+'1';
					else
						CMOSREG<='0'&(CMOSREG(14 downto 0)+'1');
					end if;
				end if;
				if UP03='1' then
					EMM2REG<=EMM2REG+'1';
				end if;
				if UPEA='1' then
					RFREG<=RFREG+'1';
				end if;
				UPFA<='0';
				UPF9<='0';
				UP03<='0';
				UPEA<='0';
			end if;

			-- UFM access
			if PGEN="011" then
				if FREN='0' then
					CNFRA<=CNFRA+'1';
				end if;
				if FWEN='0' then
					CNFWA<=CNFWA+'1';
				end if;
				PGEN<="110";
				FREN<='1';
				FWEN<='1';
				FEEN<='1';
			elsif PGEN/="110" then
				PGEN<=PGEN+'1';
			end if;

		end if;
	end process;

	-- Latch UFM output
	process( FDVAL, FDOUT ) begin
		if FDVAL='1' then
			FDATA<=FDOUT;
		end if;
	end process;

end Behavioral;
