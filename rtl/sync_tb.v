module sync_tb();

reg clk,rst,detect_add,wr_en_reg,e0,e1,e2,f0,f1,f2,re0,re1,re2;
reg [1:0]din;

wire [2:0]we;
wire fifofull,srst0,srst1,srst2,vldout0,vldout1,vldout2;

sync DUT(clk,rst,detect_add,wr_en_reg,din,e0,e1,e2,f0,f1,f2,re0,re1,re2,we,fifofull,srst0,srst1,srst2,vldout0,vldout1,vldout2);

//clk generation
initial
begin
clk=1'b0;

forever #5 clk=~clk;

end

//initialization

task initialize;
begin
clk=0;
rst=0;
detect_add=0;
wr_en_reg=0;
{re0,re1,re2,e0,e1,e2,f0,f1,f2}=1'b0;
din=2'b0;

end

endtask

//reset
task reset;
begin
@(negedge clk)
rst=1'b0;
#10;
@(negedge clk)
rst=1'b1;
end
endtask

//delay

task delay();

begin
#10;
end
endtask

//input data

task data(input[1:0] i);
begin
@(negedge clk)
din=i;
end
endtask

initial
begin

initialize;
reset;
delay;

data(01);

detect_add=1'b1;
wr_en_reg=1'b1;
e1=1'b0;
re1=1'b0;
#350;
re1=1'b1;
delay;
e1=1'b1;
delay;

f1=1'b1;

delay;
delay;

data(10);

detect_add=1'b1;
wr_en_reg=1'b1;
e2=1'b0;
re2=1'b0;
#350;
re2=1'b1;
delay;
e2=1'b1;
delay;

f2=1'b1;
end


initial
$monitor ("data_in = %b, write enable=%b",din,we);

endmodule
