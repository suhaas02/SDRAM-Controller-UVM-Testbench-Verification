class src_monitor extends uvm_monitor; 
    `uvm_component_utils(src_monitor)

    virtual sdram_if vif; 
    config_obj cfgh; 
    transaction xtn; 
    uvm_blocking_put_port #(transaction) put_port;

    covergroup cg; 
        RESET: coverpoint xtn.in_HRESET{
            bins zero = {0}; 
            bins one = {1}; 
        }
        WRITE: coverpoint xtn.in_HWRITE{
            bins zero = {0}; 
            bins one = {1}; 
        }
        SEL: coverpoint xtn.in_HSEL{
            bins zero = {0}; 
            bins one = {1}; 
        }
    endgroup

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
        put_port = new("put_port", this); 
        cg = new; 
    endfunction 

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase); 
        if(!uvm_config_db #(config_obj)::get(this, "", "config_obj", cfgh))
            `uvm_fatal("NO_CFG_OBJ", "Config object not found")
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
        @(posedge vif.in_HCLK); 
        `uvm_info(get_type_name(), "In src monitor run_phase", UVM_LOW)
        if(!vif.in_HRESET) begin
            while(vif.out_write_en === 1'b1 || vif.out_write_en === 1'bX) begin 
                @(posedge vif.in_HCLK); 
            end 
            xtn = transaction::type_id::create("xtn");
            xtn.in_HWDATA = vif.in_HWDATA; 
            put_port.put(xtn); 
            cg.sample(); 
        end 
    endtask 

endclass


