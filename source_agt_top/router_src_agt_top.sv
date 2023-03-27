//class 
   // Extend router_src_agt_top from uvm_env;
class router_src_agt_top extends uvm_env;

   // Factory Registration
	`uvm_component_utils(router_src_agt_top)
    
   // Create the agent handle
      	 router_src_agent agnth;
		 router_src_agent_config m_cfg;
		 integer i;
//------------------------------------------
// METHODS
//------------------------------------------

// Standard UVM Methods:
	extern function new(string name = "router_src_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass


//-----------------  constructor new method  -------------------//
   // Define Constructor new() function
   	function router_src_agt_top::new(string name = "router_src_agt_top" , uvm_component parent);
		super.new(name,parent);
	endfunction

    
//-----------------  build() phase method  -------------------//
    function void router_src_agt_top::build_phase(uvm_phase phase);
     	super.build_phase(phase);
// Create the instance of ram_wr_agent
   		agnth=router_src_agent::type_id::create("agnth",this);
		//uvm_config_db #(router_env_config)::set(this, "*", "router_env_config",m_cfg.router_src_agent_config[i]);
	endfunction


//-----------------  run_phase method  -------------------//
       // Print the topology
	task router_src_agt_top::run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask   
