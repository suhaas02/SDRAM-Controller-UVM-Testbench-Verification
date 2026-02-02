class src_driver extends uvm_driver #(transaction);
    `uvm_component_utils(src_driver)

    virtual sdram_if vif;
    config_obj cfgh;  
    // bit past_reset; 

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase); 

        if(!uvm_config_db #(config_obj)::get(this, "", "config_obj", cfgh))
            `uvm_fatal("NO_CFG_OBJ", "No Config Object found")
    endfunction 

    function void connect_phase(uvm_phase phase); 
        super.connect_phase(phase); 

        vif = cfgh.vif; 
    endfunction 

    task run_phase(uvm_phase phase); 
        forever begin 
            // `uvm_info(get_type_name(), "In run_phase of wdriver", UVM_LOW)
            seq_item_port.get_next_item(req); 
            // `uvm_info(get_type_name(), "Sent req to sequence", UVM_LOW)
            drive_dut(req); 
            seq_item_port.item_done(); 
        end 
    endtask 

    task drive_dut(transaction req); 
        `uvm_info(get_type_name(), "In src_driver run_phase", UVM_LOW)
        if(req.in_HRESET) begin 
            `uvm_info(get_type_name(), "Reset signal is active", UVM_LOW)
            // vif.in_HCLK <= 0; 
            vif.in_HRESET <= 1; 
            vif.in_HWRITE <= 0; 
            vif.in_HSEL <= 0; 
            vif.in_HWDATA <= 0; 
            vif.in_HADDR <= 0; 
            // past_reset <= 1; 
            @(posedge vif.in_HCLK); 
        end else begin
             
            if(!req.in_HWRITE) begin
                // `uvm_info(get_type_name(), $sformatf("past_reset = %0d", past_reset), UVM_LOW)
                // if(past_reset == 1'b1) begin
                //     `uvm_info(get_type_name(), $sformatf("out_hready = %0d", vif.out_HREADY), UVM_LOW)
                //     while(vif.out_HREADY == 1'b0) begin 
                //         @(posedge vif.in_HCLK); 
                //         `uvm_info(get_type_name(), "I am waiting here", UVM_LOW)
                //     end 
                // end

                @(posedge vif.in_HCLK); 
                `uvm_info(get_type_name(), "Driving write data", UVM_LOW)
                vif.in_HRESET <= 0; 
                // past_reset <= 0; 
                vif.in_HSEL <= req.in_HSEL; 
                vif.in_HWRITE <= req.in_HWRITE;
                vif.in_HWDATA <= req.in_HWDATA; 
                vif.in_HADDR <= req.in_HADDR; 
                
                `uvm_info(get_type_name(), $sformatf("out_write_en = %0d", vif.out_write_en), UVM_LOW)
                while(vif.out_write_en === 1'b1 || vif.out_write_en === 1'bX) begin 
                    @(posedge vif.in_HCLK); 
                end 
                `uvm_info(get_type_name(), "Driver write operation done", UVM_LOW)
            end else begin 
                @(posedge vif.in_HCLK); 
                `uvm_info(get_type_name(), "Driving read data", UVM_LOW)
                vif.in_HRESET <= 0; 
                vif.in_HSEL <= req.in_HSEL; 
                vif.in_HWRITE <= req.in_HWRITE;
                vif.in_HWDATA <= req.in_HWDATA; 
                vif.in_HADDR <= req.in_HADDR;

                while(vif.CAS) begin 
                    @(posedge vif.in_HCLK); 
                end
            end 
        end
    endtask  


endclass

