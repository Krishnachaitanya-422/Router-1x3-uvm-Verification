//class
class router_sbase_seq extends uvm_sequence #(trxn);

	`uvm_object_utils(router_sbase_seq)  
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
    extern function new(string name ="router_sbase_seq");
	




endclass

//-----------------  constructor new method  -------------------//
function router_sbase_seq::new(string name ="router_sbase_seq");
	super.new(name);
endfunction