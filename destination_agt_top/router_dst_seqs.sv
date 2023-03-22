//class
class router_dbase_seq extends uvm_sequence #(dst_trxn);

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

class router_dbase_seq_c1 extends router_dbase_seq;
	`uvm_object_utils(router_dbase_seq_c1);
	
	extern function new(string name="router_dbase_seq_c1");
	extern task body;
	
endclass

function router_dbase_seq_c1::new(string name="router_dbase_seq_c1");
	super.new(name);
endfunction

task router_dbase_seq_c1::body;

	req=dst_trxn::type_id::create("router_dbase_seq_c1");
	start_item(req);
	assert (req.randomize);
	finish_item(req);
	
endtask
