package sdram_pkg; 
    
    `include "uvm_macros.svh"
    import uvm_pkg::*; 

    //object classes
    `include "config_obj.sv"
    `include "transaction.sv"
    `include "src_seqs.sv"
    // `include "dst_seqs.sv"


    //component classes;
    `include "dst_driver.sv"
    `include "dst_monitor.sv"
    `include "dst_sequencer.sv"
    `include "dst_agent.sv"
    `include "src_driver.sv"
    `include "src_monitor.sv"
    `include "src_sequencer.sv"
    `include "src_agent.sv"
    `include "scoreboard.sv"

    //virtual classes
    `include "virtual_sequencer.sv"
    `include "virtual_sequence.sv"
    
    `include "environment.sv"
    `include "test.sv"

endpackage