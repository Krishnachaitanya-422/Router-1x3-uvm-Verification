class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item) ;
   
    // Factory Registration
	`uvm_component_utils(router_virtual_sequencer)

   // Declare dynamic array of handles for ram_wr_sequencer and ram_rd_sequencer as wr_seqrh[] & rd_seqrh[]

	router_src_sequencer s_seqrh[];
	router_dst_sequencer d_seqrh[];

    // Declare handle for ram_env_config 
   	 router_env_config m_cfg;
	 
	 
	// src and dst seq handles
	// 
endclass
