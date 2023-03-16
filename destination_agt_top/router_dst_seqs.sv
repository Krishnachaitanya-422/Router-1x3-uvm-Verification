//class
class router_dbase_seq extends uvm_sequence #(trxn);

	`uvm_object_utils(router_dbase_seq)  
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
    extern function new(string name ="router_dbase_seq");
	




endclass

//-----------------  constructor new method  -------------------//
function router_dbase_seq::new(string name ="router_dbase_seq");
	super.new(name);
endfunction