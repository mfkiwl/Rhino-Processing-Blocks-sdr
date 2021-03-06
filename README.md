# RHINO Software-defined radio processing blocks

A library of IP cores needed for FPGA-based SDR development on RHINO board with SPARTAN-6 xc6slx150t device. The cores are classified into: 

#### DSP cores:
 * FIR core
 * IIR core
 * FFT/iFFT core
 * DDC core

#### I/O interface cores:
 * FMC150 ADC/DAC core
 * Gigabit Ethernet (GBe) core
 
## Requirements:
The following hardware/software tools are required to develop, simulate and run the gateware:

 * [RHINO FPGA board](http://www.ohwr.org/projects/rhino-hardware-01/wiki) running [BORPH Linux](https://github.com/SDRG-UCT/borph_rhino) on its ARM processor.
 * Xilinx ISE 14.7
 * A PC with 100 Mbps ethernet link to RHINO ARM processor ethernet interface.
 * An optional 1000 Mbps ethernet link may also be use for communication with RHINO FPGA 1 Gbps ethernet interface.

## Gigabit Ethernet core settings
The following is the current configurations for Gbe core which can be changed to suit the custom Network Setup.

* **ARP Enabled**
* **Speed**                 : 1 Gbps
* **Source Device**         : Spartan 6 FPGA on RHINO
* **Destination Device**    : PC
* **Source MAC**            : 00:24:ba:7d:1d:70 &
* **Source IP**             : 192.168.0.3
* **Destination MAC**       : e0:3f:49:ae:db:b2 
* **Destination IP**        : 192.168.0.1
* **UDP port**              : 9930
* **Gbe Core Clock speed**  : 62.5 MHz

## Performance
* The maximum sampling rate of the FMC150 ADC that can be used on RHINO for streaming via Gbe without ADC signal decimation is `49.152 Msps`. This only applies when FMC150 uses the internal 100 MHz PLL reference clock. It could change if an external reference is used. The results are verified in Experiments 3 & 4.
* The maximum ADC sampling rate on RHINO is `122.88 Msps`, however, this requires that a sampled signal be decimated before transmission through the Gbe. The sample rate after decimation should be less or equal to 49.152 Msps. These results are verified in Experiments 5.
* The maximum throughput speed of a Gbe is `99.06 MBps`. This is obtained when 49.152 Msps ADC is used. The results are verified in Experiments 3 & 4.
* The maximum UDP payload size that can be transmitted through the Gbe is `1474 bytes` (theoretical max is 1500 bytes).	

## Useful Readings
* Scott, S. Rhino: Reconfigurable hardware interface for computation and radio. Master’s thesis,  University Of Cape Town, Nov. 2011.

* Tsoeunyane, L.J. RHINO software-defined radio processing blocks. Master’s thesis,  University of Cape Town, Nov. 2015.

* MARVELL. 88E1111 Datasheet - Integrated 10/100/1000 Ultra Ethernet Transceiver. Dec. 2004.

* MOHOR, I. Ethernet IP Core Specification. OpenCores, Nov. 2002.

* J. Gao, 10_100_1000 Mbps Tri-mode Ethernet MAC Specification. OpenCores, Jan. 2006

* 4DSP. FMC150 User Manual. July 2013.

* R. Vaughan, N. Scott, and D. White, “The theory of bandpass sampling,” Signal Processing, IEEE Transactions on, vol. 39, pp. 1973–1984, Sept 1991.
