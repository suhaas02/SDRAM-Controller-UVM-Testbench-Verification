interface sdram_if; 
    logic in_HCLK; 
    logic in_HRESET; 
    logic in_HWRITE; 
    logic in_HSEL; 
    logic [31:0] in_HWDATA; 
    logic [31:0] in_HADDR; 
    logic out_HREADY; 
    logic [31:0] out_HRDATA; 
    logic out_write_en; 
    logic CAS; 
endinterface