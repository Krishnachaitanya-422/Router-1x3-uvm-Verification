module router_sync(clock,resetn,read_enb_0,read_enb_1,read_enb_2,write_enb_reg,detect_add,data_in,empty_0,empty_1,empty_2,full_0,full_1,full_2,soft_reset_0,soft_reset_1,soft_reset_2,write_enb,fifo_full,vld_out_0,vld_out_1,vld_out_2);
input clock,resetn,read_enb_0,read_enb_1,read_enb_2,write_enb_reg,detect_add,empty_0,empty_1,empty_2,full_0,full_1,full_2;
input [1:0]data_in;
output reg soft_reset_0,soft_reset_1,soft_reset_2,fifo_full;
output reg [2:0]write_enb;
output vld_out_0,vld_out_1,vld_out_2;
reg [1:0]temp_reg;
reg [5:0] timer0,timer1,timer2;

always@(posedge clock)
begin
if(~resetn)
temp_reg<=0;
else if(detect_add)
temp_reg<=data_in;
end

always@(*)
begin
if(write_enb_reg)
begin
case(temp_reg)
2'b00:write_enb<=3'b001;
2'b01:write_enb<=3'b010;
2'b10:write_enb<=3'b100;
default:write_enb<=3'b000;
endcase
end
else
write_enb<=3'b000;
end

always@(*)
begin
case(temp_reg)
2'b00:fifo_full<=full_0;
2'b01:fifo_full<=full_1;
2'b10:fifo_full<=full_2;
endcase
end

assign vld_out_0=!(empty_0);
assign vld_out_1=!(empty_1);
assign vld_out_2=!(empty_2);

always@(posedge clock)
begin
if(~resetn)
begin
timer0<=0;
soft_reset_0<=0;
end
else if(vld_out_0)
begin
if((!read_enb_0))
begin
if(timer0==6'd29)
begin
soft_reset_0<=1;
timer0<=0;
end
else 
begin
timer0<=timer0+1'b1;
soft_reset_0<=0;
end
end
end
end

always@(posedge clock)
begin
if(~resetn)
begin
timer1<=0;
soft_reset_1<=0;
end
else if(vld_out_1)
begin
if((!read_enb_1))
begin
if(timer1==6'd29)
begin
soft_reset_1<=1;
timer1<=0;
end
else 
begin
timer1<=timer1+1'b1;
soft_reset_1<=0;
end
end
end
end

always@(posedge clock)
begin
if(~resetn)
begin
timer2<=0;
soft_reset_2<=0;
end
else if(vld_out_2)
begin
if((!read_enb_2))
begin
if(timer2==6'd29)
begin
soft_reset_2<=1;
timer2<=0;
end
else 
begin
timer2<=timer2+1'b1;
soft_reset_2<=0;
end
end
end
end

endmodule
