class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item) ;
   
    // Factory Registration
	`uvm_component_utils(router_virtual_sequencer)

   // Declare dynamic array of handles for router_wr_sequencer and ram_rd_sequencer as wr_seqrh[] & rd_seqrh[]
	router_dst_sequencer v_seqrh;
	router_src_sequencer s_seqrh[];
	router_dst_sequencer d_seqrh[];

    // Declare handle for router_env_config 
   	 router_env_config m_cfg;
	 
	extern function new(string name="router_virtual_sequence");
	extern task body;
	
endclass


function router_virtual_sequence::new(string name="router_virtual_sequence");
	super.new(name);
endfunction

task router_virtual_sequence::body;

	



endtask
