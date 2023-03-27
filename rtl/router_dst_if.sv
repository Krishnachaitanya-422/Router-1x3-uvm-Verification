interface router_dst_if(input bit clock);
bit vld_out;
bit rd_en;
logic  [7:0] dout;

clocking dst_dr_cb@(posedge clock);
default input #1 output #1;
output rd_en;
input vld_out;
endclocking


clocking dst_mon_cb@(posedge clock);
default input #1 output #1;
input rd_en;
input dout;
endclocking

modport DST_DR_MP(clocking dst_dr_cb);
modport DST_MON_MP(clocking dst_mon_cb);

endinterface



