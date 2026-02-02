class dst_seqs extends uvm_sequence #(transaction); 

    `uvm_object_utils(dst_seqs)
    transaction xtn; 

    function new(string name = ""); 
        super.new(name); 
    endfunction 

endclass

class dst_only_seq extends dst_seqs; 
    `uvm_object_utils(dst_only_seq)
    transaction xtn; 

    function new(string name = ""); 
        super.new(name); 
    endfunction 

    task body(); 
        repeat(5) begin 
            start_item(xtn); 
            assert(xtn.randomize() with {rreq == 1; wreq == 0;}); 
            finish_item(xtn); 
        end
    endtask 
endclass