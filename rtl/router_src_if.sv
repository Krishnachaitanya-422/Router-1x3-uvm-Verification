interface router_src_if(input bit clk);

logic [7:0]data_in;
logic pkt_valid;
logic resetn;
logic err,busy;


clocking src_dr_cb@(posedge clk);

default input#1 output #1;
		input busy;
		output pkt_valid;
		output data_in;
		output resetn;
endclocking


clocking src_mon_cb@(posedge clk);

default input#1 output #1;
		input pkt_valid;
		input data_in;
		input resetn;
		input busy;
		
endclocking


// modports

modport SRC_DR_MP(clocking src_dr_cb);
modport SRC_MON_MP(clocking src_mon_cb);


endinterface
