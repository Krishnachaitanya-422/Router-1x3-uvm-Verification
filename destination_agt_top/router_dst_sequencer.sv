//class

// Extend router_dst_sequencer from uvm_sequencer parameterized by dst_trxn
class router_dst_sequencer extends uvm_sequencer #(dst_trxn);

	// Factory registration using `uvm_component_utils
	`uvm_component_utils(router_dst_sequencer)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_dst_sequencer",uvm_component parent);
endclass
//-----------------  constructor new method  -------------------//

function router_dst_sequencer::new(string name="router_dst_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction