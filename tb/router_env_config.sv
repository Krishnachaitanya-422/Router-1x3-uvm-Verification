//class

class router_env_config extends uvm_object;


	// UVM Factory Registration Macro
	`uvm_object_utils(router_env_config)

	//------------------------------------------
	// Data Members
	//------------------------------------------
	// Whether env analysis components are used:
	bit has_functional_coverage = 0;
	bit has_wagent_functional_coverage = 0;
	bit has_scoreboard = 1;
	// Whether the various agents are used:
	bit has_wagent = 1;
	bit has_ragent = 1;
	// Whether the virtual sequencer is used:
	bit has_virtual_sequencer = 1;
	//dynamic array Configuration handles for the sub_components
	router_src_agent_config m_wr_agent_cfg[];
	router_dst_agt_config m_rd_agent_cfg[];
	int no_of_sources=1;
	int no_of_clients=3;
	



	//------------------------------------------
	// Methods
	//------------------------------------------
	// Standard UVM Methods:
	extern function new(string name = "router_env_config");

endclass: router_env_config
//-----------------  constructor new method  -------------------//

function router_env_config::new(string name = "router_env_config");
  super.new(name);
endfunction
