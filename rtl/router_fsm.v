module router_fsm(clock,resetn,pkt_valid,data_in,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,parity_done,detect_add,busy,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
input wire[1:0] data_in;
input clock,resetn,pkt_valid,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,parity_done;
output detect_add,busy,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;
parameter decode_address=3'b000,
          load_first_data=3'b001,
	  load_data=3'b010,
	  fifo_full_state=3'b011,
	  load_after_full=3'b100,
			 load_parity=3'b101,
			 check_parity_error=3'b110,
			 wait_till_empty=3'b111;
reg [2:0] pre_state,next_state;
always@(posedge clock)
begin
if(~resetn)
pre_state<=decode_address;
else if((soft_reset_0&&data_in==2'b00)||(soft_reset_1&&data_in==2'b01)||(soft_reset_2&&data_in==2'b10))
pre_state<=decode_address;
else
pre_state<=next_state;
end

always@(*)
begin
if(data_in!=2'b11)
begin
next_state<=decode_address;
case(pre_state)
decode_address:begin
               if((pkt_valid&&(data_in[1:0]==0&&fifo_empty_0))||(pkt_valid&&(data_in[1:0]==1&&fifo_empty_1))||(pkt_valid&&(data_in[1:0]==2&&fifo_empty_2)))
					next_state<=load_first_data;
					else if((pkt_valid&&(data_in[1:0]==0&&(!fifo_empty_0)))||(pkt_valid&&(data_in[1:0]==1&&(!fifo_empty_1)))||(pkt_valid&&(data_in[1:0]==2&&(!fifo_empty_2))))
					next_state<=wait_till_empty;
					else
					next_state<=decode_address;
					end
load_first_data:next_state<=load_data;
load_data:begin
          if(fifo_full)
			 next_state<=fifo_full_state;
			 else if((!fifo_full)&&(!pkt_valid))
			 next_state<=load_parity;
			 else
			 next_state<=load_data;
			 end
fifo_full_state:begin
                if(!fifo_full)
					 next_state<=load_after_full;
					 else
					 next_state<=fifo_full_state;
					 end
load_after_full:begin
                if((!parity_done)&&(!low_pkt_valid))
					 next_state<=load_data;
					 else if((!parity_done)&&low_pkt_valid)
					 next_state<=load_parity;
					 else if(parity_done)
					 next_state<=decode_address;
					 else
					 next_state<=load_after_full;
					 end
load_parity:next_state<=check_parity_error;
check_parity_error:begin
                   if(fifo_full)
						 next_state<=fifo_full_state;
						 else if(!fifo_full)
						 next_state<=decode_address;
						 end
default:next_state<=decode_address;
endcase
end
end

assign detect_add=(pre_state==decode_address)?1'b1:1'b0;
assign lfd_state=(pre_state==load_first_data)?1'b1:1'b0;
assign ld_state=(pre_state==load_data)?1'b1:1'b0;
assign full_state=(pre_state==fifo_full_state)?1'b1:1'b0;
assign laf_state=(pre_state==load_after_full)?1'b1:1'b0;
assign write_enb_reg=((pre_state==load_data)||(pre_state==load_parity)||(pre_state==load_after_full))?1'b1:1'b0;
assign busy=((pre_state==load_first_data)||(pre_state==fifo_full_state)||(pre_state==load_parity)||(pre_state==load_after_full)||(pre_state==wait_till_empty)||(pre_state==check_parity_error))?1'b1:1'b0;
assign rst_int_reg=(pre_state==check_parity_error)?1'b1:1'b0;
endmodule

