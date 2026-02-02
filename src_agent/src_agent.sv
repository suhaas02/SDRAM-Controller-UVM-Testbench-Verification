class src_agent extends uvm_agent; 
    `uvm_component_utils(src_agent)

    src_driver sdrvh; 
    src_monitor smonh; 
    src_sequencer sseqrh; 
    config_obj cfgh; 

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    function void build_phase(uvm_phase phase); 

        if(!uvm_config_db #(config_obj)::get(this, "", "config_obj", cfgh))
            `uvm_fatal("NO_CFG_OBJ", "Config object not found")

        if(cfgh.src_is_active == UVM_ACTIVE) begin  
            sdrvh = src_driver::type_id::create("sdrvh", this); 
            sseqrh = src_sequencer::type_id::create("sseqrh", this); 
        end
        smonh = src_monitor::type_id::create("smonh", this); 
        
    endfunction 

    function void connect_phase(uvm_phase phase); 
        sdrvh.seq_item_port.connect(sseqrh.seq_item_export); 

        `uvm_info(get_type_name(), "Driver, seqr connection successful", UVM_LOW)
    endfunction 
endclass