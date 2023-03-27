interface router_src_if(input bit clock);
logic [7:0]data_in;
logic pkt_valid;
logic resetn;
logic busy;
logic err;


clocking src_dr_cb@(posedge clock);
default input #1 output #1;
output data_in;
output pkt_valid;
output resetn;
input busy;
endclocking


clocking src_mon_cb@(posedge clock);
default input#1 output #1;
input data_in;
input pkt_valid;
input resetn;
input busy;
endclocking

modport SRC_DR_MP(clocking src_dr_cb);
modport SRC_MON_MP(clocking src_mon_cb);

endinterface
