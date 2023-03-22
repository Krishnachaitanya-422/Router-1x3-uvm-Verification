module fsm(clk,rst,pktvalid,parity_done,srst0,srst1,srst2,fifofull,lowpktvalid,fifoe0,fifoe1,fifoe2,din,detect_add,ld_state,laf_state,full_state,lfd_state,we_en_reg,rst_int_reg,busy);
input clk,rst,pktvalid,parity_done,srst0,srst1,srst2,fifofull,lowpktvalid;
input fifoe0,fifoe1,fifoe2;
input [1:0]din;

output detect_add,ld_state,laf_state,full_state,lfd_state,we_en_reg,rst_int_reg,busy;

parameter DECODE_ADD=4'b0001,
			LFD=4'b0010,
			LD=4'b0011,
			FFS=4'b0100,
			LAF=4'b0101,
			LP=4'b0110,
			CPERROR=4'b0111,
			WAIT_TILL_EMPTY=4'b1000;
			
reg [3:0] present_state,nxt_state;
reg [1:0] add;

always @(posedge clk)
begin
if(!rst)
add<=1'b0;
else if((srst0&&din==2'b00)||(srst1&&din==2'b01)||(srst2&&din==2'b10))
add<=0;
else
add<=din;
end

always @(posedge clk)
begin
if(!rst)
present_state=DECODE_ADD;
else if((srst0&&din==2'b00)||(srst1&&din==2'b01)||(srst2&&din==2'b10))
present_state=DECODE_ADD;
else
present_state=nxt_state;
end

always @(*)

begin


nxt_state=DECODE_ADD;

case (present_state)
DECODE_ADD:
begin
			if((pktvalid && (add==2'b00) && fifoe0)||(pktvalid && (din==2'b01) && fifoe1)||(pktvalid && (din==2'b10) &&fifoe2))
				nxt_state=LFD;
			else if ((pktvalid && (din==2'b00) && !fifoe0)||(pktvalid && (din==2'b01) && !fifoe1)||(pktvalid && (din==2'b10) && !fifoe2))
				nxt_state=WAIT_TILL_EMPTY;
				
			else
				nxt_state=DECODE_ADD;
				
				end
LFD:
			nxt_state=LD;
			
LD:
begin
			if(fifofull)
				nxt_state=FFS;
			else if(!pktvalid && !fifofull)
				nxt_state=LP;
			else
				nxt_state=LD;
				
				end
FFS:
begin
			if(!fifofull)
				nxt_state=LAF;
			else
				nxt_state=FFS;
end
LAF:
begin
			if(!parity_done && !lowpktvalid)
				nxt_state=LD;
			else if(!parity_done && lowpktvalid)
				nxt_state=LP;
			else if(parity_done)
				nxt_state=DECODE_ADD;
end				
LP:
			nxt_state=CPERROR;

CPERROR:
begin
			if(!fifofull)
				nxt_state=DECODE_ADD;
			else
				nxt_state=FFS;
end
WAIT_TILL_EMPTY:
begin
			if ((fifoe0 && (add==2'b00))||(fifoe1 && (add==2'b01))||(fifoe2 && (add==2'b10)))
				nxt_state=LFD;
			else
				nxt_state=WAIT_TILL_EMPTY;
				
				end
				
default: nxt_state=DECODE_ADD;
endcase
end


assign detect_add=(present_state==DECODE_ADD)?1'b1:1'b0;
assign lfd_state=(present_state==LFD)?1'b1:1'b0;
assign ld_state=(present_state==LD)?1'b1:1'b0;
assign laf_state=(present_state==LAF)?1'b1:1'b0;
assign rst_int_reg=(present_state==CPERROR)?1'b1:1'b0;
assign full_state=(present_state==FFS)?1'b1:1'b0;
assign we_en_reg=((present_state==LAF)||(present_state==LD)||(present_state==LP))?1'b1:1'b0;
assign busy=((present_state==LP)||(present_state==LFD)||(present_state==LAF)||(present_state==CPERROR)||(present_state==FFS)||(present_state==WAIT_TILL_EMPTY))?1'b1:1'b0;

endmodule