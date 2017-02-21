--********************************************************************************
--* Company:        University of Cape Town									   
--* Engineer:       Lekhobola Joachim Tsoeunyane, lekhobola@gmail.com		       
--********************************************************************************
--* Create Date:    05-Jul-2014 21:03:05  				 										   
--* Design Name:    Pipelined R2^2 DIF-SDF FFT								       
--* Module Name:    fft256_tf_rom_s0.vhd										   
--* Project Name:   RHINO SDR Processing Blocks								   
--* Target Devices: Xilinx - SPARTAN-6											   
--********************************************************************************
--* Dependencies: none															   
--********************************************************************************
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--********************************************************************************
--* This module implements the stage-0 of twiddle factor ROM for a 256-point      
--* pipelined R2^2 DIF-SDF FFT. Each value is a complex number{imaginary,complex} 
--* ******************************************************************************
--* params:																	   
--*        addr_w - rom address bit width									       
--*        data_w - output data bit width										   
--* ports:																		   
--* 			[in]  addr	- Twidde factor ROM address to read					   
--* 			[out] doutr - Twiddle factor read from rom addr - real value	   
--* 			[out] douti - Twidder factor read from rom addr - imaginary value  
--********************************************************************************
--* Notes: Do not modify this file as it is auto-generated using matlab script    
--********************************************************************************
entity fft256_tf_rom_s0 is
	generic(
		addr_w : natural := 8;
		data_w : natural := 16
	);
    port (
        addr  : in  std_logic_vector (addr_w - 1 downto 0);
        doutr : out std_logic_vector (data_w - 1 downto 0);
        douti : out  std_logic_vector(data_w - 1 downto 0)
 	);
end fft256_tf_rom_s0;

architecture Behavioral of fft256_tf_rom_s0 is
	type complex is array(0 to 1) of std_logic_vector(data_w - 1 downto 0);
	type rom_type is array(0 to (2 ** addr_w) - 1) of complex;

	constant rom : rom_type := (
								 ("0100000000000000","0000000000000000"),
								 ("0011111111101100","1111110011011100"),
								 ("0011111110110001","1111100110111010"),
								 ("0011111101001111","1111011010011100"),
								 ("0011111011000101","1111001110000100"),
								 ("0011111000010101","1111000001110011"),
								 ("0011110100111111","1110110101101100"),
								 ("0011110001000010","1110101001110000"),
								 ("0011101100100001","1110011110000010"),
								 ("0011100111011011","1110010010100011"),
								 ("0011100001110001","1110000111010101"),
								 ("0011011011100101","1101111100011001"),
								 ("0011010100110111","1101110001110010"),
								 ("0011001101101000","1101100111100000"),
								 ("0011000101111001","1101011101100110"),
								 ("0010111101101100","1101010100000101"),
								 ("0010110101000001","1101001010111111"),
								 ("0010101011111011","1101000010010100"),
								 ("0010100010011010","1100111010000111"),
								 ("0010011000100000","1100110010011000"),
								 ("0010001110001110","1100101011001001"),
								 ("0010000011100111","1100100100011011"),
								 ("0001111000101011","1100011110001111"),
								 ("0001101101011101","1100011000100101"),
								 ("0001100001111110","1100010011011111"),
								 ("0001010110010000","1100001110111110"),
								 ("0001001010010100","1100001011000001"),
								 ("0000111110001101","1100000111101011"),
								 ("0000110001111100","1100000100111011"),
								 ("0000100101100100","1100000010110001"),
								 ("0000011001000110","1100000001001111"),
								 ("0000001100100100","1100000000010100"),
								 ("0000000000000000","1100000000000000"),
								 ("1111110011011100","1100000000010100"),
								 ("1111100110111010","1100000001001111"),
								 ("1111011010011100","1100000010110001"),
								 ("1111001110000100","1100000100111011"),
								 ("1111000001110011","1100000111101011"),
								 ("1110110101101100","1100001011000001"),
								 ("1110101001110000","1100001110111110"),
								 ("1110011110000010","1100010011011111"),
								 ("1110010010100011","1100011000100101"),
								 ("1110000111010101","1100011110001111"),
								 ("1101111100011001","1100100100011011"),
								 ("1101110001110010","1100101011001001"),
								 ("1101100111100000","1100110010011000"),
								 ("1101011101100110","1100111010000111"),
								 ("1101010100000101","1101000010010100"),
								 ("1101001010111111","1101001010111111"),
								 ("1101000010010100","1101010100000101"),
								 ("1100111010000111","1101011101100110"),
								 ("1100110010011000","1101100111100000"),
								 ("1100101011001001","1101110001110010"),
								 ("1100100100011011","1101111100011001"),
								 ("1100011110001111","1110000111010101"),
								 ("1100011000100101","1110010010100011"),
								 ("1100010011011111","1110011110000010"),
								 ("1100001110111110","1110101001110000"),
								 ("1100001011000001","1110110101101100"),
								 ("1100000111101011","1111000001110011"),
								 ("1100000100111011","1111001110000100"),
								 ("1100000010110001","1111011010011100"),
								 ("1100000001001111","1111100110111010"),
								 ("1100000000010100","1111110011011100"),
								 ("0100000000000000","0000000000000000"),
								 ("0011111111111011","1111111001101110"),
								 ("0011111111101100","1111110011011100"),
								 ("0011111111010100","1111101101001011"),
								 ("0011111110110001","1111100110111010"),
								 ("0011111110000101","1111100000101010"),
								 ("0011111101001111","1111011010011100"),
								 ("0011111100001111","1111010100001111"),
								 ("0011111011000101","1111001110000100"),
								 ("0011111001110010","1111000111111010"),
								 ("0011111000010101","1111000001110011"),
								 ("0011110110101111","1110111011101110"),
								 ("0011110100111111","1110110101101100"),
								 ("0011110011000101","1110101111101101"),
								 ("0011110001000010","1110101001110000"),
								 ("0011101110110110","1110100011110111"),
								 ("0011101100100001","1110011110000010"),
								 ("0011101010000010","1110011000010001"),
								 ("0011100111011011","1110010010100011"),
								 ("0011100100101011","1110001100111010"),
								 ("0011100001110001","1110000111010101"),
								 ("0011011110110000","1110000001110100"),
								 ("0011011011100101","1101111100011001"),
								 ("0011011000010010","1101110111000011"),
								 ("0011010100110111","1101110001110010"),
								 ("0011010001010011","1101101100100110"),
								 ("0011001101101000","1101100111100000"),
								 ("0011001001110100","1101100010100000"),
								 ("0011000101111001","1101011101100110"),
								 ("0011000001110110","1101011000110010"),
								 ("0010111101101100","1101010100000101"),
								 ("0010111001011010","1101001111011111"),
								 ("0010110101000001","1101001010111111"),
								 ("0010110000100001","1101000110100110"),
								 ("0010101011111011","1101000010010100"),
								 ("0010100111001110","1100111110001010"),
								 ("0010100010011010","1100111010000111"),
								 ("0010011101100000","1100110110001100"),
								 ("0010011000100000","1100110010011000"),
								 ("0010010011011010","1100101110101101"),
								 ("0010001110001110","1100101011001001"),
								 ("0010001000111101","1100100111101110"),
								 ("0010000011100111","1100100100011011"),
								 ("0001111110001100","1100100001010000"),
								 ("0001111000101011","1100011110001111"),
								 ("0001110011000110","1100011011010101"),
								 ("0001101101011101","1100011000100101"),
								 ("0001100111101111","1100010101111110"),
								 ("0001100001111110","1100010011011111"),
								 ("0001011100001001","1100010001001010"),
								 ("0001010110010000","1100001110111110"),
								 ("0001010000010011","1100001100111011"),
								 ("0001001010010100","1100001011000001"),
								 ("0001000100010010","1100001001010001"),
								 ("0000111110001101","1100000111101011"),
								 ("0000111000000110","1100000110001110"),
								 ("0000110001111100","1100000100111011"),
								 ("0000101011110001","1100000011110001"),
								 ("0000100101100100","1100000010110001"),
								 ("0000011111010110","1100000001111011"),
								 ("0000011001000110","1100000001001111"),
								 ("0000010010110101","1100000000101100"),
								 ("0000001100100100","1100000000010100"),
								 ("0000000110010010","1100000000000101"),
								 ("0100000000000000","0000000000000000"),
								 ("0011111111010100","1111101101001011"),
								 ("0011111101001111","1111011010011100"),
								 ("0011111001110010","1111000111111010"),
								 ("0011110100111111","1110110101101100"),
								 ("0011101110110110","1110100011110111"),
								 ("0011100111011011","1110010010100011"),
								 ("0011011110110000","1110000001110100"),
								 ("0011010100110111","1101110001110010"),
								 ("0011001001110100","1101100010100000"),
								 ("0010111101101100","1101010100000101"),
								 ("0010110000100001","1101000110100110"),
								 ("0010100010011010","1100111010000111"),
								 ("0010010011011010","1100101110101101"),
								 ("0010000011100111","1100100100011011"),
								 ("0001110011000110","1100011011010101"),
								 ("0001100001111110","1100010011011111"),
								 ("0001010000010011","1100001100111011"),
								 ("0000111110001101","1100000111101011"),
								 ("0000101011110001","1100000011110001"),
								 ("0000011001000110","1100000001001111"),
								 ("0000000110010010","1100000000000101"),
								 ("1111110011011100","1100000000010100"),
								 ("1111100000101010","1100000001111011"),
								 ("1111001110000100","1100000100111011"),
								 ("1110111011101110","1100001001010001"),
								 ("1110101001110000","1100001110111110"),
								 ("1110011000010001","1100010101111110"),
								 ("1110000111010101","1100011110001111"),
								 ("1101110111000011","1100100111101110"),
								 ("1101100111100000","1100110010011000"),
								 ("1101011000110010","1100111110001010"),
								 ("1101001010111111","1101001010111111"),
								 ("1100111110001010","1101011000110010"),
								 ("1100110010011000","1101100111100000"),
								 ("1100100111101110","1101110111000011"),
								 ("1100011110001111","1110000111010101"),
								 ("1100010101111110","1110011000010001"),
								 ("1100001110111110","1110101001110000"),
								 ("1100001001010001","1110111011101110"),
								 ("1100000100111011","1111001110000100"),
								 ("1100000001111011","1111100000101010"),
								 ("1100000000010100","1111110011011100"),
								 ("1100000000000101","0000000110010010"),
								 ("1100000001001111","0000011001000110"),
								 ("1100000011110001","0000101011110001"),
								 ("1100000111101011","0000111110001101"),
								 ("1100001100111011","0001010000010011"),
								 ("1100010011011111","0001100001111110"),
								 ("1100011011010101","0001110011000110"),
								 ("1100100100011011","0010000011100111"),
								 ("1100101110101101","0010010011011010"),
								 ("1100111010000111","0010100010011010"),
								 ("1101000110100110","0010110000100001"),
								 ("1101010100000101","0010111101101100"),
								 ("1101100010100000","0011001001110100"),
								 ("1101110001110010","0011010100110111"),
								 ("1110000001110100","0011011110110000"),
								 ("1110010010100011","0011100111011011"),
								 ("1110100011110111","0011101110110110"),
								 ("1110110101101100","0011110100111111"),
								 ("1111000111111010","0011111001110010"),
								 ("1111011010011100","0011111101001111"),
								 ("1111101101001011","0011111111010100"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000"),
								 ("0100000000000000","0000000000000000")
							   );
begin
	doutr <= std_logic_vector(rom(conv_integer(addr))(0));
	douti <= std_logic_vector(rom(conv_integer(addr))(1));
end Behavioral;