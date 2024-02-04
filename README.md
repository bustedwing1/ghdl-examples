# ghdl-examples
VHDL examples simulated using GHDL.


Install GHDL and GTKWave on Ubuntu 22.04
----------------------------

```bash
sudo apt update
sudo apt install ghdl gtkwave
```

Install GHDL from Source
------------------------

If you get the following error:

```bash
error: unit "numeric_std" not found in library "ieee"
```

then you can build ghdl from source

```bash
sudo apt update
sudo apt install gnat-gps
git clone https://github.com/ghdl/ghdl
cd ghdl
./configure
make
sudo make install
```


Compile VHDL Blinky RTL and Testbench
-------------------------------------

There are two steos to compile a VHDL program with GHDL.  The first step is to 
analyze the VHDL source files and the second step is to elaborate, producing the
compiled executable.

```bash
ghdl -a --std=08 blinky.vhd blinky_tb.vhd
ghdl -e --std=08 tb
```


Simulate VHDL Blinky with GHDL
------------------------------

The simulation is run with the ```-r``` option and the signal waveform is output
with the ```--vcd``` option.  A VCD file is an ASCII text Value Change Dump file
captures signal transitions from the simulator.

```bash
ghdl -r --std=08 tb --vcd=test.vcd
```


View Signal Waves with GTKWave
------------------------------

```bash
gtkwave test.vcd
```







