class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item) ;
   
    // Factory Registration
	`uvm_component_utils(router_virtual_sequence)
	
	router_virtual_sequencer v_seqrh;
   // Declare dynamic array of handles for router_wr_sequencer and ram_rd_sequencer as wr_seqrh[] & rd_seqrh[]

	router_src_sequencer s_seqrh[];
	router_dst_sequencer d_seqrh[];
	
	router_sbase_seq_c1 s_seqh;
	router_dbase_seq_c1 d_seqh;

    // Declare handle for router_env_config 
   	 router_env_config m_cfg;
	 
	extern function new(string name="router_virtual_sequence");
	extern task body;
	
endclass


function router_virtual_sequence::new(string name="router_virtual_sequence");
	super.new(name);
endfunction

task router_virtual_sequence::body;

	if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"env_config",m_cfg))
			`uvm_fatal("router_virtual_sequence","cannot get config");
			
	$cast(v_seqrh,m_sequencer);
	s_seqrh=new[m_cfg.no_of_sources];
	d_seqrh=new[m_cfg.no_of_clients];
	
	foreach(s_seqrh[i])
		s_seqrh[i]=v_seqrh.s_seqrh[i];
	foreach(d_seqrh[i])
		d_seqrh[i]=v_seqrh.d_seqrh[i];

endtask


class router_virtual_sequence_c1 extends router_virtual_sequence;

	`uvm_component_utils(router_virtual_sequence_c1);
	
	
	
	extern function new(string name="router_virtual_sequence_c1");
	extern task body;
	
endclass

function router_virtual_sequence_c1::new(string name="router_virtual_sequence_c1");
	super.new(name);
endfunction

task router_virtual_sequence_c1::body;
	super.body;
	
	s_seqh=router_sbase_seq_c1::type_id::create("s_seqh");
	
	
	d_seqh=router_dbase_seq_c1::type_id::create("d_seqh");
		
		fork:a
				begin
					//foreach(s_seqrh[i])
						s_seqh.start(s_seqrh[0]);
				end
				
				begin
					fork:b
						d_seqh.start(d_seqrh[0]);
						d_seqh.start(d_seqrh[1]);
						d_seqh.start(d_seqrh[2]);
					join_any
					disable b;
				end
				
		join
endtask