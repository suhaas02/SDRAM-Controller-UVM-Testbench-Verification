// https://github.com/yigitbektasgursoy/SDRAM_Verilog/tree/main

`timescale 1ns/1ns

module top; 
    `include "uvm_macros.svh"
    import uvm_pkg::*; 
    import sdram_pkg::*; 
    

    bit clk; 
    initial forever #2 clk = ~clk; 

    sdram_if sif(); 

    assign sif.in_HCLK = clk; 
    
    sdram_top DUT(.in_HCLK(sif.in_HCLK), .in_HRESET(sif.in_HRESET), .in_HWRITE(sif.in_HWRITE), 
                  .in_HSEL(sif.in_HSEL), .in_HWDATA(sif.in_HWDATA), .in_HADDR(sif.in_HADDR),
                  .out_HREADY(sif.out_HREADY), .out_HRDATA(sif.out_HRDATA));

    assign sif.out_write_en = DUT.write_en; //added delay here to check for first missing data that is being missed due to transistion from x to 1, it's taking as 0 in simulator. 
    assign sif.CAS = DUT.CAS; 

    initial begin 
        uvm_config_db #(virtual sdram_if)::set(null, "*", "sdram_if", sif); 
        run_test(); 
    end 

    initial begin 
        `ifdef VCS
                $fsdbDumpvars(0,top);
        `endif
    end


endmodule 