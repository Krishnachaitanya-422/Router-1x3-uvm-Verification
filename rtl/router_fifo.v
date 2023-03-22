module router_fifo(clk, resetn, soft_reset, w_en, r_en,
lfd_state, d_in, d_out, empty, full);
input clk, resetn, soft_reset, w_en, r_en, lfd_state;
input [7:0]d_in;
output reg [7:0]d_out;
output empty, full;
reg [4:0]w_ptr,r_ptr;
reg [5:0]count;
reg [8:0] mem[15:0];
integer i;

always@(posedge clk)
begin
if(!resetn)
begin
for(i=0; i<16; i=i+1)
begin
mem[i] <= 0;
end
end
else if(soft_reset)
begin
for(i=0; i<16; i=i+1)
begin
mem[i] <= 0;
end
end
else
if(w_en && !full)
begin
mem[w_ptr[4:0]] <= {lfd_state, d_in};
end
end
always@(posedge clk)
begin
if(!resetn)
begin
d_out <= 8'h00;
end
else if(soft_reset)
begin
d_out <= 8'hzz;
end
else
if(r_en && !empty)
begin
d_out <= mem[r_ptr[3:0]];
end
end
always@(posedge clk)
begin
if(!resetn)
{w_ptr, r_ptr} <= 0;
if(soft_reset)
{w_ptr, r_ptr} <= 0;
else
begin
if(w_en && !full)
w_ptr <= w_ptr + 1'b1;
if(r_en && !empty)
r_ptr <= r_ptr + 1'b1;
end
end
always@(posedge clk)
begin
if(!resetn || soft_reset)
count <= 0;
else if(r_en && !empty)
begin
if(mem[r_ptr[4:0]][0] == 1'b1)
count <= mem[r_ptr[3:0]][7:2] + 1'b1;
else if(count != 6'd0)
count <= count - 1;
end
end

assign empty = (r_ptr == w_ptr) ? 1'b1 : 1'b0;
assign full = (w_ptr == 5'd16) ? 1'b1 : 1'b0;
endmodule
