//class
class dst_trxn extends uvm_sequence_item;

	`uvm_object_utils(dst_trxn)

	bit [`HEADER-1:0] header;
	bit [`PARITY-1:0] parity;
	bit [`payload-1:0] payload[];
	
	rand int xtn_delay;
	
	constraint U{xtn_delay<30 && xtn_delay>0;}
	
	
	extern function new( string name="dst_trxn");
	extern function void do_print(uvm_printer printer);
endclass

function dst_trxn::new(string name = "dst_trxn");
	super.new(name);
endfunction:new

function void dst_trxn::do_print (uvm_printer printer);

	super.do_print(printer);
	
	//              	srting name   		bitstream value     size    radix for printing
    printer.print_field( "header", 			this.header, 	    	8,		 UVM_DEC		);
	
	foreach(payload[i])
    printer.print_field( "payload", 		this.payload[i], 	    8,		 UVM_DEC		);
	
    printer.print_field( "parity", 			this.parity, 	    	8,		 UVM_DEC		);



endfunction:do_print