# Parametric-FIR-Filter
This project implements a Finite Impulse Response (FIR) filter using Verilog. The filter is designed to process input data stream with configurable coefficients and widths. This project includes a parameterizable register module, the main FIR filter module, and a testbench for simulation and verification.

The following circuit and equation were used as a reference [link](http://www.ee.ic.ac.uk/pcheung/teaching/ee3_dsd/fir.pdf):

![image](https://github.com/user-attachments/assets/9890c76e-7446-4490-87e2-55757111b9b0)
![image](https://github.com/user-attachments/assets/a476d999-b31b-4409-bf3c-4cbf33b34afd)

## Modules
1. Register Module ('register')
- A simple parameterizable register to hold input data.
2. Main FIR Filter Module ('main')
- The core FIR filter that processes input data based on given coefficients.
3. Testbench Module ('testbench')
- A test bench for simulating the FIR filter.

## Usage
The testbench initializes the FIR filter with a set of coefficients and applies random input data to demonstrate the filtering process. You can modify the coefficients and input data to observe different filtering behaviors.

'''

initial begin
    // Initialize inputs
    CLK = 0;
    h = {4'b1111, 4'b1111, 4'b1111, 4'b1111};  // Example coefficients
    repeat(1000) begin
        #10 X = 4'b0001 + noise();
        #20 X = 4'b0001 + noise();
        #20 X = 4'b1111 + noise();
        #20 X = 4'b1111 + noise();
        #20 X = 4'b0001 + noise();
        #20 X = 4'b0001 + noise();
    end
end

function [1:0] noise;
    begin
        noise = $random % 2;  // Generates a random value between 0 and 1
    end
endfunction

'''
