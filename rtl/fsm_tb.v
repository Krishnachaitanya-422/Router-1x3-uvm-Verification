module fsm_tb();

reg clk,rst,pktvalid,parity_done,srst0,srst1,srst2,fifofull,lowpktvalid;
reg fifoe0,fifoe1,fifoe2;
reg [1:0]din;

wire detect_add,ld_state,laf_state,full_state,lfd_state,we_en_reg,rst_int_reg,busy;

fsm DUT(clk,rst,pktvalid,parity_done,srst0,srst1,srst2,fifofull,lowpktvalid,fifoe0,fifoe1,fifoe2,din,detect_add,ld_state,laf_state,full_state,lfd_state,we_en_reg,rst_int_reg,busy);

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
pktvalid=0;
parity_done=0;
{srst0,srst1,srst2,fifofull,lowpktvalid,fifoe0,fifoe1,fifoe2}=1'b0;
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

//tasks for the checking the flow of fsm

task DA_LFD_LD_LP_CPERROR_FFS_LAF_DA();
begin
pktvalid=1'b1;
din=2'b01;
fifoe1=1;
#30 fifofull=0;
pktvalid=0;
#20 fifofull=1;
#40 fifofull=0;
#20 parity_done=1;


end
endtask 

task DA_LFD_LD_FFS_LAF_LD_LP_CPERROR_DA();
begin
pktvalid=1'b1;
din=2'b01;
fifoe1=1;
#30 fifofull=1;
#20 fifofull=0;
#20 parity_done=1;
lowpktvalid=0;
#40 fifofull=0;
pktvalid=0;



end
endtask 

initial
begin
initialize;
#10;
reset;
#10;
DA_LFD_LD_LP_CPERROR_FFS_LAF_DA;
#20;
DA_LFD_LD_FFS_LAF_LD_LP_CPERROR_DA;
#20;
DA_LFD_LD_LP_CPERROR_FFS_LAF_DA;



end

endmodule
