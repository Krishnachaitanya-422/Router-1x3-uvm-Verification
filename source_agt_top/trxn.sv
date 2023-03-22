class trxn extends uvm_sequence_item;
  
	// UVM Factory Registration Macro
	`uvm_object_utils(trxn)
	// include elements
	rand bit[`HEADER-1 : 0] header;    
	rand bit[`PARITY-1 : 0] parity;
	rand bit [`payload-1 : 0] payload[];
	logic [7:0]internal_parity;
	integer i;
         
	//------------------------------------------
	// CONSTRAINTS
	//------------------------------------------

	constraint a{ header[1:0]!=2'b11;
		      header[7:2] inside {[1:63]};
		      {payload.size==header[7:2]}; 
		    }
	//------------------------------------------
	// METHODS
	//------------------------------------------

	extern function new(string name = "trxn");
	extern function void post_randomize();
	extern function void do_print(uvm_printer printer);

endclass:trxn

	//-----------------  constructor new method  -------------------//
	//Add code for new()

function trxn::new(string name = "trxn");
	super.new(name);
endfunction:new

//-----------------  do_print method  -------------------//
//Use printer.print_field for integral variables
//Use printer.print_generic for enum variables
function void  trxn::do_print (uvm_printer printer);
	super.do_print(printer);

   
    //              	srting name   		bitstream value     size    radix for printing
    printer.print_field( "header", 			this.header, 	    	8,		 UVM_DEC		);
	
	foreach(payload[i])
    printer.print_field( "payload", 		this.payload[i], 	    8,		 UVM_DEC		);
	
    printer.print_field( "parity", 			this.parity, 	    	8,		 UVM_DEC		);

endfunction:do_print
    

function void trxn::post_randomize();
    internal_parity=header;
	foreach(payload[i])
	internal_parity=internal_parity^payload[i];
	
endfunction : post_randomize