class router_scoreboard extends uvm_scoreboard;

uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh1;
uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh2;
uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh3;
uvm_tlm_analysis_fifo #(trxn) fifo_wrh;
`uvm_component_utils(router_scoreboard)



extern function new(string name,uvm_component parent);
endclass

function router_scoreboard::new(string name,uvm_component parent);
	super.new(name,parent);
	
	fifo_wrh=new("fifo_wrh",this);
	fifo_rdh1=new("fifo_rdh1",this);
	fifo_rdh2=new("fifo_rdh2",this);
	fifo_rdh3=new("fifo_rdh3",this);
	
endfunction