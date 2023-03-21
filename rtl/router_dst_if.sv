interface router_dst_if(input bit clk);
//decleration
bit rd_en;
logic [7:0]dout;
bit vld_out;

//cocking blocks
clocking dst_mon_cb@(posedge clk);
default input#1 output #1;
		input dout;
		input rd_en;
		
endclocking

clocking dst_dr_cb@(posedge clk);

default input#1 output #1;

		input vld_out;
		output rd_en;
endclocking

//modport

modport DST_DR_MP(clocking dst_dr_cb);
modport DST_MON_MP(clocking dst_mon_cb);

endinterface
