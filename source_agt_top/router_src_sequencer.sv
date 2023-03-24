//class

// Extend router_scr_sequencer from uvm_sequencer parameterized by write_xtn
class router_src_sequencer extends uvm_sequencer #(trxn);

	// Factory registration using `uvm_component_utils
	`uvm_component_utils(router_src_sequencer)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_src_sequencer",uvm_component parent);
endclass

//-----------------  constructor new method  -------------------//
function router_src_sequencer::new(string name="router_src_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction