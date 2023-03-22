module router_top_tb();
reg clock, resetn, pkt_valid, read_enb_0, read_enb_1, read_enb_2;
reg [7:0] data_in;
wire vld_out_0, vld_out_1, vld_out_2, err, busy;
wire [7:0] data_out_0, data_out_1, data_out_2;

router_top DUT(clock,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2,data_in,vld_out_0,vld_out_1,vld_out_2,err,busy,data_out_0,data_out_1,data_out_2);

initial begin
clock=1;
forever
#5 clock=~clock;
end

task initialize();
begin
resetn = 1'b0;
pkt_valid = 1'b0;
{read_enb_0,read_enb_1,read_enb_2,data_in} = 0;
end
endtask


task rst();
begin
@(negedge clock)
resetn = 1'b0;
@(negedge clock)
resetn = 1'b1;
end
endtask

task packet_14;
reg [7:0] payload_data,parity,header;
reg [5:0] payload_length;
reg [1:0] address;
integer i;
begin
@(negedge clock)
wait (~busy)
begin
@ (negedge clock);
payload_length = 6'd14;
address = 2'b00;
header = {payload_length , address};
parity = 8'b0;
data_in = header;
pkt_valid = 1'b1;
parity = parity ^ data_in;
end
@ (negedge clock);

for(i=0 ; i < payload_length ; i=i+1)
begin
wait (~ busy)
@ (negedge clock)
payload_data ={$random}%256;
data_in = payload_data;
parity = parity ^ data_in;
end
wait (~ busy)
@ (negedge clock)

pkt_valid = 1'b0;
data_in = parity;
end
endtask
/*task packet_14();
reg [7:0] payload_data, header, parity;
reg [5:0] payload_len;

integer k;
begin
parity=0;
 wait(~busy)
@(negedge clock)
 payload_len = 14;
 
 pkt_valid = 1'b1;
 header = {payload_len, 2'b00};
 
 data_in = header;
 
 parity = parity ^ data_in;
@(negedge clock)
 
 for(k=0; k<payload_len; k=k+1)
 begin
 wait(~busy)
@(negedge clock)
 
payload_data = {$random}%256;
data_in = payload_data;
parity = parity ^ data_in;
 end
 
 wait(!busy)
 @(negedge clock)
 pkt_valid=0;
 data_in=parity;
 repeat(30)
 @(negedge clock)
 read_enb_1=1'b1;
end
endtask


task packet_16();
reg [7:0] payload_data,header, parity;
reg [5:0] payload_len;
reg [1:0] addr;
integer k;
begin

 wait(~busy)
@(negedge clock)
 payload_len = 6'd14;
 addr = 2'b01;
 header = {payload_len, addr};
 parity = 8'b0;
 data_in = header;
 pkt_valid = 1'b1;
 parity = parity ^ header;
@(negedge clock)
 
 for(k=0;k<payload_len;k=k+1)
 begin
 @(negedge clock)
 wait(~busy)
 payload_data = {$random}%256;
data_in = payload_data;
parity = parity ^ data_in;
 end
 @(negedge clock)
 wait(~busy)
 pkt_valid=1'b0;
 data_in = parity;
end
endtask*/
 
initial
begin
initialize;
rst;
#10;
packet_14;
@ (negedge clock)
read_enb_0 = 1'b1;
wait (!vld_out_0)
@ (negedge clock);
read_enb_0 = 1'b0;
#10;
/*
packet_14;
@(negedge clock)
read_enb_1 = 1'b1;
wait(!vld_out_1)
@(negedge clock)
read_enb_1 = 1'b0;
#10;
packet_16;
@(negedge clock)
read_enb_1 = 1'b1;
wait(!vld_out_1)
@(negedge clock)
read_enb_1 = 1'b0;
*/
end
initial

$monitor("Inputs clock=%b resetn=%b read_enb_1=%b pkt_valid=%b data_in=%b outputs data_out_0=%b vld_out_0=%b err=%b busy=%b",clock, resetn,read_enb_1, pkt_valid, data_in, data_out_0, vld_out_0, err, busy);


endmodule