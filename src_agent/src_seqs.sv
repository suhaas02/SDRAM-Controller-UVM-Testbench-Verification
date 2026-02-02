class src_seqs extends uvm_sequence #(transaction); 

    `uvm_object_utils(src_seqs)
    // transaction xtn; 

    function new(string name = ""); 
        super.new(name); 
    endfunction 

endclass

class write_only_seq extends src_seqs; 
    `uvm_object_utils(write_only_seq)

    function new(string name = ""); 
        super.new(name); 
    endfunction 

    task body(); 
        repeat(10) begin
            `uvm_do_with(req, {in_HSEL == 1'b1; in_HWRITE == 1'b0;})
        end 
    endtask 

endclass

class write_read_seq extends src_seqs; 
    `uvm_object_utils(write_read_seq)

    bit [31:0] addr; 
    bit [31:0] data;

    function new(string name = ""); 
        super.new(name); 
    endfunction 

    task body(); 
        repeat(50) begin 
            `uvm_do_with(req, {in_HSEL == 1'b1; in_HWRITE == 1'b0;}) //write seq
            addr = req.in_HADDR; 
            data = req.in_HWDATA; 
            `uvm_info(get_type_name(), "Done with write, starting with read", UVM_LOW)
            `uvm_do_with(req, {in_HSEL == 1'b1; in_HWRITE == 1'b1; in_HADDR == addr; in_HWDATA == data;}) //read seq;
        end 
    endtask 

endclass