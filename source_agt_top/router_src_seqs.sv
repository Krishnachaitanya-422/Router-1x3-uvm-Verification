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

class router_sbase_seq_c1 extends router_sbase_seq;
	`uvm_object_utils(router_sbase_seq_c1);
	//bit[1:0] addr;
	extern function new(string name="router_sbase_seq_c1");
	extern task body;
	
endclass

function router_sbase_seq_c1::new(string name="router_sbase_seq_c1");
	super.new(name);
endfunction

task router_sbase_seq_c1::body;
	//repeat(5)
	//begin
		req=trxn::type_id::create("router_sbase_seq");
		start_item(req);
		assert(req.randomize with {header[7:2] ==10;});
		finish_item(req);
	//end
endtask

//inside {[1:15]} && header[1:0]