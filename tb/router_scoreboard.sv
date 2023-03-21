class router_scoreboard extends uvm_scoreboard;

	uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh1;
	uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh2;
	uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh3;
	uvm_tlm_analysis_fifo #(trxn) fifo_wrh;
	`uvm_component_utils(router_scoreboard)
	
	
	
	extern function new(string name,uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase);
	extern task check (dst_trxn);

endclass

function router_scoreboard::new(string name,uvm_component parent);
	super.new(name,parent);
	
	fifo_wrh=new("fifo_wrh",this);
	fifo_rdh1=new("fifo_rdh1",this);
	fifo_rdh2=new("fifo_rdh2",this);
	fifo_rdh3=new("fifo_rdh3",this);
	
endfunction

task router_scoreboard::check (dst_trxn dst);

	if(rd.header==trxn.header)
		begin
		foreach(rd.payload[i])
			if(rd.payload[i]!=trxn.payload[i])
				begin
				$display("-------------------------------WRONG DATA------------------------------");
				return;
				end
		end
		
	else
	begin $display("-------------------------------HEADER MISMATCH-------------------------------");
	return;
	end
	
	if(rd.parity==trxn.parity)
	$display("-------------------------------------GOOD PACKET-----------------------------------");
	
	else
	$display("-------------------------------------BAD PACKET------------------------------------");	
	
endtask