--********************************************************************************
--* Company:        University of Cape Town									   
--* Engineer:       Lekhobola Joachim Tsoeunyane, lekhobola@gmail.com		       
--********************************************************************************
--* Create Date:    30-June-2014 20:29:30  				 										   
--* Design Name:    Pipelined R2^2 DIF-SDF FFT								       
--* Module Name:    fft8_tb.vhd										   
--* Project Name:   RHINO SDR Processing Blocks								   
--* Target Devices: Xilinx - SPARTAN-6											   
--********************************************************************************
--* Dependencies: fft8.vhd
--********************************************************************************
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.MATH_REAL.ALL;
USE STD.TEXTIO.all;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
--********************************************************************************
--* This is a testbench for the complex 16-point Radix 2^2 single-path delay 
--* feedback pipelined FFT core. 
--********************************************************************************
--* params:	none
--*									   
--* ports:  none																		   
--* 			
--********************************************************************************
--* Notes: none    
--********************************************************************************
ENTITY rhino_r22sdf_ifft_core_tb IS
END rhino_r22sdf_ifft_core_tb;

ARCHITECTURE behavior OF rhino_r22sdf_ifft_core_tb IS
	-- Component Declaration
	COMPONENT rhino_r22sdf_ifft_core IS
	GENERIC(
		N		 : NATURAL := 8;
		DIN_W  : NATURAL := 11;
		TF_W   : NATURAL := 16
	);
	PORT(
		CLK,RST : IN STD_LOGIC;
		XKr,XKi : IN STD_LOGIC_VECTOR(DIN_W - 1 downto 0);
		VLD     : OUT STD_LOGIC;
		XSr,XSi : OUT STD_LOGIC_VECTOR(DIN_W - INTEGER(LOG2(real(N))) + 1 downto 0)
	);
	END COMPONENT rhino_r22sdf_ifft_core;

	-- constants definition
		
	constant clk_period : time := 20 ns;
	-- FFT length
	constant N	: integer := 8;
	-- Clock period definitions
	-- Input bit width
	constant inW : integer := 11;
	-- Output bitwidth = inW + integer(log2(real(N))
	constant outW : integer := inW - integer(log2(real(N))) + 2;
	
	-- types definition
	
	-- Input complex number type
	type in_complex is array(0 to 1) of std_logic_vector(inW - 1 downto 0);
	type fileTypeIn is array(0 to N - 1) of in_complex;
	-- Output complex number type
	type out_complex is array(0 to 1) of std_logic_vector(outW - 1 downto 0);
	type fileTypeOut is array(0 to N - 1) of out_complex;

	function ReadFile (f_name : in string) return fileTypeIn is
		-- open a file in read mode
		file f_obj      : text open read_mode is f_name;
		variable space  : character;
		variable f_line : line;
		variable f_data : fileTypeIn;
		variable i		 : integer := 0;
		begin
			while not endfile(f_obj) loop
				--- read data line by line from the file
				readline(f_obj,f_line);
				read(f_line,f_data(i)(0)); read(f_line,space); read(f_line,f_data(i)(1));
				i := i+1;
			end loop;
		return f_data;
	end function;			

   -- Reverses the bits of the integer value passed
	function bitReversedIndex(index : in integer) return integer is
		constant size : integer := integer(log2(real(N)));
		variable oldIndex : std_logic_vector(size - 1 downto 0) := std_logic_vector(to_unsigned(index, size));
		variable newIndex : std_logic_vector(size - 1 downto 0) := (others => '0');
		begin
			for i in 0 to size-1 loop
				newIndex(i) := oldIndex(size - i - 1);
			end loop;
		return to_integer(unsigned(newIndex));
	end function;

	SIGNAL clk,rst,flag,vld :  std_logic := '0';
	SIGNAL xkr      : std_logic_vector (inW - 1 downto 0) := (others => '0');
	SIGNAL xki      : std_logic_vector (inW - 1 downto 0) := (others => '0');
	SIGNAL xsr      : std_logic_vector (inW - integer(log2(real(N))) + 1  downto 0) := (others => '0'); -- real fft output = w + log2(N)
	SIGNAL xsi      : std_logic_vector (inW - integer(log2(real(N))) + 1 downto 0) := (others => '0');

	-- Stores input data samples
	SIGNAL datain : fileTypeIn := ReadFile("ipcore_dir/RHINO_IFFT_CORE_Lib/rhino_r22sdf_ifft_core/data/FFTDataIn.dat");
	-- Stores output data samples
	SIGNAL dataout : fileTypeOut;
	
BEGIN

	rhino_r22sdf_ifft_core_inst : rhino_r22sdf_ifft_core 
	GENERIC MAP(
		N		 => 8,
		DIN_W  => inW,
		TF_W   =>  16
	)
	PORT MAP(
		CLK => CLK,
		RST => RST,
		XKr => XKr,
		XKi => XKi,
		VLD => VLD,
		XSr => XSr,
		XSi => XSi
	);
	
	-- Clock process definitions
	clk_process :process		
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	-- Stimulus process
	stim_proc: process
		-- open a file in read mode
		file f_obj      : text open write_mode is "ipcore_dir/RHINO_IFFT_CORE_Lib/rhino_r22sdf_ifft_core/data/fpgaFFT.dat";
		variable f_line : line;
		variable space  : character := ' ';
	begin	
		-- Makes sure the inputs and system components are initially reset
		XKr <= "00000000000";
		XKi <= "00000000000";		
		rst <= '1';	
		-- Wait for clock to settle
		wait for clk_period*4;	
		-- Feed input samples to a simulator / testbench
		for i in 0 to N - 1 loop
			wait until rising_edge(clk);
			xkr <= datain(i)(0);
			xki <= datain(i)(1);			
			rst <= '0';
			-- Set flag to indicate the first result sample is available 
			-- "read_result" process can now start
			if(i = N-1) then
				flag<='1';
			end if;
		end loop;  
		
		-- Reset input after feeding data to a simulator
		wait for clk_period;		
		xkr <= "00000000000";
		xki <= "00000000000"; 
		
		-- Wait for FFT operation to complete for duration of clk_perion*N
		wait for clk_period*(N);	
		-- "read_result" process stops
		flag<='0';
		
		-- Write all output samples to a file
		for i in 0 to N - 1 loop
			--- write data line by line from the file
			write(f_line,to_integer(signed(dataout(bitReversedIndex(i))(0))));
			write(f_line,space);
			write(f_line,to_integer(signed(dataout(bitReversedIndex(i))(1))));
			writeline(f_obj,f_line);
			wait for clk_period;
		end loop;  
		wait;
	end process;

	-- Read the fft ouput samples when flag is raised
	read_result: process(clk)
		variable count : integer range 0 to N-1 := 0;
	begin	
		if(rising_edge(clk)) then
			if(flag = '1') then
				dataout(count)(0) <= XSr;
				dataout(count)(1) <= xSi;
				count := count + 1;
			end if;
		end if;
	end process;
END;
