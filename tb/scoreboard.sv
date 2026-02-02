class scoreboard extends uvm_scoreboard; 
    `uvm_component_utils(scoreboard)

    uvm_tlm_fifo #(transaction) sfifoh; 
    uvm_tlm_fifo #(transaction) dfifoh; 
    transaction sxtn, dxtn; 

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
        sfifoh = new("sfifoh", this); 
        dfifoh = new("dfifoh", this); 
    endfunction 

    task run_phase(uvm_phase phase);
        forever begin
            compare_data(); 
        end 
    endtask 

    task compare_data(); 
        `uvm_info(get_type_name(), "In scoreboard run_phase", UVM_LOW)
        sfifoh.get(sxtn); 
        dfifoh.get(dxtn); 
        if(sxtn.in_HWDATA == dxtn.out_HRDATA)
            `uvm_info(get_type_name(), "Data comparision successful", UVM_LOW)
        else    
            `uvm_error(get_type_name(), "Data comparision failed")
    endtask 

endclass