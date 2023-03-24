module router_top(clock,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2,data_in,vld_out_0,vld_out_1,vld_out_2,err,busy,data_out_0,data_out_1,data_out_2);
input clock,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2;
input [7:0] data_in;
output vld_out_0,vld_out_1,vld_out_2,err,busy;
output [7:0] data_out_0,data_out_1,data_out_2;
wire [2:0] write_enb;
wire [7:0] dout;
fsm fsm(clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,empty_0,empty_1,empty_2,data_in[1:0],detect_add,ld_state,laf_state,full_state,lfd_state,wr_en_reg,rst_int_reg,busy);

sync s(clock,resetn,detect_add,wr_en_reg,data_in[1:0],empty_0,empty_1,empty_2,full_0,full_1,full_2,read_enb_0,read_enb_1,read_enb_2,write_enb,
fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,vld_out_0,vld_out_1,vld_out_2);

register r1(clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,data_in,parity_done,low_pkt_valid,err, dout);

router_fifo f0(clock,resetn,soft_reset_0,write_enb[0],read_enb_0,lfd_state,dout,data_out_0,empty_0,full_0);
router_fifo f1(clock,resetn,soft_reset_1,write_enb[1],read_enb_1,lfd_state,dout,data_out_1,empty_1,full_1);
router_fifo f2(clock,resetn,soft_reset_2,write_enb[2],read_enb_2,lfd_state,dout,data_out_2,empty_2,full_2);
endmodule