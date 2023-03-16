//class
class dst_trxn extends uvm_sequence_item;

`uvm_object_utils(dst_trxn)


extern function new( string name="dst_trxn");
endclass

function dst_trxn::new(string name = "dst_trxn");
	super.new(name);
endfunction:new