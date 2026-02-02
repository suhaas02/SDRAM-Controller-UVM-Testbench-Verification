class dst_agent extends uvm_agent; 

    `uvm_component_utils(dst_agent)

    dst_driver ddrvh; 
    dst_monitor dmonh; 
    dst_sequencer dseqrh; 
    config_obj cfgh; 

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase); 

        if(!uvm_config_db #(config_obj)::get(this, "", "config_obj", cfgh))
            `uvm_fatal("NO_CFG_OBJ", "No config object found")

        if(cfgh.dst_is_active == UVM_ACTIVE) begin 
            ddrvh = dst_driver::type_id::create("ddrvh", this); 
            dseqrh = dst_sequencer::type_id::create("dseqrh", this); 
        end
        dmonh = dst_monitor::type_id::create("dmonh", this);
    endfunction 

    function void connect_phase(uvm_phase phase); 
        if(cfgh.dst_is_active == UVM_ACTIVE) begin
            ddrvh.seq_item_port.connect(dseqrh.seq_item_export);
        end  
    endfunction 

endclass