class environment extends uvm_env; 
    `uvm_component_utils(environment)

    src_agent sagh; 
    dst_agent dagh; 
    virtual_sequencer vseqrh; 
    scoreboard sbh; 

    function new(string name , uvm_component parent); 
        super.new(name, parent); 
    endfunction 

    function void build_phase(uvm_phase phase); 
        super.build_phase(phase); 
        sagh = src_agent::type_id::create("sagh", this); 
        dagh = dst_agent::type_id::create("dagh", this); 
        vseqrh = virtual_sequencer::type_id::create("vseqrh", this); 
        sbh = scoreboard::type_id::create("sbh", this); 
    endfunction

    function void connect_phase(uvm_phase phase); 
        super.connect_phase(phase); 
        vseqrh.sseqrh = sagh.sseqrh; 

        sagh.smonh.put_port.connect(sbh.sfifoh.put_export);
        dagh.dmonh.put_port.connect(sbh.dfifoh.put_export); 
    endfunction 

endclass

