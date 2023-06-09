module top;

import router_test_pkg::*;
import uvm_pkg::*;

bit clock;

always 
#10 clock=!clock;

router_src_if in(clock);
router_dst_if in0(clock);
router_dst_if in1(clock);
router_dst_if in2(clock);




router_top RTL (.data_in(in.data_in),.pkt_valid(in.pkt_valid),.clock(clock),.resetn(in.resetn),.err(in.err),.busy(in.busy),
		.read_enb_0(in0.rd_en),.data_out_0(in0.dout),.valid_out_0(in0.vld_out),
		.read_enb_1(in1.rd_en),.data_out_1(in1.dout),.valid_out_1(in1.vld_out),
		.read_enb_2(in2.rd_en),.data_out_2(in2.dout),.valid_out_2(in2.vld_out));

initial
	begin
	
		uvm_config_db#(virtual router_src_if) ::set(null,"*","vif",in);
		uvm_config_db#(virtual router_dst_if) ::set(null,"*","vif[0]",in0);
		uvm_config_db#(virtual router_dst_if) ::set(null,"*","vif[1]",in1);
		uvm_config_db#(virtual router_dst_if) ::set(null,"*","vif[2]",in2);
		run_test("router_base_test");
	end


endmodule  

