module router_fifo_tb();
reg clk, resetn, soft_reset, w_en, r_en, lfd_state;
reg [7:0]d_in;
wire [7:0]d_out;
wire empty, full;
integer k;
router_fifo dut(clk, resetn, soft_reset, w_en, r_en,
lfd_state, d_in, d_out, empty, full);
initial
begin
clk = 0;
forever #5 clk = ~clk;
end
task initialize;
begin
resetn = 1'b0;
soft_reset = 1'b0;
w_en = 1'b0;
r_en = 1'b0;
lfd_state = 1'b0;
d_in = 8'd0;
clk = 1'b0;
end
endtask
task rst;
begin
@(negedge clk)
resetn = 1'b0;
@(negedge clk)
resetn = 1'b1;
end
endtask
task write;
reg [7:0]payload_data, parity, header;
reg [5:0]payload_len;
reg [1:0]addr;
begin
@(negedge clk)
payload_len = 6'd14;
addr = 2'b01;
header = {payload_len, addr};
d_in = header;
lfd_state = 1'b1;
w_en = 1'b1;
r_en = 1'b0;
for(k=0; k<payload_len; k=k+1)
begin
@(negedge clk)
lfd_state = 1'b0;
payload_data = {$random}%256;
d_in = payload_data;
end
@(negedge clk)
parity = {$random}%256;
d_in = parity;
end
endtask
task read(input i, input j);
begin
@(negedge clk)
w_en = i;
r_en = j;
end
endtask
initial
begin
initialize;
rst;
write;
read(1'b0, 1'b1);
#300 soft_reset = 1'b1;
end
initial 
$monitor("rst=%b,soft_rst=%b, clk=%b, re=%b, we=%b,lfd=%b, din=%b, dout=%b, empty=%b, full=%b",resetn,soft_reset,clk,r_en,w_en,lfd_state,d_in,d_out,empty,full);

endmodule
