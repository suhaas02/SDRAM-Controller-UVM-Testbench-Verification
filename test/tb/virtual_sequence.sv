class virtual_sequence extends uvm_sequence #(uvm_sequence_item); 
    `uvm_object_utils(virtual_sequence)

    function new(string name = ""); 
        super.new(name); 
    endfunction 

    virtual_sequencer vseqrh; 
    src_sequencer sseqrh; 

    task body(); 
        if(!$cast(vseqrh, m_sequencer)) begin
            `uvm_fatal("CAST_FAIL", "m_sequencer casting to virtual sequencer failed")
        end
        sseqrh = vseqrh.sseqrh; 
    endtask
endclass

class write_only_vseq extends virtual_sequence; 
    `uvm_object_utils(write_only_vseq)
    write_only_seq wseq; 

    function new(string name = ""); 
        super.new(name); 
    endfunction 

    task body(); 
        // repeat(10) begin
            super.body(); 
            wseq = write_only_seq::type_id::create("wseq");
            wseq.start(sseqrh); 
        // end 
    endtask 

endclass

class write_read_vseq extends virtual_sequence; 
    `uvm_object_utils(write_read_vseq)

    write_read_seq wrseq; 

    function new(string name = ""); 
        super.new(name); 
    endfunction 

    task body(); 
        super.body(); 
        wrseq = write_read_seq::type_id::create("wrseq");
        wrseq.start(sseqrh); 
    endtask 
endclass


