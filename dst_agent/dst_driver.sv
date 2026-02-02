class dst_driver extends uvm_driver #(transaction); 

    `uvm_component_utils(dst_driver)

    virtual sdram_if vif; 
    config_obj cfgh; 

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase); 

        if(!uvm_config_db #(config_obj)::get(this, "", "config_obj", cfgh))
            `uvm_fatal("NO_CFG_OBJ", "No config object found")

    endfunction 

    function void connect_phase(uvm_phase phase);
        vif = cfgh.vif; 
    endfunction 
    
endclass