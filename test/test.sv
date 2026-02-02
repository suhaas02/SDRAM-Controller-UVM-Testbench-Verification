class test extends uvm_test; 
    `uvm_component_utils(test)

    environment envh; 
    config_obj cfgh; 
    virtual sdram_if vif; 
    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        envh = environment::type_id::create("envh", this); 
        cfgh = config_obj::type_id::create("cfgh", this); 

        if(!uvm_config_db #(virtual sdram_if)::get(this, "", "sdram_if", cfgh.vif))
            `uvm_fatal("NO_VIF", "Virtual interface not found")

        uvm_config_db #(config_obj)::set(this, "*", "config_obj", cfgh); 
    endfunction 

    function void end_of_elaboration_phase(uvm_phase phase); 
        uvm_top.print_topology();
    endfunction 
endclass

class write_only_test extends test; 

    `uvm_component_utils(write_only_test)

    write_only_vseq wvseqh; 

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        wvseqh = write_only_vseq::type_id::create("wvseqh"); 
    endfunction 

    task run_phase(uvm_phase phase); 
        phase.raise_objection(this); 
        `uvm_info(get_type_name(), "test started", UVM_LOW)
        wvseqh.start(envh.vseqrh); 
        phase.drop_objection(this); 
    endtask 

endclass
    
class write_read_test extends test; 
    `uvm_component_utils(write_read_test)

    write_read_vseq wrvseq;  

    function new(string name, uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase); 
        wrvseq = write_read_vseq::type_id::create("wrvseq"); 
    endfunction 

    task run_phase(uvm_phase phase); 
        phase.raise_objection(this); 
        `uvm_info(get_type_name(), "test started", UVM_LOW) 
        wrvseq.start(envh.vseqrh); 
        phase.drop_objection(this); 
    endtask 

endclass

