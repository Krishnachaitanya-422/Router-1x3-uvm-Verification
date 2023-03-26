class router_scoreboard extends uvm_scoreboard;

	uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh1;
	uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh2;
	uvm_tlm_analysis_fifo #(dst_trxn) fifo_rdh3;
	uvm_tlm_analysis_fifo #(trxn) fifo_wrh;
	`uvm_component_utils(router_scoreboard)
	
	trxn src;
	dst_trxn dst;
	
	
	extern function new(string name,uvm_component parent);
	
	extern task run_phase(uvm_phase phase);
	extern task chk (trxn src,dst_trxn dst);

endclass

function router_scoreboard::new(string name,uvm_component parent);
	super.new(name,parent);
	
	fifo_wrh=new("fifo_wrh",this);
	fifo_rdh1=new("fifo_rdh1",this);
	fifo_rdh2=new("fifo_rdh2",this);
	fifo_rdh3=new("fifo_rdh3",this);
	
endfunction

task router_scoreboard::run_phase(uvm_phase phase);
	fork
		begin
			fifo_wrh.get(src);
		end
		
		begin
		fork
			fifo_rdh1.get(dst);
			fifo_rdh2.get(dst);
			fifo_rdh3.get(dst);
		join_any
		
		disable fork;
		
		end
		
		join
		
			`uvm_info("UVM_SCOREBOARD",$sformatf("The src data is \n %s",src.sprint()),UVM_LOW);
			`uvm_info("UVM_SCOREBOARD",$sformatf("The dst data is \n %s",dst.sprint()),UVM_LOW);
			chk(src,dst);
endtask

task router_scoreboard::chk (trxn src, dst_trxn dst);

	if(dst.header==src.header)
		begin
		foreach(dst.payload[i])
			if(dst.payload[i]!=src.payload[i])
				begin
				$display("-------------------------------WRONG DATA------------------------------");
				return;
				end
		end
		
	else
	begin $display("-------------------------------HEADER MISMATCH-------------------------------");
	return;
	end
	
	if(src.parity==dst.parity)
	$display("-------------------------------------GOOD PACKET-----------------------------------");
	
	else
	$display("-------------------------------------BAD PACKET------------------------------------");	
	
endtask