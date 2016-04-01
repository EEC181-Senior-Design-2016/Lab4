# Lab4
PART 1: construct a soc_system.rb for a given linux file and create LED stack program
- basic follow the lab instructions CAREFULLY
- make sure to add pin assignments
- use the virtual address example to manipulate the LED values

PART 2: create edge detection algorithm
- understand how edge detection works (convolution matrices and reading 8-bit numbers)
- code one in matlab (easily done with built-in image file reading)
- code one in C (converted the jpeg image into a txt file and then use the algorithm)
- code one in C with integration of FPGA SDRAM (use the virtual address example to help)
- code one with C and Verilog accelator
    - in C, write the source text image and store into SDRAM and 
        read from SDRAM when Verilog is done
    - in Verilog, read original image in SDRAM,
        do the algorithm with accelated methods (quick multiplication and at most 1 time DMA for each pixel),
        write result to SDRAM

- the files holding the latest code for each part are:
    - lab4 p1 linux (PART 1)
    - lab4 hps latest (PART 2)
