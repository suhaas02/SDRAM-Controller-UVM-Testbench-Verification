class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item); 
    `uvm_component_utils(virtual_sequencer)

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    src_sequencer sseqrh; 
    // read_sequencer rseqrh; 

endclass