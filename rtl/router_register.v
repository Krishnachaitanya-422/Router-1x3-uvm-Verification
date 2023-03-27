module router_reg(clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,err,data_out,low_pkt_valid,parity_done);
input wire [7:0] data_in;
input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
output reg [7:0] data_out;
output reg err,low_pkt_valid,parity_done;
reg [7:0] Header_byte,fifo_full_state,internal_parity,packet_parity;

//headerbyte and fifo_full_state
always@(posedge clock)
begin
if(~resetn)
{fifo_full_state,Header_byte}<=0;
else 
begin
if(detect_add&&pkt_valid)
Header_byte<=data_in;
else if(ld_state && fifo_full)
fifo_full_state<=data_in;
end
end

//dout logic
always@(posedge clock)
begin
if(~resetn)
data_out<=0;
else
begin
if(lfd_state)
data_out<=Header_byte;
else if(ld_state&&(~fifo_full))
data_out<=data_in;
else if(laf_state)
data_out<=fifo_full_state;
end
end

//parity_done logic
always@(posedge clock)
begin
if(~resetn)
parity_done<=0;
else
begin
if(ld_state&&~pkt_valid&&~fifo_full)
parity_done<=1;
else if(laf_state&&~parity_done&&low_pkt_valid)
parity_done<=1;
if(detect_add)
parity_done<=0;
end
end


//packet parity
always@(posedge clock)
begin
if(~resetn)
packet_parity<=0;
else if((ld_state&&~pkt_valid&&~fifo_full)||(laf_state&&low_pkt_valid&&~parity_done))
packet_parity<=data_in;
else
begin
if(detect_add)
packet_parity<=0;
end
end


//low_pkt_valid logic
always@(posedge clock)
begin
if(~resetn)
low_pkt_valid<=0;
else
begin
if(ld_state&&~pkt_valid)
low_pkt_valid<=1;
if(rst_int_reg)
low_pkt_valid<=0;
end
end

//internal parity
always@(posedge clock)
begin
if(~resetn)
internal_parity<=0;
else if(detect_add)
internal_parity<=8'b0;
else if(lfd_state)
internal_parity<=internal_parity^Header_byte;
else if(ld_state&&pkt_valid&&~fifo_full)
internal_parity<=internal_parity^data_in;
end

//error logic
always@(posedge clock)
begin
if(!resetn)
err<=1'b0;
else
begin
if(parity_done)
begin
if(internal_parity==packet_parity)
err<=1'b0;
else
err<=1'b1;
end
end
end
endmodule

