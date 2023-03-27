module router_fifo(clock,resetn,write_enb,soft_reset,read_enb,data_in,lfd_state,empty,full,data_out);
reg [6:0] fifo_counter;
reg [8:0] mem [15:0];
reg [4:0] rd_ptr,wr_ptr;
reg temp_lfd;
integer i;
output reg [7:0] data_out;
input wire [7:0] data_in;
input clock,resetn,write_enb,soft_reset,read_enb,lfd_state;
output empty,full;

always@(posedge clock)
begin
if(~resetn||soft_reset)
temp_lfd<=0;
else
temp_lfd<=lfd_state;
end



//fifocounter
always@(posedge clock)
begin
/*if(!resetn)
fifo_counter<=0;
else if(soft_reset)
fifo_counter<=0;
else if(read_enb &&(~empty))
begin*/
if(mem[rd_ptr[3:0]][8]==1'b1)
fifo_counter<=mem[rd_ptr[3:0]][7:2]+1'b1;
else if(fifo_counter!=0)
begin
fifo_counter<=fifo_counter-1'b1;
end
end


//read and write pointer
always@(posedge clock)
begin
if(!resetn)
begin
rd_ptr<=0;
wr_ptr<=0;
end
else if(soft_reset)
begin
rd_ptr<=0;
wr_ptr<=0;
end
else 
begin
if((write_enb)&&(!full))
wr_ptr<=wr_ptr+1;
else
wr_ptr<=wr_ptr;
if((read_enb)&&(!empty))
rd_ptr<=rd_ptr+1;
else
rd_ptr<=rd_ptr;
end
end


//write operation
always@(posedge clock)
begin
if(!resetn)
begin
for(i=0;i<16;i=i+1)
mem[i]<=0;
end
else if(soft_reset)
begin
for(i=0;i<16;i=i+1)
mem[i]<=0;
end
else if(write_enb&&(!full))
{mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={lfd_state,data_in};
end


//read operation
always@(posedge clock)
begin
if(!resetn)
data_out<=0;
else if(soft_reset)
data_out<=0;
else if(read_enb&&(!empty))
begin
if(fifo_counter==0&&data_out!=0)
data_out<=8'bz;
else
data_out<=mem[rd_ptr[3:0]][7:0];
end
end

assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
assign full=(wr_ptr=={~rd_ptr[4],rd_ptr[3:0]})?1'b1:1'b0;
endmodule
