module router_top(clock,resetn,read_enb_0,read_enb_1,read_enb_2,data_in,pkt_valid,
       data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,valid_out_2,err,busy);
input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
input wire [7:0]data_in;
output valid_out_0,valid_out_1,valid_out_2,err,busy;
output wire [7:0]data_out_0,data_out_1,data_out_2;
wire [7:0]data_out;
wire [2:0]write_enb;


router_fifo  f0(clock,resetn,write_enb[0],soft_reset_0,read_enb_0,data_out,lfd_state,empty_0,full_0,data_out_0);
router_fifo  f1(clock,resetn,write_enb[1],soft_reset_1,read_enb_1,data_out,lfd_state,empty_1,full_1,data_out_1);
router_fifo  f2(clock,resetn,write_enb[2],soft_reset_2,read_enb_2,data_out,lfd_state,empty_2,full_2,data_out_2);

router_fsm  fsm(clock,resetn,pkt_valid,data_in[1:0],soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,empty_0,empty_1,
empty_2,parity_done,detect_add,busy,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);

router_reg reg1(clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,
err,data_out,low_pkt_valid,parity_done);

router_sync   sync(clock,resetn,read_enb_0,read_enb_1,read_enb_2,write_enb_reg,detect_add,data_in[1:0],empty_0,empty_1,
empty_2,full_0,full_1,full_2,soft_reset_0,soft_reset_1,soft_reset_2,write_enb,fifo_full,valid_out_0,valid_out_1,valid_out_2);
endmodule

