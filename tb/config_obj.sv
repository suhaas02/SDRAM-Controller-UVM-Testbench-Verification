class config_obj extends uvm_object; 
    
    `uvm_object_utils(config_obj)

    function new(string name = ""); 
        super.new(name); 
    endfunction 

    uvm_active_passive_enum src_is_active = UVM_ACTIVE; 
    uvm_active_passive_enum dst_is_active = UVM_PASSIVE; 

    virtual sdram_if vif; 

endclass