//class

// Extend router_dst_agt_top from uvm_env;
class router_dst_agt_top extends uvm_env;

	// Factory Registration
	`uvm_component_utils(router_dst_agt_top)
    
   // Create the agent handle
    router_dst_agent agnth;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_dst_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function router_dst_agt_top::new(string name = "router_dst_agt_top" , uvm_component parent);
	super.new(name,parent);
endfunction

    
//-----------------  build() phase method  -------------------//
function void router_dst_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	// Create the instance of ram_rd_agent
   	agnth=router_dst_agent::type_id::create("agnth",this);
endfunction


//-----------------  run() phase method  -------------------//
// Print the topology
task router_dst_agt_top::run_phase(uvm_phase phase);
	uvm_top.print_topology;
endtask   