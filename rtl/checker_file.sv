module checker_file (input        in_HCLK,        
                input        in_HRESET,      
                input        in_HWRITE,         
                input        in_HSEL,        
                input [31:0] in_HWDATA,      
                input [31:0] in_HADDR,       
                input         out_HREADY,
                input  [31:0] out_HRDATA );

    //Assertions

	property reset; 
		@(posedge in_HCLK) in_HRESET |-> !in_HWRITE && !in_HSEL && !in_HWDATA && !in_HADDR;
	endproperty 

	property reset_idle;
    	@(posedge in_HCLK) in_HRESET or !in_HSEL |-> sdram_top.sdram_controller.state == 4'b0000; 
	endproperty 

	property read_write_act; 
		@(posedge in_HCLK) disable iff(in_HRESET) in_HSEL && sdram_top.sdram_controller.state == 4'b0000 |=> if($past(in_HWRITE, 1)) 
																	sdram_top.sdram_controller.state == 4'b0001 
																else    
																	sdram_top.sdram_controller.state == 4'b0110; 
	endproperty 

	property read_act; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b0001 |=> sdram_top.sdram_controller.state == 4'b0010; 
	endproperty 

	property read_nop1; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b0010 |=> sdram_top.sdram_controller.state == 4'b0011; 
	endproperty

	property read_cas; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b0011 |=> sdram_top.sdram_controller.state == 4'b0100;
	endproperty 

	property read_nop2; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b0100 |=> sdram_top.sdram_controller.state == 4'b0101; 
	endproperty

	property read_nop3; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b0101 |=> sdram_top.sdram_controller.state == 4'b0000; 
	endproperty

	property write_act; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b0110 |=> sdram_top.sdram_controller.state == 4'b0111; 
	endproperty

	property write_nop1; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b0111 |=> sdram_top.sdram_controller.state == 4'b1000; 
	endproperty

	property write_cas; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b1000 |=> sdram_top.sdram_controller.state == 4'b1001; 
	endproperty

	property write_nop2; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b1001 |=> sdram_top.sdram_controller.state == 4'b1010; 
	endproperty

	property write_nop3; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b1010 |=> sdram_top.sdram_controller.state == 4'b0000; 
	endproperty

	property out_ready; 
		@(posedge in_HCLK) disable iff(in_HRESET) sdram_top.sdram_controller.state == 4'b000 |-> !out_HREADY; 
	endproperty 

	property write_ready; 
		@(posedge in_HCLK) disable iff(in_HRESET) $past(in_HWRITE, 1) ##1 $fell(in_HWRITE) |-> $rose(out_HREADY); 
	endproperty

	// property inhibit; 
	// 	@(posedge in_HCLK) disable iff(in_HRESET) out_CS && out_RAS && out_CAS && out_write_en |=> sdram_top.sdram_controller.state == 4'b0000; 
	// endproperty

	RESET: assert property(reset)
		   		$info("Read/Write to ACT transition verified");
			else
				$error("Read/Write to ACT transition failed");

	RESET_IDLE: assert property(reset_idle)
					$info("Reset to IDLE transition verified");
				else
					$error("Reset to IDLE transition failed");

	READ_WRITE_ACT: assert property(read_write_act) 
						$info("Read/Write to ACT transition verified");
					else
						$error("Read/Write to ACT transition failed");

	READ_ACT: assert property(read_act)
						$info("Read to ACT transition verified");
					else
						$error("Read to ACT transition failed");

	READ_NOP1: assert property(read_nop1)
						$info("Read NOP1 transition verified");
					else
						$error("Read NOP1 transition failed");

	READ_CAS: assert property(read_cas)
						$info("Read CAS transition verified");
					else
						$error("Read CAS transition failed");

	READ_NOP2: assert property(read_nop2)
						$info("Read NOP2 transition verified");
					else
						$error("Read NOP2 transition failed");

	READ_NOP3: assert property(read_nop3)
						$info("Read NOP3 transition verified");
					else
						$error("Read NOP3 transition failed");

	WRITE_ACT: assert property(write_act)
						$info("Write to ACT transition verified");
					else
						$error("Write to ACT transition failed");

	WRITE_NOP1: assert property(write_nop1)
						$info("Write NOP1 transition verified");
					else
						$error("Write NOP1 transition failed");

	WRITE_CAS: assert property(write_cas)
						$info("Write CAS transition verified");
					else
						$error("Write CAS transition failed");

	WRITE_NOP2: assert property(write_nop2)
						$info("Write NOP2 transition verified");
					else
						$error("Write NOP2 transition failed");	

	WRITE_NOP3: assert property(write_nop3)
						$info("Write NOP3 transition verified");
					else
						$error("Write NOP3 transition failed");

	OUT_READY: assert property(out_ready)
						$info("Out_ready signal property verified");
				else
						$error("Out_ready signal property failed");

	WRITE_READY: assert property(write_ready)
						$info("write_ready property verified"); 
				else
						$error("write_ready property failed"); 
	// INHIBIT: assert property(inhibit); 

	//cover properties; 
	CRESET_IDLE: cover property(reset_idle); 
	CREAD_WRITE_ACT: cover property(read_write_act); 
	CREAD_ACT: cover property(read_act); 
	CREAD_NOP1: cover property(read_nop1); 
	CREAD_CAS: cover property(read_cas); 
	CREAD_NOP2: cover property(read_nop2); 
	CREAD_NOP3: cover property(read_nop3); 
	CWRITE_ACT: cover property(write_act); 
	CWRITE_NOP1: cover property(write_nop1); 
	CWRITE_CAS: cover property(write_cas); 
	CWRITE_NOP2: cover property(write_nop2); 
	CWRITE_NOP3: cover property(write_nop3);
	COUT_READY: cover property(out_ready); 
	CWRITE_READY: cover property(write_ready); 

endmodule 