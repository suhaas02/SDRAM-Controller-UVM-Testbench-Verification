class dst_monitor extends uvm_monitor; 

    `uvm_component_utils(dst_monitor)

    virtual sdram_if vif; 
    config_obj cfgh; 
    uvm_blocking_put_port #(transaction) put_port; 
    transaction xtn; 

    function new(string name, uvm_component parent);
        super.new(name, parent); 
        put_port = new("put_port", this); 
    endfunction 

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase); 

        if(!uvm_config_db #(config_obj)::get(this, "", "config_obj", cfgh))
            `uvm_fatal("NO_CFG_OBJ", "No config object found")

    endfunction 

    function void connect_phase(uvm_phase phase);
        vif = cfgh.vif; 
    endfunction

    task run_phase(uvm_phase phase); 
        forever begin 
            collect_data(); 
        end 
    endtask 

    task collect_data(); 
        `uvm_info(get_type_name(), "In dst_monitor run_phasse", UVM_LOW)
         @(posedge vif.in_HCLK); 
        xtn = transaction::type_id::create("xtn"); 
        while(vif.out_HREADY === 1'b0 || vif.out_HREADY === 1'bx) begin 
            @(posedge vif.in_HCLK); 
        end 
        xtn.out_HRDATA = vif.out_HRDATA; 
        put_port.put(xtn); 
    endtask

endclass