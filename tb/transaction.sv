class transaction extends uvm_sequence_item; 

    rand bit in_HRESET; 
    rand bit in_HWRITE; 
    rand bit in_HSEL; 
    rand bit [31:0] in_HWDATA; 
    rand bit [31:0] in_HADDR; 
    bit out_HREADY; 
    bit [31:0] out_HRDATA; 

    `uvm_object_utils_begin(transaction)
        `uvm_field_int(in_HRESET, UVM_ALL_ON)
        `uvm_field_int(in_HWRITE, UVM_ALL_ON)
        `uvm_field_int(in_HSEL, UVM_ALL_ON)
        `uvm_field_int(in_HWDATA, UVM_ALL_ON)
        `uvm_field_int(in_HADDR, UVM_ALL_ON)
        `uvm_field_int(out_HREADY, UVM_ALL_ON)
        `uvm_field_int(out_HRDATA, UVM_ALL_ON)
    `uvm_object_utils_end 

    function new(string name =""); 
        super.new(name); 
    endfunction 

    constraint reset{in_HRESET dist {0:=90, 1:= 10};};


endclass
